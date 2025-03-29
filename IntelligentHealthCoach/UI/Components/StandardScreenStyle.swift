//
//  StandardScreenStyle.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 30/03/2025.
//

import SwiftUI

struct StandardScreenModifier: ViewModifier {
    var horizontalPadding: CGFloat = 16
    var verticalPadding: CGFloat = 16
    var alignment: Alignment = .top
    var safeAreaRegions: [SafeAreaSpacerView.SafeAreaRegion] = [.top, .bottom]
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            .withSafeAreaSpacer(regions: safeAreaRegions)
            .appBackground()
    }
}

extension View {
    func standardScreen(
        horizontalPadding: CGFloat = 16,
        verticalPadding: CGFloat = 16,
        alignment: Alignment = .top,
        safeAreaRegions: [SafeAreaSpacerView.SafeAreaRegion] = [.top, .bottom]
    ) -> some View {
        self.modifier(StandardScreenModifier(
            horizontalPadding: horizontalPadding,
            verticalPadding: verticalPadding,
            alignment: alignment,
            safeAreaRegions: safeAreaRegions
        ))
    }
}
