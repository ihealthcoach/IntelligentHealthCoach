//
//  AppConstants.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 27/03/2025.
//

import Foundation

enum AppConstants {
    enum API {
        static let supabaseBaseUrl = "https://fleiivpyjkvahakriuta.supabase.co"
        static let storageBaseUrl = "\(supabaseBaseUrl)/storage/v1/object/public/"
        static let exerciseGifsPath = "\(storageBaseUrl)exercises/gifs/"
    }
}
