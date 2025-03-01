//
//  Workout.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//

import Foundation

// Workout.swift
/// Represents a user workout in the system
/// Note on database field mapping:
/// - "created" in the database maps to "createdAt" in this model
/// - "modified" in the database maps to "updatedAt" in this model
/// - Other fields use standard snake_case to camelCase conversion
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
            case createdAt = "created" // Changed from created_at to match database schema
            case updatedAt = "modified" // Changed from updated_at to match database schema
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        userId = try container.decode(String.self, forKey: .userId)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        exercises = try container.decodeIfPresent([Exercise].self, forKey: .exercises)
        status = try container.decode(String.self, forKey: .status)
        
        // Date decoding
        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        if let date = ISO8601DateFormatter().date(from: createdAtString) {
            createdAt = date
        } else {
            // Try a standard date formatter for TIMESTAMP format
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = formatter.date(from: createdAtString) {
                createdAt = date
            } else {
                createdAt = Date()
            }
        }

        let updatedAtString = try container.decode(String.self, forKey: .updatedAt)
        if let date = ISO8601DateFormatter().date(from: updatedAtString) {
            updatedAt = date
        } else {
            // Try a standard date formatter for TIMESTAMP format
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = formatter.date(from: updatedAtString) {
                updatedAt = date
            } else {
                updatedAt = Date()
            }
        }
}
