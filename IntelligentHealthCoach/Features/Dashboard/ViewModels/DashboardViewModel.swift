//
//  TodayGoal.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// DashboardViewModel.swift
import SwiftUI
import Combine

// DashboardViewModel.swift
class DashboardViewModel: ObservableObject {
    @Published var greeting: String = "Good morning"
    @Published var goals: [String] = ["Muscle building", "3 meals", "12 weeks", "Vegan"]
    @Published var progressMessage: String = "Great start of the day, a little more to reach today's goals"
    @Published var todayGoals: [TodayGoal] = []
    @Published var activities: [Activity] = []
    @Published var hasNotifications: Bool = false
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let supabaseService: SupabaseServiceProtocol
    
    init(supabaseService: SupabaseServiceProtocol = SupabaseService.shared) {
        self.supabaseService = supabaseService
        setupGreeting()
        setupMockData()
        
        // Set up timer to refresh greeting based on time of day
        Timer.publish(every: 3600, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.setupGreeting()
            }
            .store(in: &cancellables)
    }
    
    private func setupGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 0..<12:
            greeting = "Good morning"
        case 12..<17:
            greeting = "Good afternoon"
        default:
            greeting = "Good evening"
        }
    }
    
    private func setupMockData() {
        // Mock today's goals
        todayGoals = [
            TodayGoal(
                title: "Calories",
                currentValue: "1,500",
                targetValue: "2,500",
                unit: "kcal",
                icon: "flame.fill",
                color: .orange.opacity(0.2)
            ),
            TodayGoal(
                title: "Active time",
                currentValue: "60",
                targetValue: "120",
                unit: "min",
                icon: "clock.fill",
                color: .green.opacity(0.2)
            ),
            TodayGoal(
                title: "Steps",
                currentValue: "3,500",
                targetValue: "10,000",
                unit: "steps",
                icon: "figure.walk",
                color: .blue.opacity(0.2)
            ),
            TodayGoal(
                title: "Distance",
                currentValue: "9.4",
                targetValue: "10.00",
                unit: "km",
                icon: "mappin",
                color: .purple.opacity(0.2)
            )
        ]
        
        // Mock activities
        activities = [
            Activity(
                type: "Running",
                stats: [
                    ("40 min 17 sec", "clock"),
                    ("140 kcal", "flame.fill"),
                    ("4.2 km", "mappin")
                ],
                timestamp: Date().addingTimeInterval(-3600)
            ),
            Activity(
                type: "Gym",
                stats: [
                    ("1 hour 15 min", "clock"),
                    ("812 kcal", "flame.fill"),
                    ("8 exercises", "dumbbell.fill")
                ],
                timestamp: Date().addingTimeInterval(-7200)
            )
        ]
    }
    
    // In a real app, you would fetch data from your SupabaseService here
    func loadData() {
        isLoading = true
        
        // Simulate network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.isLoading = false
        }
    }
    
    func refreshData() async {
        // Simulate network request
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // In a real app, you would fetch fresh data from your API
        await MainActor.run {
            // Potentially update data based on API response
            self.updateProgressMessage()
        }
    }
    
    private func updateProgressMessage() {
        let totalGoals = todayGoals.count
        let achievedGoals = todayGoals.filter { $0.progress >= 1.0 }.count
        
        if achievedGoals == 0 {
            progressMessage = "Start your day by working towards your goals"
        } else if achievedGoals < totalGoals / 2 {
            progressMessage = "Great start of the day, a little more to reach today's goals"
        } else if achievedGoals < totalGoals {
            progressMessage = "Almost there! Just a few more goals to complete"
        } else {
            progressMessage = "Amazing! You've completed all your goals for today"
        }
    }
}