//
//  SupabaseManager.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 27/02/2025.
//

import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()
    
    private(set) var client: SupabaseClient
    private var isInitialized = false
    
    private init() {
        // Initialize with default values, will be properly set during initialize()
        self.client = SupabaseClient(
            supabaseURL: URL(string: "https://example.com")!,
            supabaseKey: "placeholder"
        )
    }
    
    func initialize() {
        // Avoid reinitializing if already done
        guard !isInitialized else { return }
        
        // Get configuration from Info.plist
        guard let supabaseURL = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String,
              let supabaseKey = Bundle.main.infoDictionary?["SUPABASE_ANON_KEY"] as? String else {
            fatalError("Supabase URL or key not found in Info.plist")
        }
        
        // Create the actual client
        self.client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: supabaseKey
        )
        
        print("SupabaseManager initialized successfully")
        
        // Set flag to prevent reinitialization
        isInitialized = true
    }
}
