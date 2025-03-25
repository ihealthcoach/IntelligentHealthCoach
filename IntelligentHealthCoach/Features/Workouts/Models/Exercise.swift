//
//  Exercise.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//

import Foundation
import Supabase
import Storage

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
    let gifUrl: String?
    
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
    
    // Add a computed property for the full GIF URL
    var fullGifUrl: String? {
        guard let gifUrl = gifUrl, !gifUrl.isEmpty else {
            return nil
        }
        
        // If it already starts with http/https, assume it's a complete URL
        if gifUrl.hasPrefix("http") {
            return gifUrl
        }
        
        // Otherwise, it's probably just a filename, so construct the full URL
        return "https://fleiivpyjkvahakriuta.supabase.co/storage/v1/object/public/exercises/gifs/\(gifUrl)"
    }

    // Memberwise initializer for creating instances directly
    init(id: String,
         name: String?,
         exerciseType: String?,
         primaryMuscles: String?,
         secondaryMuscles: String?,
         instructions: String?,
         experienceLevel: String?,
         muscleGroup: String?,
         description: String?,
         benefits: String?,
         equipment: String?,
         forceType: String?,
         mechanics: String?,
         bodyPart: String?,
         target: String?,
         experience: String?,
         gifUrl: String?) {
        
        self.id = id
        self.name = name
        self.exerciseType = exerciseType
        self.primaryMuscles = primaryMuscles
        self.secondaryMuscles = secondaryMuscles
        self.instructions = instructions
        self.experienceLevel = experienceLevel
        self.muscleGroup = muscleGroup
        self.description = description
        self.benefits = benefits
        self.equipment = equipment
        self.forceType = forceType
        self.mechanics = mechanics
        self.bodyPart = bodyPart
        self.target = target
        self.experience = experience
        self.gifUrl = gifUrl
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
        case gifUrl = "gif_url"
    }
    
    // Add custom decoder init to handle potential issues
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        exerciseType = try container.decodeIfPresent(String.self, forKey: .exerciseType)
        primaryMuscles = try container.decodeIfPresent(String.self, forKey: .primaryMuscles)
        secondaryMuscles = try container.decodeIfPresent(String.self, forKey: .secondaryMuscles)
        instructions = try container.decodeIfPresent(String.self, forKey: .instructions)
        experienceLevel = try container.decodeIfPresent(String.self, forKey: .experienceLevel)
        muscleGroup = try container.decodeIfPresent(String.self, forKey: .muscleGroup)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        benefits = try container.decodeIfPresent(String.self, forKey: .benefits)
        equipment = try container.decodeIfPresent(String.self, forKey: .equipment)
        forceType = try container.decodeIfPresent(String.self, forKey: .forceType)
        mechanics = try container.decodeIfPresent(String.self, forKey: .mechanics)
        bodyPart = try container.decodeIfPresent(String.self, forKey: .bodyPart)
        target = try container.decodeIfPresent(String.self, forKey: .target)
        experience = try container.decodeIfPresent(String.self, forKey: .experience)
        
        // Use a special case for gifUrl to handle potential issues
        do {
            gifUrl = try container.decodeIfPresent(String.self, forKey: .gifUrl)
        } catch {
            print("⚠️ Error decoding gif_url: \(error)")
            gifUrl = nil
        }
    }
    
    // Add hash and equality implementations for Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.id == rhs.id
    }
}
