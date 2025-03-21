//
//  HeaderView.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 18/03/2025.
//

import SwiftUI

// Header View Component
struct HeaderView: View {
    var onBack: () -> Void
    @Binding var showWorkoutSheet: Bool
    var trailingButton: (() -> AnyView)? = nil
    
    var body: some View {
        HStack {
            // Back button
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20))
                    .foregroundColor(.gray900)
            }
            
            Spacer()
            
            // View workout button
            Button(action: { showWorkoutSheet = true }) {
                HStack(spacing: 2) {
                    Text("View workout")
                        .font(.system(size: 14))
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                }
                .foregroundColor(.gray)
            }
            
            // Custom trailing button if provided
            if let trailingButton = trailingButton {
                trailingButton()
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    HeaderView(
        onBack: { },
        showWorkoutSheet: .constant(false)
    )
    .padding()
    .background(Color("gray50"))
}
