//
//  WorkoutTemplate.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 28/02/2025.
//

import Foundation

struct WorkoutTemplate: Codable, Identifiable {
    let id: String
    let name: String
    let exerciseCount: Int
    let intensity: String
    let userId: String
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case exerciseCount = "exercise_count"
        case intensity
        case userId = "user_id"
        case createdAt = "created_at"
    }
    
    // Add Decoder similar to other models
}
