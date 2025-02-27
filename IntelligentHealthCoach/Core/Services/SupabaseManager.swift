//
//  SupabaseManager.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 27/02/2025.
//

import Foundation
import Supabase

/// A manager class responsible for Supabase initialization and global configuration
class SupabaseManager {
    static let shared = SupabaseManager()
    
    private var isInitialized = false
    
    private init() {}
    
    func initialize() {
        // Avoid reinitializing if already done
        guard !isInitialized else { return }
        
        // Configure any global Supabase settings here
        // For example, setting up logging or additional configurations
        
        print("SupabaseManager initialized successfully")
        
        // Set flag to prevent reinitialization
        isInitialized = true
    }
    
    // Add any global Supabase management functions here
    // This class would handle app-wide Supabase concerns while
    // delegating specific operations to SupabaseService
}
