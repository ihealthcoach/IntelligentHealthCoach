//
//  AuthViewModel.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//

import Foundation
import SwiftUI
import Combine
import Supabase


class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let supabaseService: SupabaseServiceProtocol
    
    init(supabaseService: SupabaseServiceProtocol = SupabaseService.shared) {
        self.supabaseService = supabaseService
        checkSession()
    }
    
    func checkSession() {
        Task {
            if let session = supabaseService.client.auth.session {
                // First, convert UUID to String if needed
                let userId = session.user.id is UUID ? (session.user.id as! UUID).uuidString : String(describing: session.user.id)
                
                // Create User with the string ID
                let appUser = User(
                    id: userId,  // Use the string version
                    email: session.user.email,
                    firstName: nil,
                    lastName: nil,
                    avatarUrl: nil
                )
                
                await MainActor.run {
                    self.currentUser = appUser
                    self.isAuthenticated = true
                }
            }
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
                let user = try await supabaseService.signUp(email: email, password: password)
                
                // If signup is successful, create a profile with the first and last name
                if !firstName.isEmpty || !lastName.isEmpty {
                    try await createUserProfile(userId: user.id, firstName: firstName, lastName: lastName)
                }
                
                await MainActor.run {
                    self.currentUser = user
                    self.isAuthenticated = true
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

    private func createUserProfile(userId: String, firstName: String, lastName: String) async throws {
        // Use a struct that conforms to Encodable
        let profileData = ProfileData(
            user_id: userId,
            first_name: firstName,
            last_name: lastName
        )
        
        // Capture the result with underscore to show it's intentionally unused
        let _ = try await supabaseService.client
            .from("profiles")
            .insert(profileData)
            .execute()
    }
    
    func signIn(email: String, password: String) {
        Task {
            await MainActor.run {
                self.isLoading = true
                self.errorMessage = nil
            }
            
            do {
                let user = try await supabaseService.signIn(email: email, password: password)
                await MainActor.run {
                    self.currentUser = user
                    self.isAuthenticated = true
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
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
                try await supabaseService.signOut()
                await MainActor.run {
                    self.currentUser = nil
                    self.isAuthenticated = false
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    func resetPassword(email: String) {
        // Placeholder for password reset functionality
        // Implement when adding this feature
    }
