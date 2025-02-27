//
//  Exercise.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// Exercise.swift
struct Exercise: Codable, Identifiable {
    let id: String
    let name: String
    let exerciseType: String
    let primaryMuscles: [String]
    let secondaryMuscles: [String]
    let instructions: [String]
    let experienceLevel: String
    let muscleGroup: String
    let description: String
    let benefits: [String]
    let equipment: [String]
    let gifUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case exerciseType = "exercise_type"
        case primaryMuscles = "primary_muscles"
        case secondaryMuscles = "secondary_muscles"
        case instructions
        case experienceLevel = "experience_level"
        case muscleGroup = "muscle_group"
        case description
        case benefits
        case equipment
        case gifUrl = "gif_url"
    }
}