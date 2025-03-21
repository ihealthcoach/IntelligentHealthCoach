//
//  TabBarView.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 15/03/2025.
//

// IntelligentHealthCoach/UI/Components/TabBarView.swift

import SwiftUI

// Define the enum at the top of the file, outside any struct
enum WorkoutNavigationState {
    case none
    case shortcuts
    case actionSheet
    case chooseWorkout
}

struct TabBarView: View {
    @Binding var selectedTab: Int
    @State private var showingShortcutsSheet = false
    @State private var showingWorkoutSheet = false
    var onShowChooseWorkout: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            tabButton(
                title: "Home",
                icon: AnyView(
                    Image("home-outline")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(selectedTab == 0 ? Color("indigo600") : Color("gray900"))
                ),
                isSelected: selectedTab == 0
            ) { selectedTab = 0 }
            
            tabButton(
                title: "Activity",
                icon: AnyView(
                    Image("chart-bar-outline")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(selectedTab == 1 ? Color("indigo600") : Color("gray900"))
                ),
                isSelected: selectedTab == 1
            ) { selectedTab = 1 }
            
            // Center add button
            ZStack {
                Circle()
                    .fill(Color.indigo600)
                    .frame(width: 52, height: 52)
                    .shadow(color: .gray900.opacity(0.2), radius: 4, x: 0, y: 2)
                
                Button(action: {
                    showingShortcutsSheet = true
                }) {
                    Image("plus-mini")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color("offwhite"))
                }
            }
            
            tabButton(
                title: "Food",
                icon: AnyView(
                    Image("chefs-hat")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(selectedTab == 2 ? Color("indigo600") : Color("gray900"))
                ), isSelected: selectedTab == 2) {
                selectedTab = 2
            }
            
            tabButton(
                title: "Workouts",
                icon: AnyView(
                    Image("dumbbell")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(selectedTab == 3 ? Color("indigo600") : Color("gray900"))
                ), isSelected: selectedTab == 3) {
                selectedTab = 3
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(
            Rectangle()
                .fill(Color("offwhite"))
                .shadow(color: .gray900.opacity(0.05), radius: 5, x: 0, y: -5)
                .edgesIgnoringSafeArea(.bottom)
        )
        .sheet(isPresented: $showingShortcutsSheet) {
            ShortcutSheet(
                showWorkoutSheet: $showingWorkoutSheet,
                onStartWorkout: {
                    onShowChooseWorkout()
                }
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
        // Workout sheet presentation
        .sheet(isPresented: $showingWorkoutSheet) {
            WorkoutActionSheet(
                onTrackWorkout: {
                    selectedTab = 3
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
    }
}
    
    // Individual tab button
private func tabButton<V: View>(title: String, icon: V, isSelected: Bool, action: @escaping () -> Void) -> some View {
    Button(action: action) {
        VStack(spacing: 4) {
            icon
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(.system(size: 11))
                .foregroundColor(isSelected ? Color("indigo600") : Color("gray900"))
        }
        .frame(maxWidth: .infinity)
    }
}


#Preview(traits: .sizeThatFitsLayout) {
    TabBarView(
        selectedTab: .constant(0),
        onShowChooseWorkout: { /* Do nothing in preview */ }
    )
}
