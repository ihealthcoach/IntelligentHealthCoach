//
//  CacheManager.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 27/02/2025.
//

import Foundation
import Kingfisher

/// A manager class responsible for caching application data
class CacheManager {
    static let shared = CacheManager()
    
    // Use NSCache for memory caching
    private let imageCache = NSCache<NSString, NSData>()
    private let dataCache = NSCache<NSString, NSData>()
    
    private var isConfigured = false
    
    private init() {
        // Set default cache limits
        imageCache.countLimit = 100
        dataCache.countLimit = 100
    }
    
    func configure() {
        // Avoid reconfiguring if already done
        guard !isConfigured else { return }
        
        // Configure Kingfisher (already used in the project for image caching)
        let kingfisherConfig = KingfisherManager.shared.downloader.sessionConfiguration
        kingfisherConfig.requestCachePolicy = .returnCacheDataElseLoad
        
        // Clear expired cache on app start
        // Update to correct method
        ImageCache.default.clearMemoryCache()
        
        print("CacheManager configured successfully")
        
        // Set flag to prevent reconfiguration
        isConfigured = true
    }
    
    // MARK: - API for storing and retrieving cached items
    
    func cacheData(_ data: Data, forKey key: String) {
        dataCache.setObject(data as NSData, forKey: key as NSString)
    }
    
    func getData(forKey key: String) -> Data? {
        return dataCache.object(forKey: key as NSString) as Data?
    }
    
    func clearCache() {
        print("Clearing all app caches...")
        
        // Clear memory caches
        imageCache.removeAllObjects()
        dataCache.removeAllObjects()
        
        // Clear Kingfisher caches
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache {
            print("Kingfisher disk cache cleared")
        }
        
        // Clear any other caches if needed
        UserDefaults.standard.removeObject(forKey: "cached_workout_exercises")
        
        print("Cache clearing initiated")
    }
}
