//
//  ExerciseRow.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 26/02/2025.
//

import SwiftUI
import Kingfisher

struct ExerciseRow: View {
    var exercise: Exercise
    @ObservedObject var workoutBuilder: WorkoutBuilderViewModel
    var onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
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
                
                // Selection indicator (only visible if selected)
                if workoutBuilder.containsExercise(id: exercise.id) {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 24, height: 24)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.offwhite)
                    }
                    
                    Text("Added")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ExerciseRow_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock workout builder
        let workoutBuilder = WorkoutBuilderViewModel()
        
        // Create an exercise
        let exercise = Exercise(
            id: "1",
            name: "Bench Press",
            exerciseType: "Strength",
            primaryMuscles: "Chest, Triceps",
            secondaryMuscles: "Shoulders",
            instructions: "Lie on a flat bench...",
            experienceLevel: "Intermediate",
            muscleGroup: "Chest",
            description: "The bench press is a compound exercise...",
            benefits: "Builds chest strength,Improves upper body power",
            equipment: "Barbell, Bench",
            forceType: "Push",
            mechanics: "Compound",
            bodyPart: "Chest",
            target: "Pecs",
            experience: "Intermediate"
        )
        
        Group {
            // Preview for unselected state
            ExerciseRow(
                exercise: exercise,
                workoutBuilder: workoutBuilder,
                onToggle: {}
            )
            .previewDisplayName("Not Selected")
            
            // Preview for selected state
            ExerciseRow(
                exercise: exercise,
                workoutBuilder: {
                    let vm = WorkoutBuilderViewModel()
                    vm.addExercise(exercise)
                    return vm
                }(),
                onToggle: {}
            )
            .previewDisplayName("Selected")
        }
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color("gray100"))
    }
}
