//
//  CategorySelectionView.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 18/03/2025.
//

import SwiftUI
import Kingfisher

struct CategorySelectionView: View {
    @Binding var selectedCategory: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                CategoryButton(
                    icon: "arrow.up.arrow.down",
                    label: "A-Z",
                    isSelected: selectedCategory == "A-Z"
                ) {
                    selectedCategory = "A-Z"
                }
                
                CategoryButton(
                    icon: "magnifyingglass",
                    label: "Search",
                    isSelected: selectedCategory == "Search"
                ) {
                    selectedCategory = "Search"
                }
                
                CategoryButton(
                    icon: "clock",
                    label: "Recent",
                    isSelected: selectedCategory == "Recent"
                ) {
                    selectedCategory = "Recent"
                }
                
                CategoryButton(
                    icon: "heart",
                    label: "Favorites",
                    isSelected: selectedCategory == "Favorites"
                ) {
                    selectedCategory = "Favorites"
                }
                
                CategoryButton(
                    icon: "clipboard",
                    label: "My exercises",
                    isSelected: selectedCategory == "My exercises"
                ) {
                    selectedCategory = "My exercises"
                }
            }
        }
    }
}

struct CategorySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CategorySelectionView(selectedCategory: .constant("A-Z"))
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color("gray100"))
    }
}
