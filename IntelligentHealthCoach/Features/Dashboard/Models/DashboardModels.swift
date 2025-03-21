//
//  DashboardModels.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 27/02/2025.
//

import SwiftUI

struct TodayGoal: Identifiable {
    let id = UUID()
    let title: String
    let currentValue: String
    let targetValue: String
    let unit: String
    let icon: AnyView
    let color: Color
    
    var progress: Double {
        // Parse the values and calculate progress
        guard let current = Double(currentValue.replacingOccurrences(of: ",", with: "")),
              let target = Double(targetValue.replacingOccurrences(of: ",", with: "")) else {
            return 0.0
        }
        return min(current / target, 1.0)
    }
}

struct Activity: Identifiable {
    let id = UUID()
    let type: String
    let stats: [(String, AnyView)]  // Now uses AnyView instead of String for icons
    let timestamp: Date
    
    var formattedTime: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}
