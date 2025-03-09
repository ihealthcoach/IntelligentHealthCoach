//
//  JSONDecoder+Extensions.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 28/02/2025.
//

// IntelligentHealthCoach/Core/Utilities/JSONDecoders.swift
import Foundation

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
}
