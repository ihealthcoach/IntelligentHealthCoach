//
//  WorkoutTemplate.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 28/02/2025.
//

// IntelligentHealthCoach/Features/Workouts/Models/WorkoutTemplate.swift
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        exerciseCount = try container.decode(Int.self, forKey: .exerciseCount)
        intensity = try container.decode(String.self, forKey: .intensity)
        userId = try container.decode(String.self, forKey: .userId)
        
        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        if let date = ISO8601DateFormatter().date(from: createdAtString) {
            createdAt = date
        } else {
            createdAt = Date()
        }
    }
}
