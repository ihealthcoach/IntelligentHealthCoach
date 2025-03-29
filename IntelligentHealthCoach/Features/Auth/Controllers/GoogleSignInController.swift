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
        // Get clientID from Info.plist
        guard let clientID = Bundle.main.infoDictionary?["CLIENT_ID"] as? String,
              !clientID.isEmpty else {
            throw NSError(domain: "GoogleSignIn", code: 1, userInfo: [NSLocalizedDescriptionKey: "No Google client ID found in Info.plist"])
        }
        
        // Configure GIDSignIn with clientID
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        
        // Present the sign-in UI
        let result = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: self,
            hint: nil,
            additionalScopes: ["email", "profile"]
        )
        
        guard let idToken = result.user.idToken?.tokenString else {
            print("❌ No idToken found in Google Sign-In result")
            throw NSError(domain: "GoogleSignIn", code: 1, userInfo: [NSLocalizedDescriptionKey: "No ID token found"])
        }
        
        let accessToken = result.user.accessToken.tokenString
        
        print("✅ Successfully got Google ID token: \(idToken.prefix(10))...")
        
        // Try a different approach: use SignInWithOAuth instead of ID token
        let session = try await supabaseService.client.auth.session
        let authUser = session.user
        
        // Map Google profile information
        var firstName: String? = nil
        var lastName: String? = nil
        var avatarUrl: String? = nil
        
        if let givenName = result.user.profile?.givenName {
            firstName = givenName
        }
        
        if let familyName = result.user.profile?.familyName {
            lastName = familyName
        }
        
        if let imageURL = result.user.profile?.imageURL(withDimension: 200) {
            avatarUrl = imageURL.absoluteString
        }
        
        let user = User(
            id: authUser.id,
            email: authUser.email,
            firstName: firstName,
            lastName: lastName,
            avatarUrl: avatarUrl
        )
        
        return user
    }
}
