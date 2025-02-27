//
//  Workout.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// Workout.swift
struct Workout: Codable, Identifiable {
    let id: String
    let userId: String
    let createdAt: Date
    let updatedAt: Date
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case status
    }
}
