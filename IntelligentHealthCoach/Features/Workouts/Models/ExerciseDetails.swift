//
//  ExerciseDetails.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//

import Foundation

// ExerciseDetails.swift
struct ExerciseDetails: Codable, Identifiable {
    let id: String
    let workoutId: String
    let exerciseId: String
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case workoutId = "workout_id"
        case exerciseId = "exercise_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        workoutId = try container.decode(String.self, forKey: .workoutId)
        exerciseId = try container.decode(String.self, forKey: .exerciseId)
        
        // Date decoding
        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        if let date = ISO8601DateFormatter().date(from: createdAtString) {
            createdAt = date
        } else {
            createdAt = Date()
        }
        
        let updatedAtString = try container.decode(String.self, forKey: .updatedAt)
        if let date = ISO8601DateFormatter().date(from: updatedAtString) {
            updatedAt = date
        } else {
            updatedAt = Date()
        }
    }
}
