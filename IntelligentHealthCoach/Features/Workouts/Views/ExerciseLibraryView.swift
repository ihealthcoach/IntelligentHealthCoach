//
//  ExerciseLibraryView.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


import SwiftUI
import Kingfisher
import UIKit

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
    @State private var workoutExercisesViewModel = WorkoutExercisesViewModel()
    @State private var showingWorkoutActionSheet = false
    @State private var navigationDestination: NavigationDestination?
    @State private var showChooseWorkoutView = false

    // Define an enum for navigation destinations
    enum NavigationDestination {
        case back, workoutExercises
    }
    
    var selectionMode: Bool = true
    var onExerciseSelected: ((Exercise) -> Void)? = nil
    
    var body: some View {
        ZStack {
            // Main content
            VStack(spacing: 0) {
                HeaderView(
                    onBack: {
                        if !workoutExercisesViewModel.exercises.isEmpty {
                            navigationDestination = .back
                            showingWorkoutActionSheet = true
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    },
                    showWorkoutSheet: $showingWorkoutExercisesSheet,
                    trailingButton: { getDoneButton() }
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
                
                    .confirmationDialog(
                        "What would you like to do with your workout?",
                        isPresented: $showingWorkoutActionSheet,
                        titleVisibility: .visible
                    ) {
                        Button("Continue tracking") {
                            // Just dismiss the dialog and stay on the current screen
                        }
                        
                        Button("Mark as completed") {
                            // Mark workout as complete and navigate back
                            // Logic to save workout as completed would go here
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                        Button("Finish later") {
                            // Save workout state for later and navigate back
                            // Logic to save workout state would go here
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                        Button("Discard workout", role: .destructive) {
                            // Reset workout and navigate to ChooseWorkoutView
                            workoutExercisesViewModel = WorkoutExercisesViewModel()
                            selectedExercises.removeAll()
                            selectedExerciseIds.removeAll()
                            
                            // Navigate to ChooseWorkoutView
                            showChooseWorkoutView = true
                            
                            // Dismiss the current view
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
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
        .withSafeAreaSpacer()
        .appBackground()
        /*.navigationBarHidden(true)*/
        .onAppear {
            viewModel.fetchExercises()
        }
        .sheet(isPresented: $showingSetsSheet) {
            SetsSelectionSheet(
                selectedSetsCount: $selectedSetsCount,
                exercises: selectedExercises,
                onConfirm: { setsCount in
                    // Handle the selected sets count
                    addExercisesToWorkout()
                    
                    // Navigate to the WorkoutExercisesView
                    navigationDestination = .workoutExercises
                    showingWorkoutExercisesView = true
                    
                    // Clear selection after adding
                    selectedExercises.removeAll()
                    selectedExerciseIds.removeAll()
                }
            )
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $showFilterSheet) {
            FilterSheetView(onClose: { showFilterSheet = false })
        }
        .onAppear {
            viewModel.fetchExercises()
        }
        .navigationDestination(isPresented: $showingWorkoutExercisesView) {
            WorkoutExercisesView(viewModel: workoutExercisesViewModel)
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    print("WorkoutExercisesView appeared with \(workoutExercisesViewModel.exercises.count) exercises")
                }
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
    
    private func prepareWorkoutViewModel() {
        if showingWorkoutExercisesView {
            // Create a new instance for a fresh view model
            workoutExercisesViewModel = WorkoutExercisesViewModel()
            
            // Add each selected exercise with the specified number of sets
            for exercise in selectedExercises {
                workoutExercisesViewModel.addExercise(exercise, setsCount: selectedSetsCount)
            }
        }
    }
    
    // Private function to toggle exercise selection
    private func toggleExerciseSelection(_ exercise: Exercise) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        if workoutBuilder.containsExercise(id: exercise.id) {
            workoutBuilder.removeExercise(exercise)
            selectedExerciseIds.remove(exercise.id)
            selectedExercises.removeAll(where: { $0.id == exercise.id })
        } else {
            workoutBuilder.addExercise(exercise)
            selectedExerciseIds.insert(exercise.id)
            selectedExercises.append(exercise)
        }
    }
    
    // Helper function to add exercises to workout
    private func addExercisesToWorkout() {
        // Create a new model only if we don't have one yet
        if workoutExercisesViewModel.exercises.isEmpty {
            workoutExercisesViewModel = WorkoutExercisesViewModel()
        }
        
        // Add each newly selected exercise to the existing model
        for exercise in selectedExercises {
            // Only add if it doesn't already exist in the workout
            if !workoutExercisesViewModel.exercises.contains(where: { $0.id == exercise.id }) {
                workoutExercisesViewModel.addExercise(exercise, setsCount: selectedSetsCount)
            }
        }
        
        // Clear the selection in the library view
        selectedExercises.removeAll()
        selectedExerciseIds.removeAll()
    }
    
    private func getDoneButton() -> AnyView {
        if workoutBuilder.selectedExercises.count > 0 {
            return AnyView(
                Button(action: {
                    addSelectedExercisesToWorkout()
                    showingWorkoutExercisesView = true
                }) {
                    Text("Done")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.indigo)
                }
            )
        } else {
            return AnyView(EmptyView())
        }
    }
    
    private func addSelectedExercisesToWorkout() {
        // Get any existing exercises
        let existingExercises = workoutExercisesViewModel.exercises
        
        // Create a new model only if we don't have one yet
        if existingExercises.isEmpty {
            workoutExercisesViewModel = WorkoutExercisesViewModel()
        }
        
        // Add each newly selected exercise to the existing model
        for exercise in workoutBuilder.selectedExercises {
            // Only add if it doesn't already exist in the workout
            if !workoutExercisesViewModel.exercises.contains(where: { $0.id == exercise.id }) {
                workoutExercisesViewModel.addExercise(exercise, setsCount: selectedSetsCount)
            }
        }
        
        // Clear the selection in the library view
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
