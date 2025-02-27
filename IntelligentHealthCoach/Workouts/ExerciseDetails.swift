//
//  ExerciseDetails.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


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
}