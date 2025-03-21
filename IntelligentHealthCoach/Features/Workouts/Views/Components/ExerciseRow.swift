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
                ExerciseGIF(
                    gifUrl: exercise.gifUrl,
                    size: CGSize(width: 68, height: 68)
                )
                
                // Exercise details
                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.name ?? "Unnamed Exercise")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    // Muscle groups and equipment
                    HStack {
                        Text(exercise.muscleGroup ?? "")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        
                        if let equipment = exercise.equipment, !equipment.isEmpty {
                            Text("• \(equipment)")
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
                            .fill(Color.indigo600)
                            .frame(width: 24, height: 24)
                        
                        Image("check-mini")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12, height: 12)
                            .foregroundColor(Color("offwhite"))
                    }
                    
                    Text("Added")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.indigo600)
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
            experience: "Intermediate",
            gifUrl: "https://fleiivpyjkvahakriuta.supabase.co/storage/v1/object/public/exercises/gifs/3_4_sit_up.gif"
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
            
            // Preview with no GIF
            ExerciseRow(
                exercise: Exercise(
                    id: "2",
                    name: "Squat",
                    exerciseType: "Strength",
                    primaryMuscles: "Quadriceps, Glutes",
                    secondaryMuscles: "Hamstrings",
                    instructions: "Stand with feet...",
                    experienceLevel: "Intermediate",
                    muscleGroup: "Legs",
                    description: "The squat is a compound exercise...",
                    benefits: "Builds leg strength",
                    equipment: "Barbell",
                    forceType: "Push",
                    mechanics: "Compound",
                    bodyPart: "Legs",
                    target: "Quads",
                    experience: "Intermediate",
                    gifUrl: nil
                ),
                workoutBuilder: workoutBuilder,
                onToggle: {}
            )
            .previewDisplayName("No GIF")
        }
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color("gray50"))
    }
}
