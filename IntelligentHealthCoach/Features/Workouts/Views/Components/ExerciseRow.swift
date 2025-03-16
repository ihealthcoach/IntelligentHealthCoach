//
//  ExerciseRow.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// ExerciseRow.swift
import SwiftUI
import Kingfisher

struct ExerciseRow: View {
    var exercise: Exercise
    var isSelected: Bool = false
    var onToggle: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            onToggle?()
        }) {
            HStack(spacing: 12) {
                // Exercise image/GIF
                KFImage(URL(string: exercise.gifUrl))
                    .placeholder {
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.2))
                            .frame(width: 60, height: 60)
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .cornerRadius(4)
                
                // Exercise details
                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.name ?? "Unnamed Exercise")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    // Muscle groups and equipment
                    HStack {
                        Text(exercise.primaryMuscles ?? "")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        
                        if let equipment = exercise.equipment, !equipment.isEmpty {
                            Text(equipment)
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Spacer()
                
                // Selection indicator (only visible if in selection mode)
                if isSelected {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 24, height: 24)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    // Added indicator
                    Text("Added")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                }
                
                // Default navigation arrow for non-selection mode
                if !isSelected && onToggle == nil {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ExerciseRow(exercise: Exercise(
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
    ))
}
