//
//  SafeAreaSpacerView.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 21/03/2025.
//

import SwiftUI

struct SafeAreaSpacerView: View {
    enum SafeAreaRegion {
        case top, bottom, leading, trailing
    }
    
    var region: SafeAreaRegion = .top
    
    var body: some View {
        Spacer()
            .frame(height: safeAreaInset)
    }
    
    private var safeAreaInset: CGFloat {
        guard let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first else {
                return 0
        }
        
        let safeAreaInsets = keyWindow.safeAreaInsets
        
        switch region {
        case .top:
            return safeAreaInsets.top
        case .bottom:
            return safeAreaInsets.bottom
        case .leading:
            return safeAreaInsets.left
        case .trailing:
            return safeAreaInsets.right
        }
    }
}

// Add a ViewModifier for easy application
struct SafeAreaSpacerModifier: ViewModifier {
    var regions: [SafeAreaSpacerView.SafeAreaRegion] = [.top]
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            if regions.contains(.top) {
                SafeAreaSpacerView(region: .top)
            }
            
            content
            
            if regions.contains(.bottom) {
                SafeAreaSpacerView(region: .bottom)
            }
        }
    }
}

// Extension for convenient usage
extension View {
    func withSafeAreaSpacer(regions: [SafeAreaSpacerView.SafeAreaRegion] = [.top]) -> some View {
        self.modifier(SafeAreaSpacerModifier(regions: regions))
    }
}

#Preview {
    SafeAreaSpacerView()
}
