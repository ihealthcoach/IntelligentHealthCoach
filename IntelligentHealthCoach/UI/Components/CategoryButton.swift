//
//  CategoryButton.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 16/03/2025.
//

import SwiftUI

// Category/Filter button component with consistent styling
struct CategoryButton: View {
    var icon: String
    var label: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) { // 4px gap between icon and label
                Image(systemName: icon)
                    .font(.system(size: 20)) // 20x20 icon size
                
                Text(label)
                    .font(.system(size: 14, weight: .medium)) // Size 14, medium weight
            }
            .foregroundColor(isSelected ? .offoffwhite : Color("gray500")) // offoffwhite when selected, gray500 otherwise
            .padding(.vertical, 10) // 10px vertical padding
            .padding(.horizontal, 14) // 14px horizontal padding
            .background(isSelected ? Color("gray900") : Color("gray50")) // gray900 when selected, gray50 otherwise
            .cornerRadius(20)
        }
    }
}

// Preview for CategoryButton
struct CategoryButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Title for the preview
            Text("CategoryButton Component")
                .font(.headline)
                .padding(.bottom, 10)
            
            // Unselected buttons
            VStack(alignment: .leading, spacing: 10) {
                Text("Unselected state:")
                    .font(.subheadline)
                
                HStack(spacing: 10) {
                    CategoryButton(
                        icon: "arrow.up.arrow.down",
                        label: "A-Z",
                        isSelected: false,
                        action: {}
                    )
                    
                    CategoryButton(
                        icon: "clock",
                        label: "Recent",
                        isSelected: false,
                        action: {}
                    )
                    
                    CategoryButton(
                        icon: "heart",
                        label: "Favorites",
                        isSelected: false,
                        action: {}
                    )
                    
                    CategoryButton(
                        icon: "magnifyingglass",
                        label: "Search",
                        isSelected: false,
                        action: {}
                    )
                }
            }
            
            // Selected buttons
            VStack(alignment: .leading, spacing: 10) {
                Text("Selected state:")
                    .font(.subheadline)
                
                HStack(spacing: 10) {
                    CategoryButton(
                        icon: "arrow.up.arrow.down",
                        label: "A-Z",
                        isSelected: true,
                        action: {}
                    )
                    
                    CategoryButton(
                        icon: "clock",
                        label: "Recent",
                        isSelected: false,
                        action: {}
                    )
                    
                    CategoryButton(
                        icon: "heart",
                        label: "Favorites",
                        isSelected: false,
                        action: {}
                    )
                    
                    CategoryButton(
                        icon: "magnifyingglass",
                        label: "Search",
                        isSelected: false,
                        action: {}
                    )
                }
            }
            
            // Dark background to test appearance
            VStack(alignment: .leading, spacing: 10) {
                Text("On dark background:")
                    .font(.subheadline)
                
                HStack(spacing: 10) {
                    CategoryButton(
                        icon: "arrow.up.arrow.down",
                        label: "A-Z",
                        isSelected: true,
                        action: {}
                    )
                    
                    CategoryButton(
                        icon: "clock",
                        label: "Recent",
                        isSelected: false,
                        action: {}
                    )
                }
                .padding()
                .background(Color.gray.opacity(0.8))
                .cornerRadius(12)
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .background(Color.offoffwhite)
    }
}
