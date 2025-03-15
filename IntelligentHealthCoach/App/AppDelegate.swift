//
//  AppDelegate.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


import SwiftUI
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Initialize services and configure app
        configureAppearance()
        setupServices()
        
        return true
    }
    
    private func configureAppearance() {
        // Configure global app appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.white)
        appearance.titleTextAttributes = [.foregroundColor: UIColor(Color.black)]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color.black)]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        // Tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(Color.white)
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    private func setupServices() {
        // Initialize any required background services
        
        // Initialize Supabase in a safer way
        SupabaseManager.shared.initialize()
        
        // Configure cache manager
        CacheManager.shared.configure()
        
        print("Services initialized successfully")
    }
}
