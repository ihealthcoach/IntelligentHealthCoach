//
//  DashboardView.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//

import SwiftUI
import Kingfisher

struct DashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel = DashboardViewModel()
    @State private var showGoalDetails = true
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header with user info
                        headerView
                        
                        // Goal tags
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(viewModel.goals, id: \.self) { goal in
                                    goalPill(text: goal)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Progress message
                        Text(viewModel.progressMessage)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        // Today's goals section
                        VStack(spacing: 16) {
                            HStack {
                                Text("Today's goals")
                                    .font(.system(size: 18, weight: .semibold))
                                
                                Button(action: {
                                    showGoalDetails.toggle()
                                }) {
                                    Image(systemName: showGoalDetails ? "chevron.down" : "chevron.right")
                                        .foregroundColor(.primary)
                                }
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    HStack(spacing: 4) {
                                        Text("Edit goals")
                                            .font(.system(size: 14))
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12))
                                    }
                                    .foregroundColor(.blue)
                                }
                            }
                            .padding(.horizontal)
                            
                            if showGoalDetails {
                                // Today's goal cards in 2x2 grid
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                    ForEach(viewModel.todayGoals) { goal in
                                        goalCard(goal: goal)
                                    }
                                }
                                .padding(.horizontal)
                                
                                // Additional summary stats
                                VStack(spacing: 12) {
                                    summaryRow(title: "Workouts (week 36)", value: "3/5", showArrow: true)
                                    Divider()
                                    summaryRow(title: "Weight", value: "86/92 kg", showArrow: true)
                                    Divider()
                                    summaryRow(title: "Calories", value: "1.350/2.500", showArrow: true)
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                .padding(.horizontal)
                            }
                        }
                        
                        // Track workout button
                        Button(action: {
                            selectedTab = 3 // Switch to workouts tab
                        }) {
                            HStack {
                                Text("Track a workout")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color(.systemIndigo))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                        
                        // Today's activities section
                        VStack(spacing: 16) {
                            HStack {
                                Text("Today's activities")
                                    .font(.system(size: 18, weight: .semibold))
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    HStack(spacing: 4) {
                                        Text("Show history")
                                            .font(.system(size: 14))
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12))
                                    }
                                    .foregroundColor(.blue)
                                }
                            }
                            .padding(.horizontal)
                            
                            // Activity cards
                            if viewModel.activities.isEmpty {
                                Text("No activities recorded today")
                                    .foregroundColor(.secondary)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color(.systemBackground))
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                            } else {
                                ForEach(viewModel.activities) { activity in
                                    activityCard(activity: activity)
                                }
                            }
                        }
                        
                        // Add widget button (dashed border style)
                        Button(action: {
                            // Add widget action
                        }) {
                            VStack(spacing: 8) {
                                Image(systemName: "plus")
                                    .font(.system(size: 20))
                                    .foregroundColor(.gray)
                                
                                Text("add widget")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 120)
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                    .foregroundColor(.gray.opacity(0.5))
                            )
                            .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 80)
                    }
                    .padding(.top)
                    .padding(.bottom, 80) // Add padding for tab bar
                }
                .background(Color(.systemGroupedBackground))
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(true)
                .loadingOverlay(isLoading: viewModel.isLoading, message: "Loading your dashboard...")
                .refreshable {
                    await viewModel.refreshData()
                }
            }
            
            // Bottom tab bar using the reusable component
            VStack {
                Spacer()
                TabBarView(selectedTab: $selectedTab, actionHandler: {
                    // Action for the center + button
                })
            }
        }
        .onAppear {
            viewModel.loadData()
            print("🧪 DashboardView onAppear - authViewModel.currentUser?.firstName = \(authViewModel.currentUser?.firstName ?? "nil")")
            print("🧪 DashboardView onAppear - authViewModel.isAuthenticated = \(authViewModel.isAuthenticated)")
        }
    }
    
    // Header view with menu icon, greeting and user profile
    var headerView: some View {
        VStack(spacing: 16) {
            // Top row with menu, notifications, and avatar
            HStack {
                // Menu icon in top left
                Button(action: {
                    // Menu action
                }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.system(size: 22))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                // Notification and profile buttons
                HStack(spacing: 16) {
                    Button(action: {
                        // Notification action
                    }) {
                        Image(systemName: "bell")
                            .font(.system(size: 20))
                            .foregroundColor(.primary)
                            .overlay(
                                viewModel.hasNotifications ?
                                    Circle()
                                    .fill(Color.red)
                                    .frame(width: 8, height: 8)
                                    .offset(x: 8, y: -8) : nil
                            )
                    }
                    
                    Button(action: {
                        // Messages action
                    }) {
                        Image(systemName: "message")
                            .font(.system(size: 20))
                            .foregroundColor(.primary)
                    }
                    
                    // Avatar links to settings/profile
                    NavigationLink(destination: ProfileView().environmentObject(authViewModel)) {
                        if let avatarUrl = authViewModel.currentUser?.avatarUrl, !avatarUrl.isEmpty {
                            KFImage(URL(string: avatarUrl))
                                .placeholder {
                                    Circle().foregroundColor(.gray)
                                }
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 36, height: 36)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 36))
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            
            // Greeting text below top row
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.greeting)
                    .font(.system(size: 24))
                
                Text(authViewModel.currentUser?.firstName ?? "User")
                    .font(.system(size: 28, weight: .bold))
                    .id(authViewModel.currentUser?.firstName ?? "User") // Force refresh when firstName changes
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
    }
    
    // Goal pill badge
    func goalPill(text: String) -> some View {
        Text(text)
            .font(.system(size: 14))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(.systemBackground))
            .foregroundColor(.primary)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
    }
    
    // Goal card with progress indicator
    func goalCard(goal: TodayGoal) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: goal.icon)
                    .foregroundColor(goal.color)
                
                Text(goal.title)
                    .font(.system(size: 14, weight: .semibold))
            }
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(goal.currentValue)
                    .font(.system(size: 24, weight: .bold))
                
                Text(goal.unit)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                ProgressBar(progress: goal.progress, color: goal.color)
                    .frame(height: 6)
                
                Text("/\(goal.targetValue)")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    // Summary row for additional stats
    func summaryRow(title: String, value: String, showArrow: Bool = false) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 16))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .semibold))
            
            if showArrow {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
    }
    
    // Activity card using your existing Activity model
    func activityCard(activity: Activity) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(activity.type)
                    .font(.system(size: 16, weight: .semibold))
                
                Spacer()
                
                Text(activity.formattedTime)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            
            HStack(spacing: 0) {
                ForEach(activity.stats.indices, id: \.self) { index in
                    VStack(spacing: 4) {
                        Image(systemName: activity.stats[index].1)
                            .font(.system(size: 18))
                            .foregroundColor(.secondary)
                        
                        Text(activity.stats[index].0)
                            .font(.system(size: 14, weight: .medium))
                    }
                    .frame(maxWidth: .infinity)
                    
                    if index < activity.stats.count - 1 {
                        Divider()
                            .frame(height: 30)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    DashboardView()
        .environmentObject(AuthViewModel.preview)
}
