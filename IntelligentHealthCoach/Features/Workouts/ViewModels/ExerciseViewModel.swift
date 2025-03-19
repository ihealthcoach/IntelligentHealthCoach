//
//  ExerciseViewModel.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


import Foundation
import SwiftUI
import Combine
import Supabase

// ExerciseViewModel.swift
class ExerciseViewModel: ObservableObject {
    @Published var exercises: [Exercise] = []
    @Published var filteredExercises: [Exercise] = []
    @Published var exerciseGroups: [String: [Exercise]] = [:]
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchQuery = ""
    
    private let supabaseService: IntelligentHealthCoach.SupabaseServiceProtocol
    
    init(supabaseService: IntelligentHealthCoach.SupabaseServiceProtocol = SupabaseService.shared) {
        self.supabaseService = supabaseService
    }
    
    // In ExerciseViewModel.swift
    func fetchExercises() {
        Task {
            await MainActor.run {
                self.isLoading = true
                self.errorMessage = nil
            }
            
            do {
                print("⏳ Attempting to fetch exercises from Supabase...")
                let fetchedExercises = try await supabaseService.fetchExercises()
                print("✅ Successfully fetched \(fetchedExercises.count) exercises")
                
                await MainActor.run {
                    self.exercises = fetchedExercises
                    self.filteredExercises = fetchedExercises
                    self.organizeExercisesAlphabetically()
                    self.isLoading = false
                }
            } catch {
                print("❌ Error fetching exercises: \(error)")
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    // Update the organizeExercisesAlphabetically method:
    func organizeExercisesAlphabetically() {
        var groups: [String: [Exercise]] = [:]
        
        for exercise in filteredExercises {
            // Safely unwrap the name
            guard let name = exercise.name, !name.isEmpty else {
                continue // Skip exercises with no name
            }
            
            // Get the first character of the exercise name
            if let firstChar = name.first {
                let firstCharString = String(firstChar)
                
                // Determine which group this exercise belongs to
                let group: String
                if firstCharString.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
                    // If the first character is a number, use "#" as the group
                    group = "#"
                } else {
                    // Otherwise, use the uppercase letter
                    group = firstCharString.uppercased()
                }
                
                // Create array if it doesn't exist for this group
                if groups[group] == nil {
                    groups[group] = []
                }
                
                // Add exercise to the appropriate group
                groups[group]?.append(exercise)
            }
        }
        
        // Sort exercises within each group
        for (key, exercises) in groups {
            groups[key] = exercises.sorted(by: {
                ($0.name ?? "") < ($1.name ?? "")
            })
        }
        
        self.exerciseGroups = groups
    }
    
    func filterExercises() {
        if searchQuery.isEmpty {
            filteredExercises = exercises
        } else {
            filteredExercises = exercises.filter { exercise in
                // Safely check each property with nil coalescing
                (exercise.name ?? "").lowercased().contains(searchQuery.lowercased()) ||
                (exercise.muscleGroup ?? "").lowercased().contains(searchQuery.lowercased()) ||
                exercise.primaryMusclesArray.contains(where: {
                    $0.lowercased().contains(searchQuery.lowercased())
                })
            }
        }
        
        organizeExercisesAlphabetically()
    }
}
