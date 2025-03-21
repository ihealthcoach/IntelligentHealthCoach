//
//  CheckboxToggle.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// CheckboxToggle.swift
import SwiftUI

struct CheckboxToggle: View {
    @Binding var isChecked: Bool
    var label: String
    
    var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(isChecked ? .blue : .gray)
                    .font(.system(size: 20, weight: .regular))
                
                Text(label)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.primary)
                
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 20) {
        CheckboxToggle(isChecked: .constant(true), label: "Selected Option")
        CheckboxToggle(isChecked: .constant(false), label: "Unselected Option")
    }
    .padding()
}
