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
    @Binding var showWorkoutSheet: Bool  // This needs to be defined if you want to pass it as a binding
    
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
            
            // Add exercise button
            Button(action: {}) {
                Image(systemName: "plus")
                    .font(.system(size: 18))
                    .foregroundColor(.gray900)
                    .padding(8)
                    .background(Color.offwhite)
                    .clipShape(Circle())
            }
            
            // Done button
            Button(action: {}) {
                HStack {
                    Text("Done")
                    Image(systemName: "checkmark")
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color("gray900"))
                .foregroundColor(.offwhite)
                .cornerRadius(20)
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
