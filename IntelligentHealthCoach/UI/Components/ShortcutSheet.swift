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
                        ShortcutItem(icon: "dumbbell.fill", title: "Start a workout", showChevron: true) {
                            // Handle action
                            presentationMode.wrappedValue.dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                onStartWorkout?()
                            }
                        }
                        
                        ShortcutItem(icon: "figure.arms.open", title: "Add body metrics", showChevron: true) {
                            // Handle action
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                        ShortcutItem(icon: "ruler", title: "Preferred units", value: "Metric/kg", showChevron: true) {
                            // Handle action
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                        ShortcutItem(icon: "timer", title: "Rest timer", value: "45 sec", showChevron: true) {
                            // Handle action
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                        ShortcutItem(icon: "plus.circle", title: "Add exercise", showChevron: true) {
                            // Handle action
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
                        ShortcutItem(icon: "book.closed", title: "Browse recipes", showChevron: true) {
                            // Handle action
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                        ShortcutItem(icon: "doc.plaintext", title: "Add recipe", showChevron: true) {
                            // Handle action
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                        ShortcutItem(icon: "barcode.viewfinder", title: "Scan barcode", showChevron: true) {
                            // Handle action
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
                        ShortcutItem(icon: "arrow.left.arrow.right", title: "Connect apps", showChevron: true) {
                            // Handle action
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                        ShortcutItem(icon: "moon", title: "Dark mode", hasToggle: true, isToggled: $isDarkModeEnabled) {
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
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(Color("gray900"))
            .padding(.horizontal, 24)
    }
}

// Shortcut item component
struct ShortcutItem: View {
    var icon: String
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
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(Color("gray900"))
                    .frame(width: 24, height: 24)
                
                // Title
                Text(title)
                    .font(.system(size: 16))
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
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
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
