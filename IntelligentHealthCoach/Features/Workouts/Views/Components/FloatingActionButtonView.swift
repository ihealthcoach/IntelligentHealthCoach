//
//  FloatingActionButtonView.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 18/03/2025.
//

import SwiftUI

struct FloatingActionButtonView: View {
    var selectedCount: Int
    var onTap: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: onTap) {
                    ZStack {
                        Circle()
                            .fill(Color("gray900"))
                            .frame(width: 56, height: 56)
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                        
                        if selectedCount == 0 {
                            // Show filter icon
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        } else {
                            // Show exercise count
                            HStack(spacing: 4) {
                                Image(systemName: "list.bullet")
                                    .font(.system(size: 16))
                                Text("\(selectedCount)")
                                    .font(.system(size: 16, weight: .bold))
                            }
                            .foregroundColor(.white)
                        }
                    }
                }
                .padding(.trailing, 20)
                .padding(.bottom, selectedCount == 0 ? 20 : 120) // Adjust based on buttons
            }
        }
    }
}

struct FloatingActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview with filter icon
            FloatingActionButtonView(
                selectedCount: 0,
                onTap: {}
            )
            .previewDisplayName("Filter Icon")
            
            // Preview with count
            FloatingActionButtonView(
                selectedCount: 5,
                onTap: {}
            )
            .previewDisplayName("Exercise Count")
        }
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color("gray100"))
    }
}
