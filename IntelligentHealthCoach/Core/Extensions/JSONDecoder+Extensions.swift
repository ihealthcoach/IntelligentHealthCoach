//
//  JSONDecoder+Extensions.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 28/02/2025.
//

// IntelligentHealthCoach/Core/Extensions/JSONDecoder+Extensions.swift
import Foundation

extension JSONDecoder {
    static func supabaseDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
            
            // Try without fractional seconds
            dateFormatter.formatOptions = [.withInternetDateTime]
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
            
            // Try standard timestamp format
            let standardFormatter = DateFormatter()
            standardFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = standardFormatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date string \(dateString)"
            )
        }
        
        return decoder
    }
    
    // Special decoder for workouts table which has different field naming
    static func workoutsDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        
        // Handle field naming differences between database and model
        decoder.keyDecodingStrategy = .custom { keys in
            let lastKey = keys.last!
            
            // Handle specific field name mappings
            switch lastKey.stringValue {
            case "created":
                return AnyCodingKey(stringValue: "createdAt")!
            case "modified":
                return AnyCodingKey(stringValue: "updatedAt")!
            default:
                // For other keys, use standard snake_case to camelCase conversion
                if lastKey.intValue != nil {
                    return lastKey
                }
                
                let snakeCase = lastKey.stringValue
                let camelCase = snakeCase.split(separator: "_")
                    .enumerated()
                    .map { index, part in
                        if index == 0 {
                            return part.lowercased()
                        } else {
                            return part.prefix(1).uppercased() + part.dropFirst().lowercased()
                        }
                    }
                    .joined()
                
                return AnyCodingKey(stringValue: camelCase)!
            }
        }
        
        // Handle date decoding
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let postgresTimestampFormatter = DateFormatter()
        postgresTimestampFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            // Try ISO8601 first
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
            
            // Try standard timestamp format
            if let date = postgresTimestampFormatter.date(from: dateString) {
                return date
            }
            
            // Simplify format and try again
            postgresTimestampFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = postgresTimestampFormatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date string \(dateString)"
            )
        }
        
        return decoder
    }
}

// Helper for custom key decoding
struct AnyCodingKey: CodingKey {
    let stringValue: String
    let intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}
