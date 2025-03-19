//
//  ExerciseLibraryView.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


import SwiftUI
import Kingfisher

struct ExerciseLibraryView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = ExerciseViewModel()
    @StateObject var workoutBuilder = WorkoutBuilderViewModel()
    @State private var selectedCategory = "A-Z"
    @State private var selectedExerciseIds: Set<String> = []
    @State private var showingSetsSheet = false
    @State private var scrollToLetter: String? = nil
    @State private var selectedSetsCount = 3 // Default sets count
    @State private var selectedExercises: [Exercise] = [] // Track selected exercise
    @State private var showingWorkoutExercisesView = false // For navigation
    @State private var showFilterSheet = false // For filter functionality
    @State private var showingWorkoutExercisesSheet = false // Add a state variable to track if the workout exercise view is shown as a sheet
    
    var selectionMode: Bool = true
    var onExerciseSelected: ((Exercise) -> Void)? = nil
    
    var body: some View {
        ZStack {
            // Main content
            VStack(spacing: 0) {
                HeaderView(
                    onBack: { presentationMode.wrappedValue.dismiss() },
                    showWorkoutSheet: $showingWorkoutExercisesSheet  // Pass the binding here
                )
                
                TitleView(
                    title: "Library",
                    subtitle: "Add exercises to your workout"
                )
                
                CategorySelectionView(
                    selectedCategory: $selectedCategory
                )
                
                // Exercise list with alphabet index
                ExerciseListView(
                    viewModel: viewModel,
                    workoutBuilder: workoutBuilder,
                    scrollToLetter: $scrollToLetter,
                    onToggleSelection: toggleExerciseSelection
                )
                
                Spacer(minLength: 0)
            }
            
            // Bottom action buttons (conditionally shown)
            if !selectedExerciseIds.isEmpty {
                BottomActionButtonsView(
                    selectedCount: selectedExerciseIds.count,
                    onAddExercises: { showingSetsSheet = true },
                    onBuildSuperSet: { /* Will implement later */ }
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.spring(response: 0.3, dampingFraction: 0.8), value: selectedExerciseIds.count)
                .zIndex(1)
            }
            
            // Floating Action Button
            FloatingActionButtonView(
                selectedCount: selectedExerciseIds.count,
                onTap: {
                    if selectedExerciseIds.isEmpty {
                        showFilterSheet = true
                    }
                }
            )
            .zIndex(2)
        }
        .appBackground()
        .navigationBarHidden(true)
        .onAppear {
            viewModel.fetchExercises()
        }
        .sheet(isPresented: $showingSetsSheet) {
            SetsSelectionSheet(
                selectedSetsCount: $selectedSetsCount,
                exercises: selectedExercises,
                onConfirm: { setsCount in
                    // Handle the selected sets count
                    addExercisesToWorkout(exercises: selectedExercises, setsCount: setsCount)
                }
            )
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $showFilterSheet) {
            FilterSheetView(onClose: { showFilterSheet = false })
        }
        .navigationDestination(isPresented: $showingWorkoutExercisesView) {
            WorkoutExercisesView()
                .navigationBarBackButtonHidden(true)
        }
        
        // Add sheet presentation for current workout
        .sheet(isPresented: $showingWorkoutExercisesSheet) {
            NavigationView {
                WorkoutPreviewView(
                    selectedExercises: $selectedExercises,      // Pass binding
                    selectedSetsCount: $selectedSetsCount,      // Pass binding
                    onDismiss: { showingWorkoutExercisesSheet = false }
                )
                .navigationTitle("Current Workout")
                .navigationBarItems(
                    trailing: Button("Done") {
                        showingWorkoutExercisesSheet = false
                    }
                )
            }
        }
    }
    
    // Private function to toggle exercise selection
    private func toggleExerciseSelection(_ exercise: Exercise) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        if workoutBuilder.containsExercise(id: exercise.id) {
            workoutBuilder.removeExercise(exercise)
        } else {
            workoutBuilder.addExercise(exercise)
        }
    }
    
    // Helper function to add exercises to workout
    private func addExercisesToWorkout(exercises: [Exercise], setsCount: Int) {
        // Create a WorkoutExercisesViewModel and add the exercises
        let workoutVM = WorkoutExercisesViewModel()
        
        // Add each exercise with the specified number of sets
        for exercise in exercises {
            workoutVM.addExercise(exercise, setsCount: setsCount)
        }
        
        // Navigate to the WorkoutExercisesView
        showingWorkoutExercisesView = true
        
        // Clear selections after adding
        selectedExercises.removeAll()
        selectedExerciseIds.removeAll()
    }
}

// Preview for development
struct ExerciseLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseLibraryView()
    }
}
