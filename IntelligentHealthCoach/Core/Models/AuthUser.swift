//
//  AuthUser.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 27/02/2025.
//

import Foundation

struct AuthUser {
    let id: String
    let email: String?
    let aud: String
    let role: String?
    
    // Add more fields as needed based on Supabase auth response
}

// Extension to map from Supabase auth response
extension AuthUser {
    init?(from supabaseUser: [String: Any]) {
        guard let id = supabaseUser["id"] as? String else { return nil }
        
        self.id = id
        self.email = supabaseUser["email"] as? String
        self.aud = supabaseUser["aud"] as? String ?? "authenticated"
        self.role = supabaseUser["role"] as? String
    }
}
