//
//  WorkoutSet.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//

import Foundation

struct WorkoutSet: Codable, Identifiable {
    let id: String
    let workoutExerciseDetailsId: String
    let weight: Double
    let type: String
    let reps: Int
    let completed: Bool
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case workoutExerciseDetailsId = "workout_exercise_details_id"
        case weight
        case type
        case reps
        case completed
        case createdAt = "created_at" // This is correct based on the database schema
        case updatedAt = "updated_at" // This is correct based on the database schema
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        workoutExerciseDetailsId = try container.decode(String.self, forKey: .workoutExerciseDetailsId)
        weight = try container.decode(Double.self, forKey: .weight)
        type = try container.decode(String.self, forKey: .type)
        reps = try container.decode(Int.self, forKey: .reps)
        completed = try container.decode(Bool.self, forKey: .completed)
        
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
    
    // Add this initializer to WorkoutSet struct
    init(id: String, workoutExerciseDetailsId: String, weight: Double, type: String, reps: Int, completed: Bool, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.workoutExerciseDetailsId = workoutExerciseDetailsId
        self.weight = weight
        self.type = type
        self.reps = reps
        self.completed = completed
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
