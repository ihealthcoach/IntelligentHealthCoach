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
    let title: String?
    let exercises: [Exercise]?
    let createdAt: Date
    let updatedAt: Date
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case title
        case exercises
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case status
    }
    
    // Add initializer to support creating workout with exercises
    init(id: String, userId: String, title: String? = nil, exercises: [Exercise]? = nil, createdAt: Date, updatedAt: Date, status: String) {
        self.id = id
        self.userId = userId
        self.title = title
        self.exercises = exercises
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.status = status
    }
}
