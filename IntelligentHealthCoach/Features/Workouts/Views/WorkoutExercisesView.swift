//
//  WorkoutExercisesView.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 17/03/2025.
//

import SwiftUI
import Kingfisher

struct WorkoutExercisesView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: WorkoutExercisesViewModel
    @State private var showingMoreOptions = false
    @State private var selectedExercise: Exercise?
    @State private var showingExerciseLibrary = false
    
    init(viewModel: WorkoutExercisesViewModel = WorkoutExercisesViewModel()) {
        print("WorkoutExercisesView init with \(viewModel.exercises.count) exercises")
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Top navigation bar
            HStack {
                // Back button
                BackButton {
                    presentationMode.wrappedValue.dismiss()
                }
                
                Spacer()
                
                // Save template button
                Button(action: {
                    viewModel.saveAsTemplate()
                }) {
                    HStack {
                        Text("Save as template")
                        Image(systemName: "bookmark")
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.gray900)
                    .foregroundColor(.offwhite)
                    .cornerRadius(20)
                }
                
                // More button
                Button(action: {
                    selectedExercise = nil // Ensure no exercise is selected for workout-level options
                    showingMoreOptions = true
                }) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.gray900)
                        .padding(8)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            // Title and description
            VStack(alignment: .leading, spacing: 4) {
                Text("Workout")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.gray900)
                
                Text("\(viewModel.exercises.count) exercises added to your workout")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.top, 16)
            
            // Exercises list
            if viewModel.exercises.isEmpty {
                Spacer()
                VStack(spacing: 20) {
                    Image(systemName: "dumbbell.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("No exercises added yet")
                        .font(.title2)
                        .fontWeight(.medium)
                    
                    Text("Start by adding exercises to your workout")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Button(action: {
                        showingExerciseLibrary = true
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Exercise")
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.indigo600)
                        .foregroundColor(.offwhite)
                        .cornerRadius(5)
                    }
                }
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.exercises) { exercise in
                            WorkoutExerciseRow(
                                exercise: exercise,
                                isCompleted: viewModel.isExerciseCompleted(exercise),
                                setsCompleted: viewModel.setsCompletedCount(for: exercise),
                                totalSets: viewModel.totalSetsCount(for: exercise),
                                onMoreTapped: {
                                    selectedExercise = exercise
                                    showingMoreOptions = true
                                }
                            )
                            .contextMenu {
                                Button(role: .destructive, action: {
                                    viewModel.removeExercise(exercise)
                                }) {
                                    Label("Remove", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    viewModel.removeExercise(exercise)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24) // Add padding for the buttons
                }
                
                // Bottom buttons
                VStack(spacing: 8) {
                    Button(action: {
                        viewModel.startWorkout()
                    }) {
                        Text("Start workout")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.offwhite)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(Color.indigo600)
                            .cornerRadius(5)
                    }
                    
                    Button(action: {
                        showingExerciseLibrary = true
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add exercise")
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.gray900)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color.offwhite)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
                .padding()
                /*.background(Color.offwhite)*/
                /*.shadow(color: Color.gray900.opacity(0.1), radius: 5, x: 0, y: -3)*/
            }
        }
        .withSafeAreaSpacer()
        .appBackground()
        .navigationBarHidden(true)
        .sheet(isPresented: $showingMoreOptions) {
            if let exercise = selectedExercise {
                ExerciseOptionsSheet(exercise: exercise, onOptionSelected: { option in
                    handleOptionSelected(option, for: exercise)
                    showingMoreOptions = false
                })
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            } else {
                // Workout-level options
                WorkoutOptionsSheet(onOptionSelected: { option in
                    handleWorkoutOptionSelected(option)
                    showingMoreOptions = false
                })
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            }
        }
        .navigationDestination(isPresented: $showingExerciseLibrary) {
            ExerciseLibraryView(selectionMode: true, onExerciseSelected: { exercise in
                viewModel.addExercise(exercise)
                showingExerciseLibrary = false
            })
            .navigationBarBackButtonHidden(true)
        }
        .navigationDestination(isPresented: $viewModel.showingWorkoutTracking) {
            if let workout = viewModel.createdWorkout {
                WorkoutTrackingView(viewModel: WorkoutTrackingViewModel(
                    workout: workout,
                    exercises: viewModel.exercises
                ))
            } else {
                // Fallback view when workout is nil
                Text("No workout data available")
                    .padding()
            }
        }
        .loadingOverlay(isLoading: viewModel.isLoading)
    }
    
    private func handleOptionSelected(_ option: ExerciseOption, for exercise: Exercise) {
        switch option {
        case .replace:
            viewModel.replaceExercise(exercise)
        case .buildSuperset:
            viewModel.buildSuperset(with: exercise)
        case .previousStats:
            viewModel.showPreviousStats(for: exercise)
        case .exerciseGuide:
            viewModel.showExerciseGuide(for: exercise)
        case .reorder:
            viewModel.reorderExercises()
        case .remove:
            viewModel.removeExercise(exercise)
        }
    }
    
    private func handleWorkoutOptionSelected(_ option: WorkoutOption) {
        switch option {
        case .clearAll:
            viewModel.clearAllExercises()
        case .saveAsRoutine:
            viewModel.saveAsRoutine()
        case .shareWorkout:
            viewModel.shareWorkout()
        }
    }
}

struct WorkoutExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview for Empty State
            NavigationStack {
                WorkoutExercisesView(viewModel: WorkoutExercisesViewModel())
            }
            .previewDisplayName("Empty State")
            
            // Preview with exercises
            NavigationStack {
                WorkoutExercisesView(viewModel: createMockViewModel())
            }
            .previewDisplayName("With Exercises")
            
            // Preview with loading state
            NavigationStack {
                let viewModel = WorkoutExercisesViewModel()
                viewModel.isLoading = true
                return WorkoutExercisesView(viewModel: viewModel)
            }
            .previewDisplayName("Loading State")
        }
    }
    
    // Helper function to create a populated view model for preview
    static func createMockViewModel() -> WorkoutExercisesViewModel {
        let viewModel = WorkoutExercisesViewModel()
        
        // Create sample exercises
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
            ),
            Exercise(
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
            )
        ]
        
        // Add each exercise with different set counts
        viewModel.addExercise(exercises[0], setsCount: 3)
        viewModel.addExercise(exercises[1], setsCount: 4)
        viewModel.addExercise(exercises[2], setsCount: 5)
        
        // Return the populated view model
        return viewModel
    }
}

// Helper function to create a populated view model for preview
private func createMockViewModel() -> WorkoutExercisesViewModel {
    let viewModel = WorkoutExercisesViewModel()
    
    // Create sample exercises
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
        ),
        Exercise(
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
        )
    ]
    
    // Add each exercise with different set counts
    viewModel.addExercise(exercises[0], setsCount: 3)
    viewModel.addExercise(exercises[1], setsCount: 4)
    viewModel.addExercise(exercises[2], setsCount: 5)
    
    // Return the populated view model
    return viewModel
}
