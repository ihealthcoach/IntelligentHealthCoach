//
//  SupabaseService.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// IntelligentHealthCoach/Core/Services/SupabaseService.swift
import Foundation
import Supabase
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
        guard let authUser = response.user else {
            throw AuthError.signUpFailed
        }
        return User(from: authUser)
    }
    
    func signIn(email: String, password: String) async throws -> User {
        let response = try await client.auth.signIn(
            email: email,
            password: password
        )
        guard let authUser = response.user else {
            throw AuthError.signInFailed
        }
        return User(from: authUser)
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
    }
    
    // MARK: - Data operations
    
    func fetchWorkouts() async throws -> [Workout] {
        let response = try await client
            .from("workouts")
            .select()
            .order("created", ascending: false)
            .execute()
        
        return try decodeResponse(response)
    }
    
    func fetchExercises() async throws -> [Exercise] {
        let response = try await client
            .from("exercises")
            .select()
            .execute()
        
        return try decodeResponse(response)
    }
    
    func fetchSets(for workoutExerciseDetailsId: String) async throws -> [WorkoutSet] {
        let response = try await client
            .from("workout_sets")
            .select()
            .eq("workout_exercise_details_id", value: workoutExerciseDetailsId)
            .order("created_at", ascending: true)
            .execute()
        
        return try decodeResponse(response)
    }
    
    func createWorkout(_ workout: Workout) async throws -> Workout {
        // Create dictionary for insertion, using the correct field names
        var workoutDict: [String: Any] = [
            "id": workout.id,
            "user_id": workout.userId,
            "status": workout.status,
            // Using 'created' and 'modified' instead of 'created_at' and 'updated_at'
            "created": ISO8601DateFormatter().string(from: workout.createdAt),
            "modified": ISO8601DateFormatter().string(from: workout.updatedAt)
        ]
        
        if let title = workout.title {
            workoutDict["title"] = title
        }
        
        let response = try await client
            .from("workouts")
            .insert(workoutDict)
            .single()
            .execute()
        
        return try decodeResponse(response)
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
        
        return try decodeResponse(response)
    }
    
    func updateSet(id: String, data: [String: Any]) async throws {
        let _ = try await client
            .from("workout_sets")
            .update(data)
            .eq("id", value: id)
            .execute()
    }
    
    // MARK: - Helper methods
    
    private func decodeResponse<T: Decodable>(_ response: PostgrestResponse) throws -> T {
        // Use different decoders based on the type
        if T.self == [Workout].self || T.self == Workout.self {
            return try JSONDecoder.workoutsDecoder().decode(T.self, from: response.data)
        } else {
            return try JSONDecoder.supabaseDecoder().decode(T.self, from: response.data)
        }
    }
}
