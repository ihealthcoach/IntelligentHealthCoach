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
import Kingfisher

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
    
    func fetchExercises() {
        Task {
            await MainActor.run {
                self.isLoading = true
                self.errorMessage = nil
            }
            
            do {
                print("⏳ Attempting to fetch exercises from Supabase...")
                let response = try await supabaseService.client
                    .from("exercises")
                    .select()
                    .limit(2000) // Increased limit to get all records
                    .execute()
                
                let decoder = JSONDecoder.supabaseDecoder()
                let fetchedExercises = try decoder.decode([Exercise].self, from: response.data)
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
    
    // Add this function to ExerciseViewModel
    func searchSpecificExercise(name: String) {
        Task {
            do {
                print("🔍 Directly searching for exercise: \(name)")
                let response = try await supabaseService.client
                    .from("exercises")
                    .select()
                    .ilike("name", value: "%\(name)%")
                    .execute()
                
                if let responseString = String(data: response.data, encoding: .utf8) {
                    print("📊 Direct search response: \(responseString)")
                }
                
                let decoder = JSONDecoder.supabaseDecoder()
                let foundExercises = try decoder.decode([Exercise].self, from: response.data)
                print("🏋️‍♂️ Direct search found \(foundExercises.count) exercises")
                
                for exercise in foundExercises {
                    print("  - \(exercise.name ?? "Unnamed"): ID \(exercise.id)")
                }
                
                if !foundExercises.isEmpty {
                    await MainActor.run {
                        // Add these to the existing list if not already present
                        for exercise in foundExercises {
                            if !self.exercises.contains(where: { $0.id == exercise.id }) {
                                self.exercises.append(exercise)
                                print("⚠️ Exercise was missing and has been added: \(exercise.name ?? "Unnamed")")
                            }
                        }
                        // Re-filter and organize
                        self.filterExercises()
                    }
                }
            } catch {
                print("❌ Error in direct search: \(error)")
            }
        }
    }
    
    // Add this function to ExerciseViewModel
    func clearCacheAndRefresh() {
        Task {
            await MainActor.run {
                // Clear all existing data
                self.exercises = []
                self.filteredExercises = []
                self.exerciseGroups = [:]
                self.isLoading = true
            }
            
            // Simulate a fresh app launch
            try? await Task.sleep(nanoseconds: 500_000_000) // Half-second delay
            
            // Fetch from scratch
            await fetchExercises()
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

extension Data {
    func prettyPrintedJSONString() -> String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: .utf8) else { return nil }
        
        return prettyPrintedString
    }
}
