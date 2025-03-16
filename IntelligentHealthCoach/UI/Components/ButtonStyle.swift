//
//  ButtonStyle.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var bgColor: Color = Color("indigo600")
    var textColor: Color = .white
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 12) {
            Spacer()
            configuration.label
            Spacer()
        }
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(textColor)
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .background(bgColor)
            .cornerRadius(5)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    var hasOutline: Bool = true
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 12) {
            Spacer()
            configuration.label
            Spacer()
        }
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.white)
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .background(Color("gray900"))
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(hasOutline ? Color.gray.opacity(0.2) : Color.clear, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
    }
}

// Tertiary button style for sheet action buttons
struct TertiaryButtonStyle: ButtonStyle {
    var isSelected: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
            Spacer()
        }
        .font(.system(size: 18, weight: .medium))
        .foregroundColor(Color("gray900"))
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(Color("gray50"))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .cornerRadius(8)
        .scaleEffect(configuration.isPressed ? 0.98 : 1)
        .opacity(configuration.isPressed ? 0.9 : 1)
        .padding(.horizontal, 24)
        .padding(.vertical, 6)
    }
}

// Usage extension for SwiftUI Button
extension Button {
    func tertiaryStyle(isSelected: Bool = false) -> some View {
        self.buttonStyle(TertiaryButtonStyle(isSelected: isSelected))
    }
}


struct ChooseWorkoutButton: View {
    var title: String
    var description: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("gray900"))
                    
                    Text(description)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color("gray400"))
                }
                
                Spacer()
                    .frame(width: 24) // 24px gap
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Color("gray400"))
            }
            .padding(16)
            .background(Color("gray50"))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("gray200"), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
