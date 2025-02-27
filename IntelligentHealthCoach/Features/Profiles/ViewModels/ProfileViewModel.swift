//
//  Untitled.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//

// ProfileViewModel.swift
import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    @Published var workoutsCount: Int = 0
    @Published var streakDays: Int = 0
    @Published var achievementsCount: Int = 0
    @Published var toggleStates: [Int: Bool] = [:]
    
    // Account, workout, more options referenced in ProfileView
    var accountOptions: [SettingOption] = [
        SettingOption(id: 1, title: "Profile", iconName: "person"),
        SettingOption(id: 2, title: "Questionnaire", iconName: "list.clipboard"),
        // Add remaining options from ProfileView
    ]
    
    var workoutOptions: [SettingOption] = [
        // Copy from ProfileView
    ]
    
    var moreOptions: [SettingOption] = [
        // Copy from ProfileView
    ]
    
    func loadUserProfile() async {
        // Implementation to load profile data
    }
    
    func handleSettingTap(_ option: SettingOption) {
        // Implementation to handle setting tap
    }
}