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
                    .execute()
                
                // Print raw JSON response to debug
                print("📊 Raw response data sample: \(String(data: response.data.prefix(500), encoding: .utf8) ?? "Unable to decode")")
                
                let decoder = JSONDecoder.supabaseDecoder()
                let fetchedExercises = try decoder.decode([Exercise].self, from: response.data)
                print("✅ Successfully fetched \(fetchedExercises.count) exercises")
                
                // Debug: Print a sample and verify gif_url is being parsed
                print("Sample exercise data:")
                if let firstExercise = fetchedExercises.first {
                    print("ID: \(firstExercise.id)")
                    print("Name: \(firstExercise.name ?? "nil")")
                    print("GIF URL: \(firstExercise.gifUrl ?? "nil")")
                    
                    // Use a simpler debug approach without the extension
                    if let jsonData = try? JSONEncoder().encode(firstExercise),
                       let jsonString = String(data: jsonData, encoding: .utf8) {
                        print("Raw data for this exercise: \(jsonString)")
                    }
                }
                
                // Check how many exercises actually have GIF URLs
                let exercisesWithGifs = fetchedExercises.filter { $0.gifUrl != nil && !($0.gifUrl?.isEmpty ?? true) }
                print("Number of exercises with valid GIF URLs: \(exercisesWithGifs.count) out of \(fetchedExercises.count)")

                // Print examples of exercises that should have GIFs
                for (index, exercise) in fetchedExercises.prefix(10).enumerated() {
                    print("Exercise \(index + 1): \(exercise.name ?? "Unnamed") - GIF URL: \(exercise.gifUrl ?? "nil")")
                }
                
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

extension Data {
    func prettyPrintedJSONString() -> String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: .utf8) else { return nil }
        
        return prettyPrintedString
    }
}
