// SupabaseServiceProtocol.swift
import Foundation

protocol SupabaseServiceProtocol {
    var client: SupabaseClient { get }
    
    func signUp(email: String, password: String) async throws -> User
    func signIn(email: String, password: String) async throws -> User
    func signOut() async throws
    func fetchWorkouts() async throws -> [Workout]
    func fetchExercises() async throws -> [Exercise]
    // Updated to match new naming
    func fetchSets(for workoutExerciseDetailsId: String) async throws -> [WorkoutSet]
    func createWorkout(_ workout: Workout) async throws -> Workout
    func updateSet(id: String, data: [String: Any]) async throws
    // Add new methods for workout_exercise_details
    func createWorkoutExerciseDetails(workoutId: String, exerciseId: String) async throws -> WorkoutExerciseDetails
}
