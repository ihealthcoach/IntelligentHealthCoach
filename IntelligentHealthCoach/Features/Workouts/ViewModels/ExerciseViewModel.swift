//
//  ExerciseViewModel.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// ExerciseViewModel.swift
import SwiftUI
import Combine

class ExerciseViewModel: ObservableObject {
    @Published var exercises: [Exercise] = []
    @Published var filteredExercises: [Exercise] = []
    @Published var exerciseGroups: [String: [Exercise]] = [:]
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchQuery = ""
    
    private let supabaseService = SupabaseService.shared
    
    func fetchExercises() {
        Task {
            await MainActor.run { 
                self.isLoading = true
                self.errorMessage = nil
            }
            
            do {
                let fetchedExercises = try await supabaseService.fetchExercises()
                await MainActor.run {
                    self.exercises = fetchedExercises
                    self.filteredExercises = fetchedExercises
                    self.organizeExercisesAlphabetically()
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    func organizeExercisesAlphabetically() {
        var groups: [String: [Exercise]] = [:]
        
        for exercise in filteredExercises {
            // Get the first letter of the exercise name, uppercased
            if let firstChar = exercise.name.first?.uppercased() {
                let firstLetter = String(firstChar)
                
                // Create array if it doesn't exist for this letter
                if groups[firstLetter] == nil {
                    groups[firstLetter] = []
                }
                
                // Add exercise to the appropriate group
                groups[firstLetter]?.append(exercise)
            }
        }
        
        // Sort exercises within each group
        for (key, exercises) in groups {
            groups[key] = exercises.sorted(by: { $0.name < $1.name })
        }
        
        self.exerciseGroups = groups
    }
    
    func filterExercises() {
        if searchQuery.isEmpty {
            filteredExercises = exercises
        } else {
            filteredExercises = exercises.filter { exercise in
                exercise.name.lowercased().contains(searchQuery.lowercased()) ||
                exercise.muscleGroup.lowercased().contains(searchQuery.lowercased()) ||
                exercise.primaryMuscles.contains { $0.lowercased().contains(searchQuery.lowercased()) }
            }
        }
        
        organizeExercisesAlphabetically()
    }
}