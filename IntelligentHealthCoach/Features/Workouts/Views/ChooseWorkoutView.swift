//
//  SwiftUIView.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 16/03/2025.
//

import SwiftUI

struct ChooseWorkoutView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab = 3
    @State private var showingExerciseLibrary = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Back button
            BackButton {
                presentationMode.wrappedValue.dismiss()
            }
            .padding(.bottom, 8)
            
            // Title and description
            Text("Workout")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(Color("gray900"))
            
            Text("Choose from the selection below")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color("gray400"))
                .padding(.bottom, 24)
            
            // Option buttons
            VStack(spacing: 8) {
                ChooseWorkoutButton(
                    title: "Using a saved template",
                    description: "Follow a workout template from your saved workout templates"
                ) {
                    // Handle template selection
                }
                
                ChooseWorkoutButton(
                    title: "Without a template",
                    description: "Add exercises as you go"
                ) {
                    // Navigate to ExerciseLibraryView
                    showingExerciseLibrary = true
                }
                
                ChooseWorkoutButton(
                    title: "Using a previous workout",
                    description: "Use a workout from a previous completed workout"
                ) {
                    // Handle previous workout option
                }
            }
            .frame(maxWidth: .infinity)
            
            // Cancel button
            Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(Color("gray400"))
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 16)
        }
        

        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("gray100"))
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showingExerciseLibrary) {
            ExerciseLibraryView(selectionMode: true, onExerciseSelected: { exercise in
                // Handle selected exercise
                showingExerciseLibrary = false // Navigate back when done
            })
            .navigationBarBackButtonHidden(true) // Hide default back button on the library view
        }
        
        VStack {
            Spacer()
            TabBarView(
                selectedTab: $selectedTab,
                onShowChooseWorkout: {
                }
            )
        }
    }
}

// Preview
struct ChooseWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseWorkoutView()
    }
}
