//
//  User.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// User.swift
struct User: Codable, Identifiable {
    let id: String
    let email: String?
    let firstName: String?
    let lastName: String?
    let avatarUrl: String?
    
    init(from authUser: AuthUser) {
        self.id = authUser.id
        self.email = authUser.email
        self.firstName = nil
        self.lastName = nil
        self.avatarUrl = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarUrl = "avatar_url"
    }
}
