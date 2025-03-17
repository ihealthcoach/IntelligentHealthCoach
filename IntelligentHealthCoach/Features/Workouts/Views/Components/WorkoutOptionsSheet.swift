//
//  WorkoutOptionsSheet.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 17/03/2025.
//

import SwiftUI

struct WorkoutOptionsSheet: View {
    var onOptionSelected: (WorkoutOption) -> Void
    
    var body: some View {
        FlexibleSheet(title: "Workout options") {
            VStack(spacing: 0) {
                ForEach(WorkoutOption.allCases) { option in
                    optionButton(option)
                }
                Spacer()
            }
            .padding(.top, 8)
        }
    }
    
    private func optionButton(_ option: WorkoutOption) -> some View {
        Button(action: {
            onOptionSelected(option)
        }) {
            HStack {
                Image(systemName: option.iconName)
                    .frame(width: 24, height: 24)
                    .foregroundColor(option == .clearAll ? .red : .white)
                    .background(
                        Circle()
                            .fill(option == .clearAll ? Color.red.opacity(0.2) : Color.gray.opacity(0.7))
                            .frame(width: 36, height: 36)
                    )
                
                Text(option.title)
                    .foregroundColor(option == .clearAll ? .red : .primary)
                
                Spacer()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
        }
    }
}

// Workout option enum
enum WorkoutOption: String, CaseIterable, Identifiable {
    case clearAll, saveAsRoutine, shareWorkout
    
    var id: String { self.rawValue }
    
    var title: String {
        switch self {
        case .clearAll: return "Clear all exercises"
        case .saveAsRoutine: return "Save as routine"
        case .shareWorkout: return "Share workout"
        }
    }
    
    var iconName: String {
        switch self {
        case .clearAll: return "trash"
        case .saveAsRoutine: return "bookmark"
        case .shareWorkout: return "square.and.arrow.up"
        }
    }
}

#Preview {
    WorkoutOptionsSheet(onOptionSelected: { _ in })
}
