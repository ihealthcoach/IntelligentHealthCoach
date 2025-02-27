//
//  DashboardView.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// DashboardView.swift
import SwiftUI
import Kingfisher

struct DashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var workoutViewModel = WorkoutViewModel()
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            homeView
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            workoutsView
                .tabItem {
                    Label("Workouts", systemImage: "dumbbell.fill")
                }
                .tag(1)
            
            Text("Nutrition")
                .tabItem {
                    Label("Nutrition", systemImage: "fork.knife")
                }
                .tag(2)
            
            profileView
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(3)
        }
        .onAppear {
            workoutViewModel.fetchWorkouts()
        }
    }
    
    var homeView: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Good Morning")
                                .font(.system(size: 24, weight: .light))
                            
                            Text(authViewModel.currentUser?.firstName ?? "User")
                                .font(.system(size: 24, weight: .bold))
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 15) {
                            Button(action: {}) {
                                Image(systemName: "bell")
                                    .font(.system(size: 20))
                            }
                            
                            Button(action: {}) {
                                Image(systemName: "message")
                                    .font(.system(size: 20))
                            }
                            
                            Button(action: {
                                selectedTab = 3 // Switch to profile tab
                            }) {
                                Image("avatar")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Goal badges
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            Badge(text: "Muscle building", hasBorder: true)
                            Badge(text: "3 meals", hasBorder: true)
                            Badge(text: "12 weeks", hasBorder: true)
                            Badge(text: "Vegan", hasBorder: true)
                        }
                        .padding(.horizontal)
                    }
                    
                    Text("Great start of the day, a little more to reach today's goals")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    // Today's goals
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Today's goals")
                                .font(.system(size: 18, weight: .semibold))
                            
                            Image(systemName: "chevron.down")
                                .font(.system(size: 14))
                            
                            Spacer()
                            
                            Text("Edit goals")
                                .font(.system(size: 16, weight: .medium))
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 14))
                        }
                        
                        // Goal cards grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            goalCard(title: "Calories", value: "1,500", unit: "kcal", goal: "2,500", icon: "flame.fill", color: .orange.opacity(0.2))
                            goalCard(title: "Active time", value: "60", unit: "min", goal: "120", icon: "clock.fill", color: .green.opacity(0.2))
                            goalCard(title: "Steps", value: "3,500", unit: "steps", goal: "10,000", icon: "figure.walk", color: .blue.opacity(0.2))
                            goalCard(title: "Distance", value: "9.4", unit: "km", goal: "10.00", icon: "mappin", color: .purple.opacity(0.2))
                        }
                        .padding(.horizontal)
                    }
                    .padding(.horizontal)
                    
                    // Start workout button
                    Button(action: {
                        selectedTab = 1 // Switch to workouts tab
                    }) {
                        HStack {
                            Text("Start a workout")
                                .font(.system(size: 16, weight: .medium))
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                        }
                        .padding()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.horizontal)
                    
                    // Today's activities
                    todayActivitiesSection
                    
                    // Add widget
                    Button(action: {}) {
                        VStack {
                            Image(systemName: "plus")
                                .font(.system(size: 20))
                            
                            Text("add widget")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 120)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [5]))
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 50)
                }
                .padding(.top)
            }
            .navigationBarHidden(true)
            .background(Color.gray.opacity(0.05))
        }
    }
    
    func goalCard(title: String, value: String, unit: String, goal: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 16))
            
            Text(title)
                .font(.system(size: 14, weight: .semibold))
            
            Text("\(value) \(unit)")
                .font(.system(size: 20, weight: .medium))
            
            HStack {
                Spacer()
                Text("/\(goal)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(color)
        .cornerRadius(12)
    }
    
    var todayActivitiesSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Today's activities")
                    .font(.system(size: 18, weight: .semibold))
                
                Spacer()
                
                Button(action: {}) {
                    HStack {
                        Text("Show history")
                            .font(.system(size: 16, weight: .medium))
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14))
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal)
            
            VStack(spacing: 15) {
                activityCard(
                    type: "Running",
                    stats: [
                        ("40 min 17 sec", "clock"),
                        ("140 kcal", "flame.fill"),
                        ("4.2 km", "mappin")
                    ]
                )
                
                activityCard(
                    type: "Gym",
                    stats: [
                        ("1 hour 15 min", "clock"),
                        ("812 kcal", "flame.fill"),
                        ("8 exercises", "dumbbell.fill")
                    ]
                )
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
    
    func activityCard(type: String, stats: [(String, String)]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(type)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            
            HStack {
                ForEach(stats.indices, id: \.self) { index in
                    if index > 0 {
                        Divider()
                            .frame(height: 30)
                    }
                    
                    VStack(spacing: 5) {
                        Image(systemName: stats[index].1)
                            .font(.system(size: 18))
                        
                        Text(stats[index].0)
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    var workoutsView: some View {
        NavigationView {
            VStack {
                if workoutViewModel.isLoading {
                    ProgressView()
                } else if let error = workoutViewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                } else {
                    workoutOptionsView
                }
            }
            .navigationTitle("Workouts")
        }
    }
    
    var workoutOptionsView: some View {
        VStack(spacing: 16) {
            Button("Track a workout") {
                // Navigate to choose workout flow
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal)
            
            Button("Workout history") {
                // Navigate to workout history
            }
            .buttonStyle(SecondaryButtonStyle())
            .padding(.horizontal)
            
            Button("My workout templates") {
                // Navigate to workout templates
            }
            .buttonStyle(SecondaryButtonStyle())
            .padding(.horizontal)
            
            Button("Find a workout") {
                // Navigate to workout finder
            }
            .buttonStyle(SecondaryButtonStyle())
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top)
    }
    
    var profileView: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Button(action: {
                            // Go back to dashboard
                            selectedTab = 0
                        }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.primary)
                                .padding()
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 15) {
                            Button(action: {}) {
                                Image(systemName: "bell")
                                    .font(.system(size: 20))
                            }
                            
                            Button(action: {}) {
                                Image(systemName: "message")
                                    .font(.system(size: 20))
                            }
                            
                            Image("avatar")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal)
                    
                    // Settings sections
                    settingsSection(title: "Account", options: accountOptions)
                    settingsSection(title: "Workout", options: workoutOptions)
                    settingsSection(title: "More", options: moreOptions)
                    
                    // Sign out button
                    Button("Sign Out") {
                        authViewModel.signOut()
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 50)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    func settingsSection(title: String, options: [SettingOption]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 24, weight: .semibold))
                .padding(.horizontal)
            
            VStack(spacing: 0) {
                ForEach(options) { option in
                    HStack {
                        HStack {
                            Image(systemName: option.iconName)
                                .frame(width: 24, height: 24)
                                .foregroundColor(.primary)
                            
                            Text(option.title)
                                .font(.system(size: 16, weight: .medium))
                        }
                        
                        Spacer()
                        
                        if let value = option.value {
                            Text(value)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        
                        if option.hasToggle {
                            Toggle("", isOn: .constant(false))
                                .labelsHidden()
                        } else {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    
                    if options.last?.id != option.id {
                        Divider()
                            .padding(.leading)
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
    
    // Setting option definitions
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
}

struct SettingOption: Identifiable {
    var id: Int
    var title: String
    var iconName: String
    var value: String? = nil
    var hasToggle: Bool = false
}

// Preview
#Preview {
    DashboardView()
        .environmentObject(AuthViewModel.preview)
}
