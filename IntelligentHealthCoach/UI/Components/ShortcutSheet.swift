//
//  ShortcutSheet.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 16/03/2025.
//

import SwiftUI

struct ShortcutSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isDarkModeEnabled = false
    @Binding var showWorkoutSheet: Bool
    var onStartWorkout: (() -> Void)? = nil
    
    var body: some View {
        FlexibleSheet(title: "Shortcuts") {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Workout section
                    ShortcutSectionHeader(title: "Workout")
                    
                    VStack(spacing: 0) {
                        ShortcutItem(iconName: "dumbbell", title: "Start a workout", showChevron: true) {
                            presentationMode.wrappedValue.dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                onStartWorkout?()
                            }
                        }
                        
                        ShortcutItem(iconName: "ruler-outline", title: "Add body metrics", showChevron: true) {
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                        ShortcutItem(iconName: "calculator-outline", title: "Preferred units", value: "Metric/kg", showChevron: true) {
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                        ShortcutItem(iconName: "clock-outline", title: "Rest timer", value: "45 sec", showChevron: true) {
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                        ShortcutItem(iconName: "plus-circle-outline", title: "Add exercise", showChevron: true) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .background(Color("gray50"))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("gray200"), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    
                    // Food section
                    ShortcutSectionHeader(title: "Food")
                    
                    VStack(spacing: 0) {
                        ShortcutItem(iconName: "chefs-hat", title: "Browse recipes", showChevron: true) {
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                        ShortcutItem(iconName: "note-add-outline", title: "Add recipe", showChevron: true) {
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                        ShortcutItem(iconName: "barcode-outline", title: "Scan barcode", showChevron: true) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .background(Color("gray50"))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("gray200"), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    
                    // More section
                    ShortcutSectionHeader(title: "More")
                    
                    VStack(spacing: 0) {
                        ShortcutItem(iconName: "arrows-right-left-outline", title: "Connect apps", showChevron: true) {
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                        ShortcutItem(
                            iconName: isDarkModeEnabled ? "sun-outline" : "moon-outline",
                            title: isDarkModeEnabled ? "Light mode" : "Dark mode",
                            hasToggle: true,
                            isToggled: $isDarkModeEnabled
                        ) {
                            // Toggle is handled by the binding
                        }
                    }
                    .background(Color("gray50"))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("gray200"), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    
                    // Add some bottom padding for better scrolling
                    Spacer().frame(height: 24)
                }
            }
        }
    }
}

// Section header component
struct ShortcutSectionHeader: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(Color("gray900"))
            .padding(.horizontal, 16)
    }
}

// Shortcut item component
struct ShortcutItem: View {
    var iconName: String
    var title: String
    var value: String? = nil
    var showChevron: Bool = false
    var hasToggle: Bool = false
    var isToggled: Binding<Bool>? = nil
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color("gray900"))
                
                // Title
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color("gray900"))
                
                Spacer()
                
                // Optional value text
                if let value = value {
                    Text(value)
                        .font(.system(size: 16))
                        .foregroundColor(Color("gray400"))
                }
                
                // Toggle or chevron
                if hasToggle, let isToggled = isToggled {
                    Toggle("", isOn: isToggled)
                        .labelsHidden()
                } else if showChevron {
                    Image("chevron-right-mini")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color("gray400"))
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Preview
struct ShortcutSheet_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("offwhite").edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                ShortcutSheet(showWorkoutSheet: .constant(false))
            }
        }
    }
}
