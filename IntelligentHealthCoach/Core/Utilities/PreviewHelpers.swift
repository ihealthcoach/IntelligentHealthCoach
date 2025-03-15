//
//  PreviewHelpers.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 27/02/2025.
//

import Foundation

// Provides mock objects for SwiftUI previews
extension AuthViewModel {
    static var preview: AuthViewModel {
        let viewModel = AuthViewModel()
        viewModel.isAuthenticated = true
        viewModel.currentUser = User(preview: true)
        return viewModel
    }
    
    static var unauthenticated: AuthViewModel {
        let viewModel = AuthViewModel()
        viewModel.isAuthenticated = false
        return viewModel
    }
}

extension User {
    // Constructor for preview data
    init(preview: Bool) {
        self.id = UUID() // Use an actual UUID instead of a string
        self.email = "preview@example.com"
        self.firstName = "Preview"
        self.lastName = "User"
        self.avatarUrl = nil
    }
}
