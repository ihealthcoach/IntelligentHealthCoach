//
//  AuthUser.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 27/02/2025.
//

// AuthUser.swift - Update to ensure proper Codable conformance
import Foundation

struct AuthUser: Codable {
    let id: String
    let email: String?
    let aud: String
    let role: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case aud
        case role
    }
    
    // Add this initializer with Decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        aud = try container.decode(String.self, forKey: .aud)
        role = try container.decodeIfPresent(String.self, forKey: .role)
    }
    
    // Keep the existing initializer for mapping from dictionary
    init?(from supabaseUser: [String: Any]) {
        guard let id = supabaseUser["id"] as? String else { return nil }
        
        self.id = id
        self.email = supabaseUser["email"] as? String
        self.aud = supabaseUser["aud"] as? String ?? "authenticated"
        self.role = supabaseUser["role"] as? String
    }
}
