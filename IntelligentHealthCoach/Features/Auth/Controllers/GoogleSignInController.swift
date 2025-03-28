//
//  GoogleSignInController.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 27/03/2025.
//

import SwiftUI
import GoogleSignIn
import Supabase
import UIKit

class GoogleSignInController: UIViewController {
    var completion: ((Result<User, Error>) -> Void)? = nil
    private let supabaseService: SupabaseServiceProtocol
    
    init(supabaseService: SupabaseServiceProtocol = SupabaseService.shared) {
        self.supabaseService = supabaseService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func googleSignIn() async throws -> User {
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: self)
        
        guard let idToken = result.user.idToken?.tokenString else {
            print("No idToken found.")
            throw NSError(domain: "GoogleSignIn", code: 1, userInfo: [NSLocalizedDescriptionKey: "No ID token found"])
        }
        
        let accessToken = result.user.accessToken.tokenString
        
        // Sign in to Supabase with the Google credentials
        let response = try await supabaseService.client.auth.signInWithIdToken(
            credentials: OpenIDConnectCredentials(
                provider: .google,
                idToken: idToken,
                accessToken: accessToken
            )
        )
        
        // Create a User model from the auth response
        let authUser = response.user
        
        let user = User(
            id: authUser.id,
            email: authUser.email,
            firstName: nil, // Will be populated later
            lastName: nil,
            avatarUrl: nil
        )
        
        return user
    }
}
