//
//  WorkoutBuilderViewModel.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 18/03/2025.
//

import SwiftUI
import Kingfisher

// Create a shared WorkoutBuilderViewModel
class WorkoutBuilderViewModel: ObservableObject {
    @Published var selectedExercises: [Exercise] = []
    @Published var defaultSetsCount: Int = 3
    
    func addExercise(_ exercise: Exercise) {
        // Don't add if already exists
        if !selectedExercises.contains(where: { $0.id == exercise.id }) {
            selectedExercises.append(exercise)
        }
    }
    
    func removeExercise(_ exercise: Exercise) {
        selectedExercises.removeAll(where: { $0.id == exercise.id })
    }
    
    func removeExercise(at indexSet: IndexSet) {
        selectedExercises.remove(atOffsets: indexSet)
    }
    
    func containsExercise(id: String) -> Bool {
        return selectedExercises.contains(where: { $0.id == id })
    }
}
