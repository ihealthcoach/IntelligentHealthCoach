//
//  Questionnaire.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// Questionnaire.swift
struct Questionnaire: Codable {
    var gender: String?
    var goal: String?
    var workoutDays: [Int]
    var level: String?
    var weight: Int?
    var height: Int?
    var age: Int?
    var bodytype: String?
    
    init() {
        self.workoutDays = []
    }
    
    enum CodingKeys: String, CodingKey {
        case gender
        case goal
        case workoutDays = "workout_days"
        case level
        case weight
        case height
        case age
        case bodytype
    }
}
