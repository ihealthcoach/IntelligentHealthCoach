//
//  Set.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// Set.swift
struct Set: Codable, Identifiable {
    let id: String
    let exerciseDetailsId: String
    let weight: Double
    let type: String
    let reps: Int
    let completed: Bool
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case exerciseDetailsId = "exercise_details_id"
        case weight
        case type
        case reps
        case completed
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}