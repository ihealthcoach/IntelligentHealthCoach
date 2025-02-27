//
//  Untitled.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//

// ProfileViewModel.swift
import SwiftUI
import Combine

// ProfileViewModel.swift
class ProfileViewModel: ObservableObject {
    @Published var workoutsCount: Int = 0
    @Published var streakDays: Int = 0
    @Published var achievementsCount: Int = 0
    @Published var toggleStates: [Int: Bool] = [:]
    @Published var userProfile: UserProfile?
    
    private let supabaseService: SupabaseServiceProtocol
    
    // Account, workout, more options referenced in ProfileView
    var accountOptions: [SettingOption] = [
        SettingOption(id: 1, title: "Profile", iconName: "person"),
        SettingOption(id: 2, title: "Questionnaire", iconName: "list.clipboard"),
        SettingOption(id: 3, title: "Password", iconName: "lock"),
        SettingOption(id: 4, title: "Language", iconName: "globe", value: "English"),
        SettingOption(id: 5, title: "Notifications", iconName: "bell"),
        SettingOption(id: 6, title: "Subscription", iconName: "checkmark.seal", value: "Free"),
        SettingOption(id: 7, title: "Payment method", iconName: "creditcard", value: "Credit card"),
        SettingOption(id: 8, title: "Face ID", iconName: "faceid", hasToggle: true)
    ]
    
    var workoutOptions: [SettingOption] = [
        SettingOption(id: 1, title: "Preferred units", iconName: "ruler", value: "Metric/kg"),
        SettingOption(id: 2, title: "Rest timer", iconName: "timer", value: "45 sec"),
        SettingOption(id: 3, title: "Export workout data", iconName: "square.and.arrow.up")
    ]
    
    var moreOptions: [SettingOption] = [
        SettingOption(id: 1, title: "Dark mode", iconName: "moon", hasToggle: true),
        SettingOption(id: 2, title: "Integrations", iconName: "arrow.left.arrow.right"),
        SettingOption(id: 3, title: "Rate & review", iconName: "star"),
        SettingOption(id: 4, title: "Restore purchase", iconName: "arrow.clockwise.circle"),
        SettingOption(id: 5, title: "Help & support", iconName: "questionmark.circle")
    ]
    
    init(supabaseService: SupabaseServiceProtocol = SupabaseService.shared) {
        self.supabaseService = supabaseService
    }
    
    func loadUserProfile() async {
        // Implementation to load profile data from supabaseService
        // Will need to add this method to the SupabaseServiceProtocol
        await MainActor.run {
            // Mock data for now
            self.workoutsCount = 12
            self.streakDays = 5
            self.achievementsCount = 3
        }
    }
    
    func handleSettingTap(_ option: SettingOption) {
        // Implementation to handle setting tap
        if option.hasToggle {
            // Toggle the state
            toggleStates[option.id] = !(toggleStates[option.id] ?? false)
        } else {
            // Handle navigation or action for this option
            print("Tapped option: \(option.title)")
        }
    }
}