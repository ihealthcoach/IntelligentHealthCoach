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
