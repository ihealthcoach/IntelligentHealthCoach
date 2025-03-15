//
//  WorkoutViewModel.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// WorkoutViewModel.swift
import SwiftUI
import Combine

// WorkoutViewModel.swift
class WorkoutViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var currentWorkout: Workout?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var templates: [WorkoutTemplate] = [] // Add this if it's missing
    
    private let supabaseService: SupabaseServiceProtocol
    
    // Constructor with dependency injection
    init(supabaseService: SupabaseServiceProtocol = SupabaseService.shared) {
        self.supabaseService = supabaseService
    }
    
    // Now update all your methods to use the injected service
    func fetchWorkouts() {
        Task {
            await MainActor.run { 
                self.isLoading = true
                self.errorMessage = nil
            }
            
            do {
                let fetchedWorkouts = try await supabaseService.fetchWorkouts()
                await MainActor.run {
                    self.workouts = fetchedWorkouts
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
    
    func createWorkout(name: String) {
        Task {
            await MainActor.run {
                self.isLoading = true
                self.errorMessage = nil
            }
            
            do {
                // Get the auth session and user
                let session = try await supabaseService.client.auth.session
                // User is now non-optional
                let user = session.user
                
                // Get the user ID as string
                let userId = user.id.uuidString
                
                // Create the new workout
                let newWorkout = Workout(
                    id: UUID().uuidString,
                    userId: userId,
                    title: name,
                    exercises: [],
                    createdAt: Date(),
                    updatedAt: Date(),
                    status: "active"
                )
                
                let createdWorkout = try await supabaseService.createWorkout(newWorkout)
                
                await MainActor.run {
                    self.currentWorkout = createdWorkout
                    self.workouts.append(createdWorkout)
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
}
