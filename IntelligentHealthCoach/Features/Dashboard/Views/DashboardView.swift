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
    @State private var showingWorkoutSheet = false
    @State private var showChooseWorkoutView = false
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        ZStack {
            NavigationStack(path: $navigationPath) {
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
                            .foregroundColor(.gray900)
                            .padding(.horizontal)
                        
                        // Today's goals section
                        VStack(spacing: 16) {
                            HStack {
                                Text("Today's goals")
                                    .font(.system(size: 18, weight: .semibold))
                                
                                Button(action: {
                                    showGoalDetails.toggle()
                                }) {
                                    Image( showGoalDetails ? "chevron-down-mini" : "chevron-right-mini")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(Color("gray900"))
                                }
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    HStack(spacing: 4) {
                                        Text("Edit goals")
                                            .font(.system(size: 14))
                                        Image("arrow-right-mini")
                                                                .resizable()
                                                                .scaledToFit()
                                                                .frame(width: 14, height: 14)
                                                                .foregroundColor(Color("gray900"))
                                    }
                                    .foregroundColor(.gray900)
                                }
                            }
                            .padding(.horizontal)
                            
                            if showGoalDetails {
                                // Today's goal cards in 2x2 grid
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 6) {
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
                                .background(Color("offwhite"))
                                .cornerRadius(12)
                                .shadow(color: Color.gray900.opacity(0.05), radius: 5, x: 0, y: 2)
                                .padding(.horizontal)
                            }
                        }
                        
                        // Track workout button
                        Button(action: {
                            showingWorkoutSheet = true
                        }) {
                            HStack(spacing: 12) {
                                Text("Track a workout")
                                Image("arrow-right-mini")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(Color("offwhite"))
                            }
                        }
                        .buttonStyle(SecondaryButtonStyle())
                        .padding(.horizontal)
                        
                        
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
                                        Image("arrow-right-mini")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 14, height: 14)
                                            .foregroundColor(Color("gray900"))
                                    }
                                    .foregroundColor(.gray900)
                                }
                            }
                            .padding(.horizontal)
                            
                            // Activity cards
                            if viewModel.activities.isEmpty {
                                Text("No activities recorded today")
                                    .foregroundColor(.secondary)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color(.offwhite))
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
                                Image("plus-mini")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color("gray400"))
                                
                                Text("add widget")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color("gray400"))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 120)
                            .background(Color.clear)
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
                }
                .standardScreen(horizontalPadding: 0, verticalPadding: 0)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(true)
                .loadingOverlay(isLoading: viewModel.isLoading, message: "Loading your dashboard...")
                .refreshable {
                    await viewModel.refreshData()
                }
                .navigationDestination(isPresented: $showChooseWorkoutView) {
                    ChooseWorkoutView()
                }
            }
            
            // Bottom tab bar using the reusable component
            VStack {
                Spacer()
                TabBarView(
                    selectedTab: $selectedTab,
                    onShowChooseWorkout: {
                        showChooseWorkoutView = true
                    }
                )
            }
        }
        .sheet(isPresented: $showingWorkoutSheet) {
            WorkoutActionSheet(
                onTrackWorkout: {
                    // Dismiss the current sheet and show ChooseWorkoutView
                    showingWorkoutSheet = false
                    
                    // Use a slight delay to avoid UI conflicts with sheet transitions
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showChooseWorkoutView = true
                    }
                },
                onWorkoutHistory: {
                    // Navigate to workout history
                },
                onWorkoutTemplates: {
                    // Navigate to workout templates
                },
                onFindWorkout: {
                    // Navigate to find workout
                }
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        
        .onAppear {
            viewModel.loadData()
            authViewModel.refreshUserProfile()
            
            print("🔍 DashboardView - currentUser: \(String(describing: authViewModel.currentUser))")
            print("🔍 DashboardView - firstName: \(authViewModel.currentUser?.firstName ?? "nil")")
            print("🔍 DashboardView - lastName: \(authViewModel.currentUser?.lastName ?? "nil")")
            print("🔍 DashboardView - email: \(authViewModel.currentUser?.email ?? "nil")")
        }
    }
    
    // Header view with menu icon, greeting and user profile - MOVED OUTSIDE BODY
    var headerView: some View {
        VStack(spacing: 16) {
            // Top row with menu, notifications, and avatar
            HStack {
                // Menu icon in top left
                Button(action: {
                    // Menu action
                }) {
                    Image("bars-3-bottom-left-mini")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color("gray900"))
                }
                
                Spacer()
                
                // Notification and profile buttons
                HStack(spacing: 16) {
                    Button(action: {
                        // Notification action
                    }) {
                        Image("bell-outline")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color("gray900"))
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
                        Image("chat-bubble-oval-left-ellipsis-outline")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color("gray900"))
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
                                .frame(width: 48, height: 48)
                                .clipShape(Circle())
                        } else {
                            Image("avatar-broe")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                                .foregroundColor(Color("gray900"))
                        }
                    }
                }
            }
            
            // Greeting text below top row
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.greeting)
                    .font(.system(size: 30, weight: .light))
                
                Text(authViewModel.currentUser?.firstName ?? "User")
                    .font(.system(size: 30, weight: .bold))
                    .id(authViewModel.currentUser?.firstName ?? "User") // Force refresh when firstName changes
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
    }
    
    // Goal pill badge - MOVED OUTSIDE BODY
    func goalPill(text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .medium))
            .padding(.horizontal, 8)
            .padding(.vertical, 4) // Ensure enough vertical padding
            .background(Color.clear)
            .foregroundColor(Color("gray900"))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color("gray900"), lineWidth: 1)
            )
    }
    
    // Goal card with progress indicator
    func goalCard(goal: TodayGoal) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                goal.icon
                
                Text(goal.title)
                    .font(.system(size: 16, weight: .medium))
            }
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(goal.currentValue)
                    .font(.system(size: 30, weight: .bold))
                
                Text(goal.unit)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray900)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                ProgressBar(progress: goal.progress, color: goal.color)
                    .frame(height: 6)
                
                Text("/\(goal.targetValue)")
                    .font(.system(size: 12))
                    .foregroundColor(.gray500)
            }
        }
        .padding()
        .background(Color.offwhite)
        .cornerRadius(8)
    }
    
    // Summary row for additional stats
    func summaryRow(title: String, value: String, showArrow: Bool = false) -> some View {
        HStack {
            // Title with medium weight
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color("gray900"))
            
            Spacer()
            
            // Value split into two parts: before and after "/"
            if value.contains("/") {
                let components = value.split(separator: "/")
                if components.count == 2 {
                    // First part (like "3") with semibold weight
                    Text(String(components[0]))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("gray900"))
                    
                    // The slash and second part (like "/5") with medium weight and gray400 color
                    Text("/" + String(components[1]))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color("gray400"))
                } else {
                    // Fallback if format is unexpected
                    Text(value)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("gray900"))
                }
            } else {
                // For values without a slash
                Text(value)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("gray900"))
            }
            
            if showArrow {
                Image("chevron-right-mini")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color("gray400"))
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
                
                Image("arrow-right-mini")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color("gray900"))
            }
            
            HStack(spacing: 0) {
                ForEach(activity.stats.indices, id: \.self) { index in
                    VStack(spacing: 4) {
                        activity.stats[index].1  // Render the icon directly (it's already an AnyView)
                        
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
        .background(Color.offwhite)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    DashboardView()
        .environmentObject(AuthViewModel.preview)
}
