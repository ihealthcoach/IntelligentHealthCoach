//
//  SetsSelectionSheet.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 17/03/2025.
//

import SwiftUI

struct SetsSelectionSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedSetsCount: Int
    var exercises: [Exercise]
    var onConfirm: (Int) -> Void
    
    var body: some View {
        FlexibleSheet(title: "Add set amount") {
            VStack(spacing: 20) {
                // Exercise summary
                HStack {
                    Text("Adding \(exercises.count) exercise\(exercises.count > 1 ? "s" : "")")
                        .font(.headline)
                    Spacer()
                }
                .padding(.horizontal)
                
                // Sets picker
                VStack(spacing: 8) {
                    Text("How many sets?")
                        .font(.subheadline)
                        .foregroundColor(Color("gray600"))
                    
                    // Picker in a scrolling wheel style
                    Picker("Sets", selection: $selectedSetsCount) {
                        ForEach(1...50, id: \.self) { count in
                            Text("\(count) set\(count > 1 ? "s" : "")")
                                .font(.system(size: 24, weight: .bold))
                                .tag(count)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 150)
                    .clipped()
                }
                .padding()
                .padding(.horizontal)
                
                // Action button
                Button(action: {
                    onConfirm(selectedSetsCount)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save sets")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.offwhite)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color("indigo600"))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
            .padding(.top, 16)
        }
    }
}

// Preview provider for the SetsSelectionSheet
struct SetsSelectionSheet_Previews: PreviewProvider {
    static var previews: some View {
        // Create a state object in the preview to handle the binding
        PreviewWrapper()
    }
    
    // Helper wrapper to handle state in preview
    struct PreviewWrapper: View {
        @State private var setsCount = 3
        
        var body: some View {
            // Sample exercises for the preview
            let exercises = [
                Exercise(
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
                Exercise(
                    id: "2",
                    name: "Squat",
                    exerciseType: "Strength",
                    primaryMuscles: "Quadriceps,Glutes",
                    secondaryMuscles: "Hamstrings,Lower back",
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
                )
            ]
            
            SetsSelectionSheet(
                selectedSetsCount: $setsCount,
                exercises: exercises,
                onConfirm: { _ in }
            )
            .background(Color.gray.opacity(0.3)) // Background for preview only
        }
    }
}
