//
//  SupabaseServiceProtocol.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//

import Foundation
import Supabase
import UIKit
import GoogleSignIn

protocol SupabaseServiceProtocol {
    var client: SupabaseClient { get }
    
    func signUp(email: String, password: String) async throws -> User
    func signIn(email: String, password: String) async throws -> User
    func resetPassword(email: String) async throws
    func signOut() async throws
    func updateProfile(userId: String, data: [String: Any]) async throws
    func fetchProfile(userId: String) async throws -> UserProfile?
    func fetchWorkouts() async throws -> [Workout]
    func fetchExercises() async throws -> [Exercise]
    func fetchSets(for workoutExerciseDetailsId: String) async throws -> [WorkoutSet]
    func createWorkout(_ workout: Workout) async throws -> Workout
    func updateSet(id: String, data: [String: Any]) async throws
    func createWorkoutExerciseDetails(workoutId: String, exerciseId: String) async throws -> WorkoutExerciseDetails
    func signInWithGoogle(presenter: UIViewController) async throws -> User
}
