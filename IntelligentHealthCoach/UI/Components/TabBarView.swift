//
//  TabBarView.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 15/03/2025.
//

import SwiftUI

struct TabBarView: View {
    @Binding var selectedTab: Int
    var actionHandler: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            tabButton(title: "Home", icon: "house.fill", isSelected: selectedTab == 0) {
                selectedTab = 0
            }
            
            tabButton(title: "Activity", icon: "chart.bar.fill", isSelected: selectedTab == 1) {
                selectedTab = 1
            }
            
            // Center add button
            ZStack {
                Circle()
                    .fill(Color.indigo)
                    .frame(width: 60, height: 60)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                
                Button(action: actionHandler) {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .offset(y: -20)
            
            tabButton(title: "Food", icon: "fork.knife", isSelected: selectedTab == 2) {
                selectedTab = 2
            }
            
            tabButton(title: "Workouts", icon: "dumbbell.fill", isSelected: selectedTab == 3) {
                selectedTab = 3
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(
            Rectangle()
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: -5)
                .edgesIgnoringSafeArea(.bottom)
        )
    }
    
    // Individual tab button
    private func tabButton(title: String, icon: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? .indigo : .gray)
                
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(isSelected ? .indigo : .gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    TabBarView(selectedTab: .constant(0), actionHandler: {})
        .previewLayout(.sizeThatFits)
}
