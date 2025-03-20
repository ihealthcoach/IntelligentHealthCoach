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
            KFImage(URL(string: exercise.gifUrl ?? ""))
                .placeholder {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.2))
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 68, height: 68)
                .blendMode(.multiply)
                .background(Color("gray50"))
                .clipShape(RoundedRectangle(cornerRadius: 6))
            
            // Exercise info
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name ?? "Unnamed Exercise")
                    .font(.system(size: 16, weight: .medium))
                
                Text("\(setsCompleted) of \(totalSets) sets completed")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Completed indicator or more button
            if isCompleted {
                Text("Completed")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.indigo)
            }
            
            Button(action: onMoreTapped) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.gray)
                    .padding(8)
            }
        }
        .padding()
        .background(Color.offwhite)
        .cornerRadius(12)
        .shadow(color: Color.gray900.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
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
    .padding()
}
