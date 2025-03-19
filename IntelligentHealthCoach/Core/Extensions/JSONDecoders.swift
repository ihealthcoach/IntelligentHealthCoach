//
//  JSONDecoder+Extensions.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 28/02/2025.
//

// IntelligentHealthCoach/Core/Extensions/JSONDecoders.swift
import Foundation
import SwiftUI
import Supabase

extension JSONDecoder {
    /// Standard decoder for app models
    static func appDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // Handle all date formats consistently
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            // Define all the date formats we want to support
            let dateFormats = [
                "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
                "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
                "yyyy-MM-dd HH:mm:ss"
            ]
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            // Try each format
            for format in dateFormats {
                dateFormatter.dateFormat = format
                if let date = dateFormatter.date(from: dateString) {
                    return date
                }
            }
            
            // Also try ISO8601 format which is common
            if let date = ISO8601DateFormatter().date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date: \(dateString)"
            )
        }
        
        return decoder
    }
    
    /// Decoder specifically for Supabase responses
    static func supabaseDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // Custom date decoding for Supabase timestamp format
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            // Try ISO8601 first
            if let date = ISO8601DateFormatter().date(from: dateString) {
                return date
            }
            
            // Try PostgreSQL timestamp format
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
            
            // Fallback to simpler formats
            let fallbackFormats = [
                "yyyy-MM-dd'T'HH:mm:ssZ",
                "yyyy-MM-dd HH:mm:ss"
            ]
            
            for format in fallbackFormats {
                dateFormatter.dateFormat = format
                if let date = dateFormatter.date(from: dateString) {
                    return date
                }
            }
            
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date: \(dateString)"
            )
        }
        
        return decoder
    }
    
    /// Specific decoder for Workout models due to field mapping differences
    static func workoutsDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        
        // Create a custom key mapping for workouts
        let customKeyMapping: [String: String] = [
            "created": "createdAt",
            "modified": "updatedAt"
        ]
        
        // Custom key decoding strategy to handle the specific field mappings for Workouts
        decoder.keyDecodingStrategy = .custom { keys in
            let lastKey = keys.last!
            
            // Convert to snake_case first
            let snakeCaseKey = lastKey.stringValue
            
            // Check if we have a custom mapping for this key
            if let customKey = customKeyMapping[snakeCaseKey] {
                return AnyCodingKey(stringValue: customKey)!
            }
            
            // Default to converting snake_case to camelCase
            let words = snakeCaseKey.split(separator: "_")
            var camelCase = String(words.first!.lowercased())
            
            for word in words.dropFirst() {
                camelCase += word.prefix(1).uppercased() + word.dropFirst().lowercased()
            }
            
            return AnyCodingKey(stringValue: camelCase)!
        }
        
        // Use the same date decoding strategy as the supabase decoder
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            // Try ISO8601 first
            if let date = ISO8601DateFormatter().date(from: dateString) {
                return date
            }
            
            // Try PostgreSQL timestamp format
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
            
            // Fallback to simpler formats
            let fallbackFormats = [
                "yyyy-MM-dd'T'HH:mm:ssZ",
                "yyyy-MM-dd HH:mm:ss"
            ]
            
            for format in fallbackFormats {
                dateFormatter.dateFormat = format
                if let date = dateFormatter.date(from: dateString) {
                    return date
                }
            }
            
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date: \(dateString)"
            )
        }
        
        return decoder
    }
}

// Helper for custom key decoding
struct AnyCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}
