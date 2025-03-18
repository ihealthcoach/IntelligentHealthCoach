//
//  BottomActionButtonsView.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 18/03/2025.
//

import SwiftUI
import Kingfisher

struct BottomActionButtonsView: View {
    var selectedCount: Int
    var onAddExercises: () -> Void
    var onBuildSuperSet: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 12) {
                // Add exercises button
                Button(action: onAddExercises) {
                    Text("Add \(selectedCount > 1 ? "\(selectedCount) exercises" : "exercise")")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .padding(.horizontal, 24)
                        .background(Color("gray900"))
                        .cornerRadius(30)
                }
                
                // Build Super Set button (only if more than 1 exercise selected)
                if selectedCount > 1 {
                    Button(action: onBuildSuperSet) {
                        Text("Build Super Set")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color("gray900"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .padding(.horizontal, 24)
                            .background(Color.white)
                            .cornerRadius(30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color("gray200"), lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
            .padding(.top, 12)
            .background(Color.white)
            .cornerRadius(24, corners: [.topLeft, .topRight])
            .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: -3)
        }
    }
}
