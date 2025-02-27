//
//  WorkoutViewModel.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// WorkoutViewModel.swift
import SwiftUI
import Combine

class WorkoutViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var currentWorkout: Workout?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let supabaseService = SupabaseService.shared
    
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
    
    func createNewWorkout() {
        Task {
            await MainActor.run { 
                self.isLoading = true
                self.errorMessage = nil
            }
            
            do {
                guard let userId = supabaseService.client.auth.session?.user?.id else {
                    throw AuthError.sessionExpired
                }
                
                let newWorkout = Workout(
                    id: UUID().uuidString,
                    userId: userId,
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