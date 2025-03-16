//
//  Badge.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// Badge.swift
import SwiftUI

struct Badge: View {
    var text: String
    var icon: AnyView? = nil
    var hasBorder: Bool = false
    var isDark: Bool = false
    
    var body: some View {
        HStack(spacing: 5) {
            if let icon = icon {
                icon
            }
            
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(isDark ? .white : Color("gray900"))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(isDark ? Color.black : Color("White"))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(hasBorder ? Color.gray.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }
}
