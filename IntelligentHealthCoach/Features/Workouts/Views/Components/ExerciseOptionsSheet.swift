//
//  ExerciseOptionsSheet.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 17/03/2025.
//

import SwiftUI

struct ExerciseOptionsSheet: View {
    var exercise: Exercise
    var onOptionSelected: (ExerciseOption) -> Void
    
    var body: some View {
        FlexibleSheet(title: "Exercise options") {
            VStack(spacing: 0) {
                ForEach(ExerciseOption.allCases) { option in
                    optionButton(option)
                }
                Spacer()
            }
            .padding(.top, 8)
        }
    }
    
    private func optionButton(_ option: ExerciseOption) -> some View {
        Button(action: {
            onOptionSelected(option)
        }) {
            HStack {
                Image(systemName: option.iconName)
                    .frame(width: 24, height: 24)
                    .foregroundColor(option == .remove ? .red : .offwhite)
                    .background(
                        Circle()
                            .fill(option == .remove ? Color.red.opacity(0.2) : Color.gray.opacity(0.7))
                            .frame(width: 36, height: 36)
                    )
                
                Text(option.title)
                    .foregroundColor(option == .remove ? .red : .primary)
                
                Spacer()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
        }
    }
}

// Exercise option enum
enum ExerciseOption: String, CaseIterable, Identifiable {
    case replace, buildSuperset, previousStats, exerciseGuide, reorder, remove
    
    var id: String { self.rawValue }
    
    var title: String {
        switch self {
        case .replace: return "Replace"
        case .buildSuperset: return "Build superset"
        case .previousStats: return "Previous stats"
        case .exerciseGuide: return "Exercise guide"
        case .reorder: return "Reorder exercises"
        case .remove: return "Remove"
        }
    }
    
    var iconName: String {
        switch self {
        case .replace: return "arrow.triangle.2.circlepath"
        case .buildSuperset: return "plus"
        case .previousStats: return "chart.bar"
        case .exerciseGuide: return "info.circle"
        case .reorder: return "list.bullet"
        case .remove: return "trash"
        }
    }
}

#Preview {
    ExerciseOptionsSheet(
        exercise: Exercise(
            id: "1",
            name: "Bench Press",
            exerciseType: "Strength",
            primaryMuscles: "Chest,Triceps",
            secondaryMuscles: "Shoulders",
            instructions: "Lie on a flat bench...",
            experienceLevel: "Intermediate",
            muscleGroup: "Chest",
            description: "The bench press is a compound exercise...",
            benefits: "Builds chest strength,Improves upper body power",
            equipment: "Barbell,Bench",
            forceType: "Push",
            mechanics: "Compound",
            bodyPart: "Chest",
            target: "Pecs",
            experience: "Intermediate"
        ),
        onOptionSelected: { _ in }
    )
}
