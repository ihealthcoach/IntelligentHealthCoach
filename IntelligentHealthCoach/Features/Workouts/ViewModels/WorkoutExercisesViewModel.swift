//
//  WorkoutExercisesViewModel.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 17/03/2025.
//

import Foundation
import SwiftUI
import Combine

class WorkoutExercisesViewModel: ObservableObject {
    @Published var exercises: [Exercise] = []
    @Published var exerciseSets: [String: [WorkoutSet]] = [:] // Exercise ID -> Sets
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var createdWorkout: Workout?
    @Published var showingWorkoutTracking = false
    
    private let supabaseService: SupabaseServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(supabaseService: SupabaseServiceProtocol = SupabaseService.shared) {
        self.supabaseService = supabaseService
        loadFromLocalCache()
    }
    
    // MARK: - Public Methods
    
    func addExercise(_ exercise: Exercise, setsCount: Int = 3) {
        // Add the exercise if it's not already in the list
        if !exercises.contains(where: { $0.id == exercise.id }) {
            exercises.append(exercise)
            
            // Create default sets for the exercise
            var sets: [WorkoutSet] = []
            for _ in 0..<setsCount {
                let set = WorkoutSet(
                    id: UUID().uuidString,
                    workoutExerciseDetailsId: "", // Will be populated when saved to database
                    weight: 0,
                    type: "normal",
                    reps: 0,
                    completed: false,
                    createdAt: Date(),
                    updatedAt: Date()
                )
                sets.append(set)
            }
            exerciseSets[exercise.id] = sets
            
            // Save to local cache
            saveToLocalCache()
        }
    }
    
    func removeExercise(_ exercise: Exercise) {
        exercises.removeAll { $0.id == exercise.id }
        exerciseSets.removeValue(forKey: exercise.id)
        saveToLocalCache()
    }
    
    func replaceExercise(_ exercise: Exercise) {
        // Store the sets temporarily
        let existingSets = exerciseSets[exercise.id]
        
        // Remove the exercise
        removeExercise(exercise)
        
        // Navigate to exercise library to pick a replacement
        // The new exercise will be added when the user selects it
    }
    
    func buildSuperset(with exercise: Exercise) {
        // In a real implementation, this would show a UI for selecting exercises to pair with
        // For now, we'll just log it
        print("Build superset for: \(exercise.name ?? "Unknown")")
    }
    
    func showPreviousStats(for exercise: Exercise) {
        // In a real implementation, this would fetch and display historical data
        print("Show previous stats for: \(exercise.name ?? "Unknown")")
    }
    
    func showExerciseGuide(for exercise: Exercise) {
        // In a real implementation, this would navigate to a detailed exercise view
        print("Show exercise guide for: \(exercise.name ?? "Unknown")")
    }
    
    func reorderExercises() {
        // In a real implementation, this would enable drag/drop reordering
        print("Enable reordering of exercises")
    }
    
    func clearAllExercises() {
        exercises.removeAll()
        exerciseSets.removeAll()
        saveToLocalCache()
    }
    
    func saveAsTemplate() {
        isLoading = true
        
        Task {
            do {
                // Get the auth session and user
                let session = try await supabaseService.client.auth.session
                let userId = session.user.id.uuidString
                
                // Create the template
                // In a real implementation, this would prompt for a name
                let templateName = "My Template \(Date().formatted(date: .abbreviated, time: .shortened))"
                
                // Save the template
                // This would typically be a specific endpoint or table in your backend
                // For now, we'll simulate it
                
                await MainActor.run {
                    self.isLoading = false
                    // Show success message
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to save template: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
    
    func saveAsRoutine() {
        // Similar to saveAsTemplate but with different backend logic
        print("Save as routine")
    }
    
    func shareWorkout() {
        // In a real implementation, this would generate a shareable link or text
        print("Share workout")
    }
    
    func startWorkout() {
        isLoading = true
        
        Task {
            do {
                // Get the auth session and user
                let session = try await supabaseService.client.auth.session
                let userId = session.user.id.uuidString
                
                // Create a new workout in the database
                let newWorkout = Workout(
                    id: UUID().uuidString,
                    userId: userId,
                    title: "Workout \(Date().formatted(date: .abbreviated, time: .shortened))",
                    exercises: exercises,
                    createdAt: Date(),
                    updatedAt: Date(),
                    status: "active"
                )
                
                // Save the workout to Supabase
                let savedWorkout = try await supabaseService.createWorkout(newWorkout)
                
                // For each exercise, create workout exercise details and sets
                for exercise in exercises {
                    // Create workout exercise details
                    let workoutExerciseDetails = try await supabaseService.createWorkoutExerciseDetails(
                        workoutId: savedWorkout.id,
                        exerciseId: exercise.id
                    )
                    
                    // Update the sets with the correct workoutExerciseDetailsId
                    if let sets = exerciseSets[exercise.id] {
                        for set in sets {
                            // In a real implementation, you would save each set to the database
                            // and update the local collection with the returned data
                            // For now, we'll simulate this
                        }
                    }
                }
                
                await MainActor.run {
                    self.createdWorkout = savedWorkout
                    self.isLoading = false
                    self.showingWorkoutTracking = true
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to start workout: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
    
    // MARK: - Status Tracking
    
    func isExerciseCompleted(_ exercise: Exercise) -> Bool {
        guard let sets = exerciseSets[exercise.id], !sets.isEmpty else { return false }
        return sets.allSatisfy { $0.completed }
    }
    
    func setsCompletedCount(for exercise: Exercise) -> Int {
        guard let sets = exerciseSets[exercise.id] else { return 0 }
        return sets.filter { $0.completed }.count
    }
    
    func totalSetsCount(for exercise: Exercise) -> Int {
        return exerciseSets[exercise.id]?.count ?? 0
    }
    
    // MARK: - Private Methods
    
    private func saveToLocalCache() {
        // In a real implementation, this would save the current state to a local cache
        // For simplicity, we're just simulating it here
        print("Saving workout to local cache: \(exercises.count) exercises")
        
        // You could use UserDefaults, CoreData, or another local storage mechanism
        // For example:
        /*
        let encoder = JSONEncoder()
        if let exercisesData = try? encoder.encode(exercises) {
            UserDefaults.standard.set(exercisesData, forKey: "cached_workout_exercises")
        }
        */
    }
    
    private func loadFromLocalCache() {
        // In a real implementation, this would load the current state from a local cache
        // For simplicity, we're just simulating it here
        print("Loading workout from local cache")
        
        // You could use UserDefaults, CoreData, or another local storage mechanism
        // For example:
        /*
        if let exercisesData = UserDefaults.standard.data(forKey: "cached_workout_exercises"),
           let loadedExercises = try? JSONDecoder().decode([Exercise].self, from: exercisesData) {
            self.exercises = loadedExercises
        }
        */
    }
}
