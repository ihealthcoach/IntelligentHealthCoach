//
//  Exercise.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// Exercise.swift
struct Exercise: Codable, Identifiable {
    let id: String
    let name: String?
    let exerciseType: String?
    let primaryMuscles: String?
    let secondaryMuscles: String?
    let instructions: String?
    let experienceLevel: String?
    let muscleGroup: String?
    let description: String?
    let benefits: String?
    let equipment: String?
    let forceType: String?
    let mechanics: String?
    let bodyPart: String?
    let target: String?
    let experience: String?
    
    // Using this for compatibility with any code that might expect these as arrays
    var primaryMusclesArray: [String] {
        return primaryMuscles?.components(separatedBy: ",") ?? []
    }
    
    var secondaryMusclesArray: [String] {
        return secondaryMuscles?.components(separatedBy: ",") ?? []
    }
    
    var instructionsArray: [String] {
        return instructions?.components(separatedBy: "\n") ?? []
    }
    
    var benefitsArray: [String] {
        return benefits?.components(separatedBy: ",") ?? []
    }
    
    var equipmentArray: [String] {
        return equipment?.components(separatedBy: ",") ?? []
    }
    
    // Define the mapping between model properties and database columns
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
        case forceType = "force_type"
        case mechanics
        case bodyPart = "body_part"
        case target
        case experience
    }
    
    // Add a computed property for gifUrl since it doesn't exist in your schema
    var gifUrl: String {
        return "https://example.com/exercises/\(id).gif" // Provide a default or placeholder
    }
    
    // Add hash and equality implementations for Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.id == rhs.id
    }
}
