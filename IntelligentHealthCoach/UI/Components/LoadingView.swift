//
//  LoadingView.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 12/03/2025.
//

// IntelligentHealthCoach/UI/Components/LoadingView.swift
import SwiftUI

struct LoadingView: View {
    var message: String = "Loading..."
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
            
            Text(message)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.9))
    }
}

// Overlay modifier for convenient loading state
extension View {
    func loadingOverlay(isLoading: Bool, message: String = "Loading...") -> some View {
        ZStack {
            self
            
            if isLoading {
                LoadingView(message: message)
                    .transition(.opacity)
                    .zIndex(100)
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(message: "Loading your profile...")
    }
}
