//
//  AuthViewModel.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// AuthViewModel.swift
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
            do {
                if let session = try await supabaseService.client.auth.session {
                    if let user = session.user {
                        let appUser = User(from: user)
                        await MainActor.run {
                            self.currentUser = appUser
                            self.isAuthenticated = true
                        }
                    }
                }
            } catch {
                print("Session error: \(error)")
            }
        }
    }
    
    func signUp(email: String, password: String) {
        Task {
            await MainActor.run { 
                self.isLoading = true
                self.errorMessage = nil
            }
            
            do {
                let user = try await supabaseService.signUp(email: email, password: password)
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
}