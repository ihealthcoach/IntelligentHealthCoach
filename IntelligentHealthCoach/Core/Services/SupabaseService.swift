//
//  SupabaseService.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// SupabaseService.swift
import Foundation
import Auth
import PostgREST
import Realtime
import Storage
import Functions

class SupabaseService: SupabaseServiceProtocol {
    static let shared = SupabaseService()
    
    private let supabaseURL: String
    private let supabaseKey: String
    private(set) var client: SupabaseClient
    
    private init() {
        // Get these values from your environment or configuration
        guard let supabaseURL = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String,
              let supabaseKey = Bundle.main.infoDictionary?["SUPABASE_ANON_KEY"] as? String else {
            fatalError("Supabase URL or key not found")
        }
        
        self.supabaseURL = supabaseURL
        self.supabaseKey = supabaseKey
        
        // Initialize Supabase client
        self.client = SupabaseClient(
            supabaseURL: URL(string: supabaseURL)!,
            supabaseKey: supabaseKey
        )
    }
    
    // MARK: - Authentication
    
    func signUp(email: String, password: String) async throws -> User {
        let response = try await client.auth.signUp(
            email: email,
            password: password
        )
        guard let user = response.user else {
            throw AuthError.signUpFailed
        }
        return User(from: user)
    }
    
    func signIn(email: String, password: String) async throws -> User {
        let response = try await client.auth.signIn(
            email: email,
            password: password
        )
        guard let user = response.user else {
            throw AuthError.signInFailed
        }
        return User(from: user)
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
    }
    
    // MARK: - Data operations
    
    func fetchWorkouts() async throws -> [Workout] {
        let response = try await client
            .from("workouts")
            .select()
            .execute()
        
        return try response.decoded(to: [Workout].self)
    }
    
    func fetchExercises() async throws -> [Exercise] {
        let response = try await client
            .from("exercises")
            .select()
            .execute()
        
        return try response.decoded(to: [Exercise].self)
    }
    
    func fetchSets(for workoutExerciseDetailsId: String) async throws -> [WorkoutSet] {
        let response = try await client
            .from("sets")
            .select()
            .eq("workout_exercise_details_id", value: workoutExerciseDetailsId)
            .order("created_at", ascending: true)
            .execute()
        
        return try response.decoded(to: [WorkoutSet].self)
    }
    
    func createWorkoutExerciseDetails(workoutId: String, exerciseId: String) async throws -> WorkoutExerciseDetails {
        let data = [
            "workout_id": workoutId,
            "exercise_id": exerciseId
        ]
        
        let response = try await client
            .from("workout_exercise_details")
            .insert(data)
            .single()
            .execute()
        
        return try response.decoded(to: WorkoutExerciseDetails.self)
    }
    
    func updateSet(id: String, data: [String: Any]) async throws {
        // Capture the result in a variable with underscore to indicate it's intentionally unused
        let _ = try await client
            .from("sets")
            .update(data)
            .eq("id", value: id)
            .execute()
    }
}

// Error definitions
enum AuthError: Error {
    case signUpFailed
    case signInFailed
    case signOutFailed
    case sessionExpired
}
