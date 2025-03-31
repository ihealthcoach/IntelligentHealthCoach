//
//  WorkoutActionSheet.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 16/03/2025.
//

import SwiftUI

struct WorkoutActionSheet: View {
    @Environment(\.presentationMode) var presentationMode
    var onTrackWorkout: () -> Void
    var onWorkoutHistory: () -> Void
    var onWorkoutTemplates: () -> Void
    var onFindWorkout: () -> Void
    
    var body: some View {
        FlexibleSheet(title: "Workouts", showBottomDragIndicator: false) {
            VStack(spacing: 0) {
                SheetActionButton(title: "Track a workout") {
                    presentationMode.wrappedValue.dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        onTrackWorkout()
                    }
                }
                
                SheetActionButton(title: "Workout history") {
                    presentationMode.wrappedValue.dismiss()
                    onWorkoutHistory()
                }
                
                SheetActionButton(title: "My workout templates") {
                    presentationMode.wrappedValue.dismiss()
                    onWorkoutTemplates()
                }
                
                SheetActionButton(title: "Find a workout") {
                    presentationMode.wrappedValue.dismiss()
                    onFindWorkout()
                }
                
                Spacer()
            }
            .padding(.top, 8)
        }
    }
}

// Preview functionality for SwiftUI Canvas
struct WorkoutActionSheet_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.offwhite.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                WorkoutActionSheet(
                    onTrackWorkout: {},
                    onWorkoutHistory: {},
                    onWorkoutTemplates: {},
                    onFindWorkout: {}
                )
            }
        }
    }
}
