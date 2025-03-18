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
            HStack(spacing: 10) {
                CategoryButton(
                    icon: "arrow.up.arrow.down",
                    label: "A-Z",
                    isSelected: selectedCategory == "A-Z"
                ) {
                    selectedCategory = "A-Z"
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
                    icon: "magnifyingglass",
                    label: "Search",
                    isSelected: selectedCategory == "Search"
                ) {
                    selectedCategory = "Search"
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 10)
    }
}
