//
//  RadioButton.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// RadioButton.swift
import SwiftUI

struct RadioButton: View {
    @Binding var selectedOption: String
    var option: String
    var label: String
    
    var body: some View {
        Button(action: {
            selectedOption = option
        }) {
            HStack(alignment: .center, spacing: 10) {
                ZStack {
                    Circle()
                        .stroke(selectedOption == option ? Color.blue : Color.gray, lineWidth: 2)
                        .frame(width: 20, height: 20)
                    
                    if selectedOption == option {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 12, height: 12)
                    }
                }
                
                Text(label)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.primary)
                
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}