//
//  WorkoutPreviewView.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 18/03/2025.
//

import SwiftUI
import Kingfisher

struct WorkoutPreviewView: View {
    @Binding var selectedExercises: [Exercise]  // Use binding
    @Binding var selectedSetsCount: Int       // Use binding
    var onDismiss: () -> Void
    
    var body: some View {
        if selectedExercises.isEmpty {
            // Empty state view...
        } else {
            List {
                ForEach(selectedExercises) { exercise in
                    // Exercise row...
                }
                .onDelete { indexSet in
                    // Allow removing exercises from the list
                    selectedExercises.remove(atOffsets: indexSet)
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
}
