//
//  CardView.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// CardView.swift
import SwiftUI

struct CardView<Content: View>: View {
    var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}