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
    @StateObject var viewModel = WorkoutExercisesViewModel()
    @State private var showingMoreOptions = false
    @State private var selectedExercise: Exercise?
    @State private var showingExerciseLibrary = false
    
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
                        .background(Color.indigo)
                        .foregroundColor(.offwhite)
                        .cornerRadius(8)
                    }
                }
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
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
                    .padding(.bottom, 100) // Add padding for the buttons
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
                            .padding(.vertical, 16)
                            .background(Color.indigo)
                            .cornerRadius(8)
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
                        .padding(.vertical, 16)
                        .background(Color.offwhite)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
                .padding()
                .background(Color.offwhite)
                .shadow(color: Color.gray900.opacity(0.1), radius: 5, x: 0, y: -3)
            }
        }
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
                WorkoutTrackingView(viewModel: WorkoutTrackingViewModel(workout: workout))
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

#Preview {
    NavigationStack {
        WorkoutExercisesView()
    }
}
