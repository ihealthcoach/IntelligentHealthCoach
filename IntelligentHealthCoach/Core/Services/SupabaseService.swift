//
//  SupabaseService.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//

import Foundation
import Supabase
import Auth
import PostgREST
import Realtime
import Storage
import Functions
import UIKit
import GoogleSignIn

class SupabaseService: SupabaseServiceProtocol {
    static let shared = SupabaseService()
    
    // Make this a regular stored property
    private(set) var client: SupabaseClient

    private struct NewProfileData: Encodable {
        let user_id: String
        let first_name: String
        let last_name: String
        let avatar_url: String
        let created_at: String
    }
    
    private init() {
        print("🔍 Beginning Supabase initialization...")
        
        // Create a proper URL with explicit components rather than parsing from a string
        
        // Get base values
        let rawURL = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String ?? ""
        let rawKey = Bundle.main.infoDictionary?["SUPABASE_ANON_KEY"] as? String ?? ""
        
        print("📋 Raw SUPABASE_URL from Info.plist: \(rawURL)")
        print("📋 Raw SUPABASE_ANON_KEY from Info.plist: \(rawKey.prefix(10))...")
        
        // Create fallback client for preview/development
        let fallbackURL = URL(string: "https://fleiivpyjkvahakriuta.supabase.co")!
        let fallbackClient = SupabaseClient(
            supabaseURL: fallbackURL,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZsZWlpdnB5amt2YWhha3JpdXRhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDEwODAzNzUsImV4cCI6MjAxNjY1NjM3NX0.lUbyfDlEANGoONW3mmtO-1JDvCsa1uy7EKKTs9yLYwE"
        )
        
        // Create URL components programmatically to ensure proper structure
        var components = URLComponents()
        components.scheme = "https"
        
        // Extract the host without the protocol
        var hostString = rawURL
        if hostString.hasPrefix("https://") {
            hostString = String(hostString.dropFirst(8))
        } else if hostString.hasPrefix("http://") {
            hostString = String(hostString.dropFirst(7))
        }
        
        // Remove any trailing slashes
        while hostString.hasSuffix("/") {
            hostString = String(hostString.dropLast())
        }
        
        // Check if host string is empty
        if hostString.isEmpty {
            print("❌ SUPABASE_URL host is empty after processing")
            self.client = fallbackClient
            return
        }
        
        components.host = hostString
        
        // Ensure we have a valid URL with a host
        guard let url = components.url else {
            print("❌ Could not create URL from components with host: \(hostString)")
            self.client = fallbackClient
            return
        }
        
        // Validate API key
        guard !rawKey.isEmpty else {
            print("❌ SUPABASE_ANON_KEY is missing or empty")
            self.client = fallbackClient
            return
        }
        
        print("✅ Validation successful, creating real Supabase client with URL: \(url.absoluteString)")
        
        // Initialize Supabase client with validated URL
        self.client = SupabaseClient(
            supabaseURL: URL(string: "https://fleiivpyjkvahakriuta.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZsZWlpdnB5amt2YWhha3JpdXRhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDEwODAzNzUsImV4cCI6MjAxNjY1NjM3NX0.lUbyfDlEANGoONW3mmtO-1JDvCsa1uy7EKKTs9yLYwE"
        )
        
        print("✅ Supabase client initialized successfully")
    }
    
    func getStorageUrl(path: String) -> URL? {
        print("DEBUG: getStorageUrl called with path: \(path)")
        
        if path.starts(with: "https://") {
            print("DEBUG: URL is already complete: \(path)")
            return URL(string: path)
        } else {
            // Construct the full URL using base storage URL
            let fullUrl = AppConstants.API.storageBaseUrl + path
            print("DEBUG: Constructed URL: \(fullUrl)")
            return URL(string: fullUrl)
        }
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
    
    func signInWithGoogle(presenter: UIViewController) async throws -> User {
        let controller = GoogleSignInController(supabaseService: self)
        
        // These UIKit methods are not async, so no await needed
        presenter.addChild(controller)
        presenter.view.addSubview(controller.view)
        controller.view.frame = presenter.view.bounds // Set frame to cover parent view
        controller.view.backgroundColor = .clear // Make it transparent
        controller.didMove(toParent: presenter)
        
        do {
            // This needs await because googleSignIn is async
            let user = try await controller.googleSignIn()
            
            // These UIKit methods are not async, so no await needed
            controller.willMove(toParent: nil)
            controller.view.removeFromSuperview()
            controller.removeFromParent()
            
            // Try to update profile with Google data if not already set
            if let firstName = user.firstName, let lastName = user.lastName {
                Task {
                    do {
                        try await ensureProfileExists(
                            userId: user.id.uuidString,
                            firstName: user.firstName,
                            lastName: user.lastName,
                            avatarUrl: user.avatarUrl
                        )
                    } catch {
                        print("Could not create/update profile after Google login: \(error)")
                    }
                }
            }
            
            return user
        } catch {
            // Clean up UI elements on error
            controller.willMove(toParent: nil)
            controller.view.removeFromSuperview()
            controller.removeFromParent()
            
            // Re-throw the error
            throw error
        }
    }
    
    private func ensureProfileExists(userId: String, firstName: String?, lastName: String?, avatarUrl: String?) async throws {
        // Check if profile exists
        do {
            // Try to get the profile - if it doesn't exist, this will throw an error
            let response = try await client
                .from("profiles")
                .select()
                .eq("user_id", value: userId)
                .single()
                .execute()
            
            // If we get here, the profile exists
            print("✅ Profile already exists for Google user")
            
            // Optionally update the profile with latest Google data
            try await updateProfileIfNeeded(userId: userId, firstName: firstName, lastName: lastName, avatarUrl: avatarUrl)
            
        } catch {
            // Profile doesn't exist, so create it
            // Use a properly encodable struct rather than a dictionary
            let profileData = NewProfileData(
                user_id: userId,
                first_name: firstName ?? "",
                last_name: lastName ?? "",
                avatar_url: avatarUrl ?? "",
                created_at: ISO8601DateFormatter().string(from: Date())
            )
            
            let _ = try await client
                .from("profiles")
                .insert(profileData)
                .execute()
            
            print("✅ Created new profile for Google user")
        }
    }
    
    private func updateProfileIfNeeded(userId: String, firstName: String?, lastName: String?, avatarUrl: String?) async throws {
        // Only update if we have actual data to update
        if firstName != nil || lastName != nil || avatarUrl != nil {
            var updateData: [String: Any] = [:]
            
            if let firstName = firstName, !firstName.isEmpty {
                updateData["first_name"] = firstName
            }
            
            if let lastName = lastName, !lastName.isEmpty {
                updateData["last_name"] = lastName
            }
            
            if let avatarUrl = avatarUrl, !avatarUrl.isEmpty {
                updateData["avatar_url"] = avatarUrl
            }
            
            // Only proceed with update if we have data to update
            if !updateData.isEmpty {
                try await updateProfile(userId: userId, data: updateData)
            }
        }
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
        print("📊 Attempting Supabase query on 'exercises' table...")
        
        let response = try await client
            .from("exercises")
            .select()
            .execute()
        
        print("📊 Raw response data: \(String(data: response.data, encoding: .utf8) ?? "Unable to decode")")
        
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
