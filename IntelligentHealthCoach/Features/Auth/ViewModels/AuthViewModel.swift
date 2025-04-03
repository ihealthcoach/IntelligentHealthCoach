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
import UIKit
import GoogleSignIn

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
    
    func checkUserExists(email: String) async -> Bool {
        do {
            // This uses the built-in "recover" method which checks if an email exists
            try await supabaseService.client.auth.resetPasswordForEmail(email)
            // If we get here, the email exists
            return true
        } catch {
            // Error means user doesn't exist
            return false
        }
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
                    firstName: nil,
                    lastName: nil,
                    avatarUrl: nil
                )
                
                // Set the initial user data
                await MainActor.run {
                    self.currentUser = appUser
                }
                
                // Fetch user profile - this will update firstName, lastName, etc.
                await fetchUserProfile(userId: user.id)
                
                await MainActor.run {
                    // Set authentication state but don't overwrite the user object again
                    self.isAuthenticated = true
                    self.isLoading = false
                }
            } catch {
                print("❌ Session check error: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.currentUser = nil
                    self.isAuthenticated = false
                    self.isLoading = false
                    self.errorMessage = nil
                }
            }
        }
    }
    
    
    private func fetchUserProfile(userId: UUID) async {
        do {
            print("🔍 Attempting to fetch profile for user ID: \(userId.uuidString)")
            
            let response = try await supabaseService.client
                .from("profiles")
                .select()
                .eq("user_id", value: userId.uuidString)
                .execute()
            
            // Log response data
            print("🔍 Response data: \(String(data: response.data, encoding: .utf8) ?? "No data")")
            
            // Check if we have data
            if response.data.isEmpty {
                print("⚠️ No profile data found for user - profile may not exist")
                return
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let profiles = try decoder.decode([UserProfile].self, from: response.data)
                
                if let profile = profiles.first {
                    await MainActor.run {
                        self.currentUser?.firstName = profile.firstName
                        self.currentUser?.lastName = profile.lastName
                        self.currentUser?.avatarUrl = profile.avatarUrl
                        print("✅ Profile updated successfully: firstName=\(profile.firstName ?? "nil"), lastName=\(profile.lastName ?? "nil")")
                    }
                } else {
                    print("⚠️ No profile found in response data")
                }
            } catch {
                print("❌ Failed to decode profile data: \(error)")
                print("Raw data: \(String(data: response.data, encoding: .utf8) ?? "No data")")
            }
        } catch {
            print("❌ Error fetching profile: \(error)")
        }
    }
    
    func refreshUserProfile() {
        Task {
            guard let userId = currentUser?.id else { return }
            
            do {
                // Fetch the profile from Supabase
                if let profile = try await supabaseService.fetchProfile(userId: userId.uuidString) {
                    await MainActor.run {
                        // Update the current user with profile data
                        self.currentUser?.firstName = profile.firstName
                        self.currentUser?.lastName = profile.lastName
                        self.currentUser?.avatarUrl = profile.avatarUrl
                        
                        // Debug output
                        print("✅ Profile refreshed - firstName: \(profile.firstName ?? "nil")")
                        print("✅ Profile refreshed - lastName: \(profile.lastName ?? "nil")")
                    }
                } else {
                    print("❌ No profile found for user ID: \(userId)")
                }
            } catch {
                print("❌ Error refreshing profile: \(error.localizedDescription)")
            }
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
    
    /* Google */
    func signInWithGoogle(from viewController: UIViewController) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let user = try await supabaseService.signInWithGoogle(presenter: viewController)
                
                // If user has a profile, fetch it
                if let uuid = UUID(uuidString: user.id.uuidString) {
                    await fetchUserProfile(userId: uuid)
                }
                
                await MainActor.run {
                    self.currentUser = user
                    self.isAuthenticated = true
                    self.isLoading = false
                }
            } catch {
                print("Google Sign-In Error: \(error.localizedDescription)")
                
                await MainActor.run {
                    // Provide user-friendly error messages
                    if let nsError = error as NSError? {
                        if nsError.domain == "GoogleSignIn" {
                            self.errorMessage = "Google Sign-In failed. Please try again."
                        } else if nsError.domain.contains("Supabase") {
                            self.errorMessage = "Could not authenticate with the server. Please try again."
                        } else {
                            self.errorMessage = handleAuthError(error)
                        }
                    } else {
                        self.errorMessage = handleAuthError(error)
                    }
                    self.isLoading = false
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
