//
//  User.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// IntelligentHealthCoach/Core/Models/User.swift
import Foundation

struct User: Codable, Identifiable {
    let id: UUID
    let email: String?
    var firstName: String?
    var lastName: String?
    var avatarUrl: String?
    
    // First initializer from AuthUser
    init(from authUser: AuthUser) {
        if let uuid = UUID(uuidString: authUser.id) {
            self.id = uuid
        } else {
            self.id = UUID()
        }
        self.email = authUser.email
        self.firstName = nil
        self.lastName = nil
        self.avatarUrl = nil
    }
    
    // Second initializer with all properties
    init(id: UUID, email: String?, firstName: String?, lastName: String?, avatarUrl: String?) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.avatarUrl = avatarUrl
    }
    
    // String ID initializer for convenience
    init(id: String, email: String?, firstName: String?, lastName: String?, avatarUrl: String?) {
        if let uuid = UUID(uuidString: id) {
            self.id = uuid
        } else {
            self.id = UUID()
        }
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
