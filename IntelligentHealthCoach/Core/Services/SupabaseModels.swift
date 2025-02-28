//
//  SupabaseModels.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 28/02/2025.
//

import Foundation

// Auth response models that conform to Codable
struct SupabaseSession: Codable {
    let accessToken: String
    let refreshToken: String
    let user: AuthUser?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case user
    }
}

struct SupabaseAuthResponse: Codable {
    let user: AuthUser?
    let session: SupabaseSession?
}

// Response from API queries
struct SupabaseResponse {
    let data: Data
    
    func decoded<T: Decodable>(to type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(type, from: data)
    }
}
