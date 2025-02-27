// DashboardView.swift
import SwiftUI
import Kingfisher

struct DashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject private var viewModel = DashboardViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerSection
                    goalBadgesSection
                    todaysProgressText
                    todaysGoalsSection
                    startWorkoutButton
                    todayActivitiesSection
                    addWidgetButton
                }
                .padding(.top)
            }
            .navigationBarHidden(true)
            .background(Color.gray.opacity(0.05))
            .refreshable {
                await viewModel.refreshData()