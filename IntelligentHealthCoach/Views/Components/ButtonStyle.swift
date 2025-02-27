//
//  ButtonStyle.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// ButtonStyles.swift
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var bgColor: Color = .indigo
    var textColor: Color = .white
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(textColor)
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity)
            .background(bgColor)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    var hasOutline: Bool = true
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.gray)
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(hasOutline ? Color.gray.opacity(0.2) : Color.clear, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
    }
}
