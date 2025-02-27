// UserProfile.swift
import Foundation

struct UserProfile: Codable, Identifiable {
    let id: String
    var email: String
    var firstName: String?
    var lastName: String?
    var avatarUrl: String?
    var gender: String?
    var goal: String?
    var workoutDays: [Int]?
    var level: String?
    var weight: Int?
    var height: Int?
    var age: Int?
    var bodytype: String?
    var createdAt: Date
    var updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarUrl = "avatar_url"
        case gender
        case goal
        case workoutDays = "workout_days"
        case level
        case weight
        case height
        case age
        case bodytype
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        email = try container.decode(String.self, forKey: .email)
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        avatarUrl = try container.decodeIfPresent(String.self, forKey: .avatarUrl)
        gender = try container.decodeIfPresent(String.self, forKey: .gender)
        goal = try container.decodeIfPresent(String.self, forKey: .goal)
        workoutDays = try container.decodeIfPresent([Int].self, forKey: .workoutDays)
        level = try container.decodeIfPresent(String.self, forKey: .level)
        weight = try container.decodeIfPresent(Int.self, forKey: .weight)
        height = try container.decodeIfPresent(Int.self, forKey: .height)
        age = try container.decodeIfPresent(Int.self, forKey: .age)
        bodytype = try container.decodeIfPresent(String.self, forKey: .bodytype)
        
        // Handle date decoding with fallbacks
        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        if let date = ISO8601DateFormatter().date(from: createdAtString) {
            createdAt = date
        } else {
            createdAt = Date()
        }
        
        if let updatedAtString = try container.decodeIfPresent(String.self, forKey: .updatedAt),
           let date = ISO8601DateFormatter().date(from: updatedAtString) {
            updatedAt = date
        } else {
            updatedAt = nil
        }
    }
}