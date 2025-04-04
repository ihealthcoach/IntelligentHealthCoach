//
//  AppDelegate.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//

import UIKit
import SwiftUI
import Kingfisher
import GoogleSignIn
import Supabase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Debug output for Supabase configuration
        if let supabaseURL = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String {
            print("Found SUPABASE_URL in Info.plist: \(supabaseURL)")
        } else {
            print("WARNING: SUPABASE_URL not found in Info.plist")
        }
        
        if let supabaseKey = Bundle.main.infoDictionary?["SUPABASE_ANON_KEY"] as? String {
            print("Found SUPABASE_ANON_KEY in Info.plist (first few chars): \(String(supabaseKey.prefix(10)))...")
        } else {
            print("WARNING: SUPABASE_ANON_KEY not found in Info.plist")
        }
        
        // Initialize services first
        setupServices()
        
        // Then configure appearance
        configureAppearance()
        
        return true
    }

    private func checkAndClearCacheIfNeeded() {
        // Get current app version
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        
        // Get last stored version
        let lastVersion = UserDefaults.standard.string(forKey: "lastAppVersion") ?? ""
        
        // If versions don't match, clear cache
        if currentVersion != lastVersion {
            print("App version changed from \(lastVersion) to \(currentVersion). Clearing caches...")
            CacheManager.shared.clearCache()
            
            // Store current version
            UserDefaults.standard.set(currentVersion, forKey: "lastAppVersion")
        }
    }
    
    private func configureAppearance() {
        // Register and override system fonts with Inter
        UIFont.registerInterFonts()
        UIFont.overrideSystemFont()
        
        // Configure global app appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color("offwhite"))
        appearance.titleTextAttributes = [.foregroundColor: UIColor(Color("gray900"))]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color("gray900"))]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        KingfisherManager.shared.downloader.downloadTimeout = 15.0 // 15 seconds timeout
        ImageCache.default.diskStorage.config.expiration = .days(7) // Cache images for 7 days
        
        // Tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(Color("offwhite"))
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    private func setupServices() {
        // Initialize any required background services
        
        // Initialize Supabase in a safer way
        _ = SupabaseService.shared
        
        // Configure cache manager
        CacheManager.shared.configure()
        
        print("Services initialized successfully")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
