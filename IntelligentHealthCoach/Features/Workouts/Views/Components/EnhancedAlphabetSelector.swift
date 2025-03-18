//
//  EnhancedAlphabetSelector.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 18/03/2025.
//

import SwiftUI

struct EnhancedAlphabetSelector: View {
    var availableLetters: Set<String>
    var onLetterSelected: (String) -> Void
    
    private let letters = ["#"] + (65...90).map { String(UnicodeScalar($0)) }
    
    var body: some View {
        VStack(spacing: 1) {
            ForEach(letters, id: \.self) { letter in
                Button(action: {
                    onLetterSelected(letter)
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }) {
                    Text(letter)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(availableLetters.contains(letter) ? Color("gray500") : Color("gray300"))
                        .frame(width: 22, height: 22)
                }
            }
        }
        .padding(.trailing, 8)
        .padding(.vertical, 10)
        .background(Color.white.opacity(0.5))
        .cornerRadius(16)
    }
}

struct EnhancedAlphabetSelector_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("gray100").edgesIgnoringSafeArea(.all)
            EnhancedAlphabetSelector(
                availableLetters: Set(["A", "B", "C", "M", "Z"]),
                onLetterSelected: { _ in }
            )
        }
        .previewLayout(.sizeThatFits)
        .frame(height: 600)
    }
}
