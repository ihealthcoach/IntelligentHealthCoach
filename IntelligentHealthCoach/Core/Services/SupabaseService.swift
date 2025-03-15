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
    
    // Make this a regular stored property
    private(set) var client: SupabaseClient
    
    private init() {
        // Get these values from Info.plist which pulls from .xcconfig
        guard let supabaseURL = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String,
              let supabaseKey = Bundle.main.infoDictionary?["SUPABASE_ANON_KEY"] as? String,
              let url = URL(string: supabaseURL) else {
            // For safety, provide a sensible error message but don't crash in preview mode
            print("⚠️ ERROR: Supabase URL or key not properly configured in Info.plist")
            
            // Create a placeholder client with a dummy URL to prevent crashes
            let fallbackURL = URL(string: "https://placeholder.supabase.co")!
            self.client = SupabaseClient(
                supabaseURL: fallbackURL,
                supabaseKey: "placeholder_key"
            )
            return
        }
        
        // Initialize Supabase client
        self.client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: supabaseKey
        )
        
        print("✅ Supabase client initialized with URL: \(url)")
    }
    
    // MARK: - Authentication
    
    func signUp(email: String, password: String) async throws -> User {
        let response = try await client.auth.signUp(
            email: email,
            password: password
        )
        
        // User is now non-optional
        let authUser = response.user
        
        return User(
            id: authUser.id,
            email: authUser.email,
            firstName: nil,
            lastName: nil,
            avatarUrl: nil
        )
    }
    
    func signIn(email: String, password: String) async throws -> User {
        let response = try await client.auth.signIn(
            email: email,
            password: password
        )
        
        // User is now non-optional
        let authUser = response.user
        
        return User(
            id: authUser.id,
            email: authUser.email,
            firstName: nil,
            lastName: nil,
            avatarUrl: nil
        )
    }
    
    func resetPassword(email: String) async throws {
        try await client.auth.resetPasswordForEmail(email)
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
    }
    
    // MARK: - Profile Management
    
    func updateProfile(userId: String, data: [String: Any]) async throws {
        let updateData = ProfileUpdateData(data: data)
        let _ = try await client
            .from("profiles")
            .update(updateData)
            .eq("user_id", value: userId)
            .execute()
    }
    
    func fetchProfile(userId: String) async throws -> UserProfile? {
        let response = try await client
            .from("profiles")
            .select()
            .eq("user_id", value: userId)
            .single()
            .execute()
        
        let profileData = response.data
        return try JSONDecoder.supabaseDecoder().decode(UserProfile.self, from: profileData)
    }
    
    // MARK: - Data operations
    
    func fetchWorkouts() async throws -> [Workout] {
        let response = try await client
            .from("workouts")
            .select()
            .order("created", ascending: false)
            .execute()
        
        let decoder = JSONDecoder.workoutsDecoder()
        return try decoder.decode([Workout].self, from: response.data)
    }
    
    func fetchExercises() async throws -> [Exercise] {
        let response = try await client
            .from("exercises")
            .select()
            .execute()
        
        let decoder = JSONDecoder.supabaseDecoder()
        return try decoder.decode([Exercise].self, from: response.data)
    }
    
    func fetchSets(for workoutExerciseDetailsId: String) async throws -> [WorkoutSet] {
        let response = try await client
            .from("workout_sets")
            .select()
            .eq("workout_exercise_details_id", value: workoutExerciseDetailsId)
            .order("created_at", ascending: true)
            .execute()
        
        let decoder = JSONDecoder.supabaseDecoder()
        return try decoder.decode([WorkoutSet].self, from: response.data)
    }
    
    func createWorkout(_ workout: Workout) async throws -> Workout {
        // Create dictionary for insertion, using the correct field names
        var workoutDict: [String: String] = [
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
        
        let decoder = JSONDecoder.workoutsDecoder()
        return try decoder.decode(Workout.self, from: response.data)
    }
    
    func createWorkoutExerciseDetails(workoutId: String, exerciseId: String) async throws -> WorkoutExerciseDetails {
        let data: [String: String] = [
            "workout_id": workoutId,
            "exercise_id": exerciseId
        ]
        
        let response = try await client
            .from("workout_exercise_details")
            .insert(data)
            .single()
            .execute()
        
        let decoder = JSONDecoder.supabaseDecoder()
        return try decoder.decode(WorkoutExerciseDetails.self, from: response.data)
    }
    
    func updateSet(id: String, data: [String: Any]) async throws {
        let updateData = WorkoutSetUpdateData(data: data)
        let _ = try await client
            .from("workout_sets")
            .update(updateData)
            .eq("id", value: id)
            .execute()
    }
    
    // Data structures for updates
    struct ProfileUpdateData: Encodable {
        var firstName: String?
        var lastName: String?
        var avatarUrl: String?
        // Add more fields as needed
        
        init(data: [String: Any]) {
            self.firstName = data["first_name"] as? String
            self.lastName = data["last_name"] as? String
            self.avatarUrl = data["avatar_url"] as? String
            // Initialize other fields as needed
        }
    }
    
    struct WorkoutSetUpdateData: Encodable {
        var weight: Double?
        var reps: Int?
        var completed: Bool?
        
        init(data: [String: Any]) {
            self.weight = data["weight"] as? Double
            self.reps = data["reps"] as? Int
            self.completed = data["completed"] as? Bool
        }
    }
}
