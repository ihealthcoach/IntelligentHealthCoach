//
//  WorkoutExerciseRow.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 17/03/2025.
//

import SwiftUI
import Kingfisher

struct WorkoutExerciseRow: View {
    var exercise: Exercise
    var isCompleted: Bool
    var setsCompleted: Int
    var totalSets: Int
    var onMoreTapped: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Exercise GIF
            /*KFImage(URL(string: exercise.gifUrl ?? ""))
                .placeholder {
                    /*Rectangle()
                        .foregroundColor(.gray.opacity(0.2))*/
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 68, height: 68)
                .blendMode(.multiply)
                .background(Color("gray50"))
                .clipShape(RoundedRectangle(cornerRadius: 0))*/
            
            ExerciseGIF(
                gifUrl: exercise.gifUrl,
                size: CGSize(width: 68, height: 68),
                cornerRadius: 0
            )
            
            .onAppear {
                let gifUrl = URL(string: exercise.gifUrl ?? "")
                print("DEBUG: Attempting to load GIF from URL: \(gifUrl?.absoluteString ?? "nil")")
                print("DEBUG: WorkoutExerciseRow - Exercise: \(exercise.name ?? "unnamed"), GIF URL: \(exercise.gifUrl ?? "nil")")
            }
            
            // Exercise info
            VStack(alignment: .leading, spacing: 0) {
                Text(exercise.name ?? "Unnamed Exercise")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.gray900)
                
                Text("\(setsCompleted) of \(totalSets) sets completed")
                    .font(.system(size: 12))
                    .foregroundColor(.gray400)
            }
            
            Spacer()
            
            // Completed indicator or more button
            if isCompleted {
                Text("Completed")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.indigo)
            }
            
            Button(action: onMoreTapped) {
                Image("ellipsis-horizontal")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(Color("gray400"))
                    .padding(8)
            }
        }
        .padding(2)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    VStack(spacing: 0) {
        // Exercise 1: In progress
        WorkoutExerciseRow(
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
                experience: "Intermediate",
                gifUrl: "https://fleiivpyjkvahakriuta.supabase.co/storage/v1/object/public/exercises/gifs/3_4_sit_up.gif"
            ),
            isCompleted: false,
            setsCompleted: 2,
            totalSets: 4,
            onMoreTapped: {}
        )
        
        // Exercise 2: Completed
        WorkoutExerciseRow(
            exercise: Exercise(
                id: "2",
                name: "Squat",
                exerciseType: "Strength",
                primaryMuscles: "Quadriceps,Glutes",
                secondaryMuscles: "Hamstrings",
                instructions: "Stand with feet shoulder-width apart...",
                experienceLevel: "Intermediate",
                muscleGroup: "Legs",
                description: "The squat is a compound exercise...",
                benefits: "Builds leg strength,Improves core stability",
                equipment: "Barbell",
                forceType: "Push",
                mechanics: "Compound",
                bodyPart: "Legs",
                target: "Quadriceps",
                experience: "Intermediate",
                gifUrl: "https://fleiivpyjkvahakriuta.supabase.co/storage/v1/object/public/exercises/gifs/3_4_sit_up.gif"
            ),
            isCompleted: true,
            setsCompleted: 3,
            totalSets: 3,
            onMoreTapped: {}
        )
        
        // Exercise 3: Not started
        WorkoutExerciseRow(
            exercise: Exercise(
                id: "3",
                name: "Deadlift",
                exerciseType: "Strength",
                primaryMuscles: "Lower back,Glutes",
                secondaryMuscles: "Hamstrings,Traps",
                instructions: "Stand with feet hip-width apart...",
                experienceLevel: "Advanced",
                muscleGroup: "Back",
                description: "The deadlift is a compound exercise...",
                benefits: "Builds overall strength,Improves posture",
                equipment: "Barbell",
                forceType: "Pull",
                mechanics: "Compound",
                bodyPart: "Back",
                target: "Lower back",
                experience: "Advanced",
                gifUrl: "https://fleiivpyjkvahakriuta.supabase.co/storage/v1/object/public/exercises/gifs/3_4_sit_up.gif"
            ),
            isCompleted: false,
            setsCompleted: 0,
            totalSets: 5,
            onMoreTapped: {}
        )
    }
    .padding()
    .background(Color("gray100"))
}
