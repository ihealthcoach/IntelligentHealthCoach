//
//  FormField.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 30/03/2025.
//

import SwiftUI
import UIKit

struct FormField: View {
    var title: String
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType?
    var isSecure: Bool = false
    var capitalizationType: UITextAutocapitalizationType = .none
    var showToggleButton: Bool = false
    @Binding var isSecureTextHidden: Bool
    var errorMessage: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Field label
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color("gray700"))
            
            // Text input field
            HStack {
                if isSecure && !isSecureTextHidden {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                        .textInputAutocapitalization(getSwiftUICapitalization())
                        .textContentType(textContentType)
                        .disableAutocorrection(true)
                        .padding()
                } else if isSecure {
                    SecureField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                        .textInputAutocapitalization(getSwiftUICapitalization())
                        .textContentType(textContentType)
                        .disableAutocorrection(true)
                        .padding()
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                        .textInputAutocapitalization(getSwiftUICapitalization())
                        .textContentType(textContentType)
                        .disableAutocorrection(true)
                        .padding()
                }
                
                // Toggle button for password fields
                if showToggleButton {
                    Button(action: { isSecureTextHidden.toggle() }) {
                        Image(systemName: isSecureTextHidden ? "eye" : "eye.slash")
                            .foregroundColor(Color("gray400"))
                    }
                    .padding(.trailing)
                }
                
                // Add clear button for non-secure fields
                if !text.isEmpty && !isSecure {
                    Button(action: { text = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color("gray400"))
                    }
                    .padding(.trailing)
                }
            }
            .background(Color("offwhite"))
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(errorMessage == nil ? Color("gray200") : Color.red, lineWidth: 1)
            )
            
            // Error message
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.system(size: 12))
                    .foregroundColor(.red)
                    .padding(.top, 4)
            }
        }
    }
    
    // Helper method to convert UIKit capitalization type to SwiftUI capitalization type
    private func getSwiftUICapitalization() -> TextInputAutocapitalization {
        switch capitalizationType {
        case .none:
            return .never
        case .words:
            return .words
        case .sentences:
            return .sentences
        case .allCharacters:
            return .characters
        @unknown default:
            return .never
        }
    }
}

// MARK: - Preview
struct FormField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Regular text field
            FormField(
                title: "First Name",
                placeholder: "Enter your first name",
                text: .constant("John"),
                textContentType: .givenName,
                capitalizationType: .words,
                isSecureTextHidden: .constant(false)
            )
            
            // Email field
            FormField(
                title: "Email",
                placeholder: "Enter your email",
                text: .constant("john@example.com"),
                keyboardType: .emailAddress,
                textContentType: .emailAddress,
                isSecureTextHidden: .constant(false)
            )
            
            // Password field
            FormField(
                title: "Password",
                placeholder: "Enter your password",
                text: .constant("password123"),
                textContentType: .password,
                isSecure: true,
                showToggleButton: true,
                isSecureTextHidden: .constant(true)
            )
            
            // Field with error
            FormField(
                title: "Username",
                placeholder: "Choose a username",
                text: .constant("j"),
                textContentType: .username,
                isSecureTextHidden: .constant(false),
                errorMessage: "Username must be at least 3 characters"
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
