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
        // Start OAuth flow with Supabase
        let oauthResponse = try await supabaseService.client.auth.signInWithOAuth(
            provider: .google,
            redirectTo: nil  // Use the default redirect URL configured in your Supabase project
        )
        
        // Configure GIDSignIn with clientID
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        
        // Create a nonce for the OpenID Connect request
        let nonce = UUID().uuidString
        
        // Present the sign-in UI with the nonce
        let result = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: self,
            hint: nil,
            additionalScopes: ["email", "profile"]
        )
        
        guard let authURL = oauthResponse.url else {
            throw NSError(domain: "GoogleSignIn", code: 1, userInfo: [NSLocalizedDescriptionKey: "No auth URL returned from Supabase"])
        }
        
        let accessToken = result.user.accessToken.tokenString
        
        print("✅ Successfully got Google ID token: \(idToken.prefix(10))...")
        print("✅ Successfully got Google access token: \(accessToken.prefix(10))...")
        
        // Sign in to Supabase with the Google credentials
        // Note: When using signInWithIdToken, Supabase doesn't need a nonce
        let response = try await supabaseService.client.auth.signInWithOAuth(
            provider: .google,
            redirectTo: nil
        )
        
        // Create a User model from the auth response
        let authUser = response.user
        
        // Map Google profile information if available
        var firstName: String? = nil
        var lastName: String? = nil
        
        if let givenName = result.user.profile?.givenName {
            firstName = givenName
        }
        
        if let familyName = result.user.profile?.familyName {
            lastName = familyName
        }
        
        let session = try await supabaseService.client.auth.session
        let supabaseUser = session.user  // Changed from authUser to supabaseUser
        
        let user = User(
            id: supabaseUser.id,
            email: supabaseUser.email,
            firstName: nil,  // You would need to fetch profile data separately
            lastName: nil,
            avatarUrl: nil
        )
        
        return user
    }
}
