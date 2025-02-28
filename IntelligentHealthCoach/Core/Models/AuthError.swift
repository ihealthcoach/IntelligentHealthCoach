//
//  AuthError.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 28/02/2025.
//


// AuthError.swift
import Foundation

enum AuthError: Error {
    case signUpFailed
    case signInFailed
    case sessionExpired
    case unauthorized
    case unknown(String)
}
