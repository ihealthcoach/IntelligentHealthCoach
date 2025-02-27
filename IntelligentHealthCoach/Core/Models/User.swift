//
//  User.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// IntelligentHealthCoach/Core/Models/User.swift
struct User: Codable, Identifiable {
    let id: String
    let email: String?
    let firstName: String?
    let lastName: String?
    let avatarUrl: String?
    
    // First initializer from AuthUser
    init(from authUser: AuthUser) {
        self.id = authUser.id
        self.email = authUser.email
        self.firstName = nil
        self.lastName = nil
        self.avatarUrl = nil
    }
    
    // Second initializer with all properties
    init(id: String, email: String?, firstName: String?, lastName: String?, avatarUrl: String?) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.avatarUrl = avatarUrl
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarUrl = "avatar_url"
    }
    
    // Add a computed property for full name
    var fullName: String {
        if let first = firstName, let last = lastName {
            return "\(first) \(last)"
        } else if let first = firstName {
            return first
        } else if let last = lastName {
            return last
        } else {
            return "User"
        }
    }
}
