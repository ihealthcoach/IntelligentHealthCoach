//
//  AuthViewModel.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//

// AuthViewModel.swift
import Foundation
import SwiftUI
import Combine
import Supabase

class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showingPasswordReset = false
    @Published var passwordResetSent = false
    
    private let supabaseService: SupabaseServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(supabaseService: SupabaseServiceProtocol = SupabaseService.shared) {
        self.supabaseService = supabaseService
        checkSession()
    }
    
    func checkSession() {
        isLoading = true
        
        Task {
            do {
                // Get the current session
                let authResponse = try await supabaseService.client.auth.session
                let user = authResponse.user

                // Create a user model from the auth user
                let appUser = User(
                    id: user.id,
                    email: user.email,
                    firstName: nil,  // Initially nil, will be populated from profile
                    lastName: nil,
                    avatarUrl: nil
                )
                
                // Debug
                print("⚡️ Initial appUser: \(appUser)")
                
                // Fetch user profile
                await fetchUserProfile(userId: user.id)
                
                // Debug after profile fetch
                print("⚡️ After profile fetch - appUser: \(self.currentUser?.firstName ?? "nil")")
                
                await MainActor.run {
                    self.currentUser = appUser  // This might be overwriting the profile data!
                    self.isAuthenticated = true
                    self.isLoading = false
                    
                    // Debug
                    print("⚡️ Final currentUser: \(self.currentUser?.firstName ?? "nil")")
                }
            } catch {
                // Error handling
            }
        }
    }
    
    
    private func fetchUserProfile(userId: UUID) async {
        do {
            let response = try await supabaseService.client
                .from("profiles")
                .select()
                .eq("user_id", value: userId.uuidString)
                .single()
                .execute()
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let profileData = response.data
            if let profile = try? decoder.decode(UserProfile.self, from: profileData) {
                await MainActor.run {
                    self.currentUser?.firstName = profile.firstName
                    self.currentUser?.lastName = profile.lastName
                    self.currentUser?.avatarUrl = profile.avatarUrl
                }
            }
        } catch {
            print("Error fetching profile: \(error)")
        }
    }
    
    // Define this at the class level (outside of methods)
    private struct ProfileData: Encodable {
        let user_id: String
        let first_name: String
        let last_name: String
    }
    
    private func createUserProfile(userId: String, firstName: String, lastName: String) async throws {
        let profileData = ProfileData(
            user_id: userId,
            first_name: firstName,
            last_name: lastName
        )
        
        let _ = try await supabaseService.client
            .from("profiles")
            .insert(profileData)
            .execute()
    }
    
    func signUp(email: String, password: String, firstName: String = "", lastName: String = "") {
        Task {
            await MainActor.run {
                self.isLoading = true
                self.errorMessage = nil
            }
            
            do {
                // Sign up with Supabase
                let signUpResponse = try await supabaseService.client.auth.signUp(
                    email: email,
                    password: password
                )
                
                // User is now non-optional
                let authUser = signUpResponse.user
                
                let user = User(
                    id: authUser.id,
                    email: authUser.email,
                    firstName: firstName,
                    lastName: lastName,
                    avatarUrl: nil
                )
                
                // If signup is successful, create a profile with the first and last name
                if !firstName.isEmpty || !lastName.isEmpty {
                    try await createUserProfile(userId: authUser.id.uuidString, firstName: firstName, lastName: lastName)
                }
                
                await MainActor.run {
                    self.currentUser = user
                    self.isAuthenticated = true
                    self.isLoading = false  // Set loading to false on success
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = handleAuthError(error)
                    self.isLoading = false  // Set loading to false on error
                }
            }
        }
    }
    
    func signIn(email: String, password: String) {
        Task {
            await MainActor.run {
                self.isLoading = true
                self.errorMessage = nil
            }
            
            do {
                let signInResponse = try await supabaseService.client.auth.signIn(
                    email: email,
                    password: password
                )
                
                // User is now non-optional
                let authUser = signInResponse.user
                
                let user = User(
                    id: authUser.id,
                    email: authUser.email,
                    firstName: nil,
                    lastName: nil,
                    avatarUrl: nil
                )
                
                // Fetch user profile data
                await fetchUserProfile(userId: authUser.id)
                
                await MainActor.run {
                    self.currentUser = user
                    self.isAuthenticated = true
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = handleAuthError(error)
                    self.isLoading = false
                }
            }
        }
    }
    
    func signOut() {
        Task {
            await MainActor.run {
                self.isLoading = true
                self.errorMessage = nil
            }
            
            do {
                try await supabaseService.client.auth.signOut()
                await MainActor.run {
                    self.currentUser = nil
                    self.isAuthenticated = false
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = handleAuthError(error)
                    self.isLoading = false
                }
            }
        }
    }
    
    func resetPassword(email: String) {
        Task {
            await MainActor.run {
                self.isLoading = true
                self.errorMessage = nil
            }
            
            do {
                try await supabaseService.client.auth.resetPasswordForEmail(email)
                await MainActor.run {
                    self.passwordResetSent = true
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = handleAuthError(error)
                    self.isLoading = false
                }
            }
        }
    }
    
    private func handleAuthError(_ error: Error) -> String {
        // Customize error messages for better user experience
        if let authError = error as? AuthError {
            switch authError {
            case .signUpFailed:
                return "Failed to create account. Please try again."
            case .signInFailed:
                return "Invalid email or password. Please try again."
            case .sessionExpired:
                return "Your session has expired. Please sign in again."
            case .unauthorized:
                return "You are not authorized to perform this action."
            case .unknown(let message):
                return message
            }
        }
        
        return error.localizedDescription
    }
}
