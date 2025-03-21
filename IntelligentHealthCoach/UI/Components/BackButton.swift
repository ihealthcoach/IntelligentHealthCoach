//
//  BackButton.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 16/03/2025.
//

import SwiftUI

struct BackButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.left")
                .font(.system(size: 20))
                .foregroundColor(Color("gray900"))
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    BackButton(action: {})
        .padding()
}
