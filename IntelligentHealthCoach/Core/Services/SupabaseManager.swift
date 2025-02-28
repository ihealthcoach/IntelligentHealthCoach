//
//  SupabaseManager.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 27/02/2025.
//

import Foundation
import Supabase
import Auth
import PostgREST
import Realtime
import Storage
import Functions

/// A singleton manager class responsible for Supabase initialization and operations
class SupabaseManager {
    static let shared = SupabaseManager()
    
    // The actual Supabase client from the SDK
    private(set) var client: SupabaseClient!
    
    // Ensure thread-safe initialization
    private let initializationLock = NSLock()
    private var isInitialized = false
    
    private init() {
        // Initialize is explicitly called from AppDelegate
    }
    
    /// Initialize the Supabase client with configuration
    func initialize() {
        initializationLock.lock()
        defer { initializationLock.unlock() }
        
        // Avoid reinitializing if already done
        guard !isInitialized else { return }
        
        // Get configuration from Info.plist (which pulls from .xcconfig)
        guard let supabaseURL = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String,
              let supabaseKey = Bundle.main.infoDictionary?["SUPABASE_ANON_KEY"] as? String,
              let url = URL(string: supabaseURL) else {
            fatalError("Supabase URL or key not found in Info.plist. Check your .xcconfig file.")
        }
        
        // Create the actual client using the Supabase SDK
        self.client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: supabaseKey
        )
        
        configureClient()
        
        print("SupabaseManager initialized successfully with URL: \(supabaseURL)")
        
        // Set flag to prevent reinitialization
        isInitialized = true
    }
    
    /// Configure additional client options, if needed
    private func configureClient() {
        // Add any global client configuration here
        // For example, custom headers, request timeouts, etc.
    }
    
    /// Reset the client (for testing or when changing environments)
    func resetClient() {
        initializationLock.lock()
        defer { initializationLock.unlock() }
        
        client = nil
        isInitialized = false
    }
    
    // MARK: - Convenience Methods
    
    /// Get the auth module
    var auth: SupabaseAuth {
        ensureInitialized()
        return client.auth
    }
    
    /// Create a query for a specific table
    func from(_ table: String) -> SupabaseQuery {
        ensureInitialized()
        return client.from(table)
    }
    
    /// Get the storage module
    var storage: SupabaseStorage {
        ensureInitialized()
        return client.storage
    }
    
    /// Get the functions module
    var functions: SupabaseFunctions {
        ensureInitialized()
        return client.functions
    }
    
    /// Make a custom request to Supabase
    func makeRequest(_ endpoint: String, method: String, body: Data? = nil) async throws -> (Data, URLResponse) {
        ensureInitialized()
        return try await client.makeRequest(endpoint, method: method, body: body)
    }
    
    /// Ensure the client is initialized before use
    private func ensureInitialized() {
        guard isInitialized else {
            fatalError("SupabaseManager not initialized. Call initialize() from AppDelegate first.")
        }
    }
}

// MARK: - Protocol Conformance
extension SupabaseManager: SupabaseServiceProtocol {
    var client: SupabaseClient {
        ensureInitialized()
        return client
    }
    
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
}
