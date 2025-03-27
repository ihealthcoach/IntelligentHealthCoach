//
//  View+ScreenSize.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 27/03/2025.
//

import SwiftUI

extension View {
    func responsiveFrame(idealHeight: CGFloat, minHeight: CGFloat? = nil) -> some View {
        self.frame(
            maxWidth: .infinity,
            minHeight: minHeight,
            idealHeight: idealHeight,
            maxHeight: UIScreen.main.bounds.height * 0.7
        )
    }
    
    func responsivePadding(_ edges: Edge.Set = .all) -> some View {
        let screenWidth = UIScreen.main.bounds.width
        let basePadding: CGFloat = 16
        
        // Adjust padding based on screen width
        let calculatedPadding: CGFloat
        if screenWidth < 375 { // Small screens (e.g., SE)
            calculatedPadding = basePadding * 0.75
        } else if screenWidth >= 428 { // Larger screens (e.g., Pro Max)
            calculatedPadding = basePadding * 1.25
        } else {
            calculatedPadding = basePadding
        }
        
        return self.padding(edges, calculatedPadding)
    }
    
    // Helper to check if we're on a small device
    var isSmallDevice: Bool {
        UIScreen.main.bounds.height < 700
    }
}
