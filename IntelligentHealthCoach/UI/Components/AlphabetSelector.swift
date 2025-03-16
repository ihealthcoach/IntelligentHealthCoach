//
//  AlphabetSelector.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 16/03/2025.
//

import SwiftUI

// Alphabet index selector component
struct AlphabetSelector: View {
    var availableLetters: Set<String>
    var onLetterSelected: (String) -> Void
    
    var body: some View {
        VStack(spacing: 0) { // 2px spacing between letters
            // Numbers section (#)
            Button(action: {
                if availableLetters.contains("#") {
                    onLetterSelected("#")
                }
            }) {
                Text("#")
                    .font(.system(size: 11, weight: .medium)) // 11pt medium font
                    .foregroundColor(availableLetters.contains("#") ? Color("gray400") : Color("gray200"))
                    .frame(width: 20, height: 20)
            }
            
            // Alphabet (A-Z)
            ForEach((65...90).map { String(UnicodeScalar($0)) }, id: \.self) { letter in
                Button(action: {
                    onLetterSelected(letter)
                }) {
                    Text(letter)
                        .font(.system(size: 11, weight: .medium)) // 11pt medium font
                        .foregroundColor(availableLetters.contains(letter) ? Color("gray400") : Color("gray200"))
                        .frame(width: 20, height: 20)
                }
            }
        }
        .padding(.trailing, 8)
    }
}

// Preview for AlphabetSelector
struct AlphabetSelector_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 30) {
            // Title for the preview
            Text("AlphabetSelector Component")
                .font(.headline)
                .padding(.bottom, 10)
            
            HStack(spacing: 50) {
                // Example with all letters available
                VStack(alignment: .center, spacing: 10) {
                    Text("All letters available:")
                        .font(.subheadline)
                    
                    AlphabetSelector(
                        availableLetters: Set(["#", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
                                              "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]),
                        onLetterSelected: { _ in }
                    )
                }
                
                // Example with only some letters available
                VStack(alignment: .center, spacing: 10) {
                    Text("Some letters available:")
                        .font(.subheadline)
                    
                    AlphabetSelector(
                        availableLetters: Set(["A", "C", "F", "M", "P", "S", "T"]),
                        onLetterSelected: { _ in }
                    )
                }
                
                // Example on dark background
                VStack(alignment: .center, spacing: 10) {
                    Text("On dark background:")
                        .font(.subheadline)
                    
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.8))
                            .frame(width: 50, height: 500)
                            .cornerRadius(12)
                        
                        AlphabetSelector(
                            availableLetters: Set(["#", "A", "B", "F", "K", "M", "Z"]),
                            onLetterSelected: { _ in }
                        )
                    }
                }
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .background(Color.white)
    }
}
