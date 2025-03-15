//
//  SupabaseManager.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 27/02/2025.
//

/*
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
        guard let supabaseURLString = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String,
              let supabaseKey = Bundle.main.infoDictionary?["SUPABASE_ANON_KEY"] as? String,
              !supabaseURLString.isEmpty, !supabaseKey.isEmpty else {
            print("⚠️ WARNING: Supabase URL or key not found in Info.plist. Check your .xcconfig file.")
            return
        }
        
        // Safely create URL
        guard let url = URL(string: supabaseURLString) else {
            print("⚠️ WARNING: Invalid Supabase URL format: \(supabaseURLString)")
            return
        }
        
        // Create the actual client using the Supabase SDK
        self.client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: supabaseKey
        )
        
        configureClient()
        
        print("SupabaseManager initialized successfully with URL: \(supabaseURLString)")
        
        // Set flag to prevent reinitialization
        isInitialized = true
    }
    
    /// Configure additional client options, if needed
    private func configureClient() {
        // Add any global client configuration here
    }
    
    /// Reset the client (for testing or when changing environments)
    func resetClient() {
        initializationLock.lock()
        defer { initializationLock.unlock() }
        
        client = nil as SupabaseClient?  // Add explicit type
        isInitialized = false
    }
    
    /// Ensure the client is initialized before use
    private func ensureInitialized() {
        guard isInitialized else {
            fatalError("SupabaseManager not initialized. Call initialize() from AppDelegate first.")
        }
    }
}
*/

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
    private(set) var client: SupabaseClient?
    
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
        guard let supabaseURLString = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String,
              let supabaseKey = Bundle.main.infoDictionary?["SUPABASE_ANON_KEY"] as? String,
              !supabaseURLString.isEmpty, !supabaseKey.isEmpty else {
            print("⚠️ WARNING: Supabase URL or key not found in Info.plist. Check your .xcconfig file.")
            return
        }
        
        // Safely create URL
        guard let url = URL(string: supabaseURLString) else {
            print("⚠️ WARNING: Invalid Supabase URL format: \(supabaseURLString)")
            return
        }
        
        // Create the actual client using the Supabase SDK
        self.client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: supabaseKey
        )
        
        configureClient()
        
        print("SupabaseManager initialized successfully with URL: \(supabaseURLString)")
        
        // Set flag to prevent reinitialization
        isInitialized = true
    }
    
    /// Configure additional client options, if needed
    private func configureClient() {
        // Add any global client configuration here
    }
    
    /// Reset the client (for testing or when changing environments)
    func resetClient() {
        initializationLock.lock()
        defer { initializationLock.unlock() }
        
        client = nil
        isInitialized = false
    }
    
    /// Get the initialized client or throw an error if not available
    func getClient() -> SupabaseClient {
        guard let client = client, isInitialized else {
            // In a real app, you'd throw an error here
            // For now, create a default client to prevent crashes during testing
            print("⚠️ WARNING: Attempting to use Supabase client before initialization")
            
            // Create a mock client with default values for preview mode
            let defaultURL = URL(string: "https://example.supabase.co")!
            let defaultKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.PREVIEW_MODE.PREVIEW_MODE"
            
            return SupabaseClient(
                supabaseURL: defaultURL,
                supabaseKey: defaultKey
            )
        }
        
        return client
    }
}
