//
//  IntelligentHealthCoachApp.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 27/02/2025.
//

import SwiftUI

@main
struct IntelligentHealthCoachApp: App {
    // Create the AuthViewModel at the app level
    @StateObject private var authViewModel = AuthViewModel()
    
    // Connect AppDelegate for UIKit-level configuration
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
