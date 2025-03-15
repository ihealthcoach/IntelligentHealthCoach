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
    @StateObject var viewModel = DashboardViewModel()
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            homeView
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            WorkoutsView()
                .tabItem {
                    Label("Workouts", systemImage: "dumbbell.fill")
                }
                .tag(1)
            
            Text("Nutrition")
                .tabItem {
                    Label("Nutrition", systemImage: "fork.knife")
                }
                .tag(2)
            
            ProfileView()
                .environmentObject(authViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(3)
        }
        .onAppear {
            viewModel.loadData()
        }
    }
    
    var homeView: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack {
                        VStack(alignment: .leading) {
                            Text(viewModel.greeting)
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
                                if let avatarUrl = authViewModel.currentUser?.avatarUrl, !avatarUrl.isEmpty {
                                    KFImage(URL(string: avatarUrl))
                                        .placeholder {
                                            Image(systemName: "person.circle.fill")
                                                .resizable()
                                                .foregroundColor(.gray)
                                        }
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Goal badges
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(viewModel.goals, id: \.self) { goal in
                                Badge(text: goal, hasBorder: true)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Text(viewModel.progressMessage)
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
                            
                            Button(action: {}) {
                                HStack {
                                    Text("Edit goals")
                                        .font(.system(size: 16, weight: .medium))
                                    
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 14))
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        // Goal cards grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            ForEach(viewModel.todayGoals) { goal in
                                goalCard(goal: goal)
                            }
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
                    if !viewModel.activities.isEmpty {
                        todayActivitiesSection
                    }
                    
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
            .loadingOverlay(isLoading: viewModel.isLoading, message: "Loading your dashboard...")
            .refreshable {
                await viewModel.refreshData()
            }
        }
    }
    
    func goalCard(goal: TodayGoal) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Image(systemName: goal.icon)
                .font(.system(size: 16))
            
            Text(goal.title)
                .font(.system(size: 14, weight: .semibold))
            
            Text("\(goal.currentValue) \(goal.unit)")
                .font(.system(size: 20, weight: .medium))
            
            HStack {
                // Progress bar
                ProgressBar(progress: goal.progress, color: goal.color.opacity(0.8))
                    .frame(height: 6)
                
                Text("/\(goal.targetValue)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(goal.color.opacity(0.2))
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
                ForEach(viewModel.activities) { activity in
                    activityCard(activity: activity)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
    
    func activityCard(activity: Activity) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(activity.type)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(activity.formattedTime)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            
            HStack {
                ForEach(activity.stats.indices, id: \.self) { index in
                    if index > 0 {
                        Divider()
                            .frame(height: 30)
                    }
                    
                    VStack(spacing: 5) {
                        Image(systemName: activity.stats[index].1)
                            .font(.system(size: 18))
                        
                        Text(activity.stats[index].0)
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(AuthViewModel.preview)
}
