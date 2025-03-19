//
//  ExerciseListView.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 18/03/2025.
//

import SwiftUI
import Kingfisher

struct ExerciseListView: View {
    @ObservedObject var viewModel: ExerciseViewModel
    @ObservedObject var workoutBuilder: WorkoutBuilderViewModel
    @Binding var scrollToLetter: String?
    var onToggleSelection: (Exercise) -> Void
    
    var body: some View {
        ZStack(alignment: .trailing) {
            if viewModel.isLoading {
                loadingView
            } else {
                exerciseListContent
                
                // Alphabet selector
                alphabetSelector
            }
        }
    }
    
    // MARK: - Subviews
    
    private var loadingView: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var exerciseListContent: some View {
        ScrollViewReader { scrollProxy in
            exerciseList(scrollProxy: scrollProxy)
                .onChange(of: scrollToLetter) { oldValue, newValue in
                    handleLetterChange(scrollProxy: scrollProxy, oldValue: oldValue, newValue: newValue)
                }
        }
    }
    
    private func exerciseList(scrollProxy: ScrollViewProxy) -> some View {
        List {
            ForEach(Array(viewModel.exerciseGroups.keys.sorted()), id: \.self) { key in
                if let exercises = viewModel.exerciseGroups[key], !exercises.isEmpty {
                    exerciseSection(for: key, exercises: exercises)
                }
            }
        }
        .listStyle(.plain)
        .padding(.bottom, workoutBuilder.selectedExercises.isEmpty ? 0 : 120)
    }
    
    private func exerciseSection(for key: String, exercises: [Exercise]) -> some View {
        Section(header: sectionHeader(for: key)) {
            ForEach(exercises) { exercise in
                ExerciseRow(
                    exercise: exercise,
                    workoutBuilder: workoutBuilder,
                    onToggle: { onToggleSelection(exercise) }
                )
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            }
        }
    }
    
    private func sectionHeader(for key: String) -> some View {
        Text(key)
            .font(.system(size: 36, weight: .semibold))
            .foregroundColor(Color("gray900"))
            .padding()
            .id(key)
            .listRowInsets(EdgeInsets())
            .background(Color("gray100"))
    }
    
    private var alphabetSelector: some View {
        EnhancedAlphabetSelector(
            availableLetters: Set(viewModel.exerciseGroups.keys),
            onLetterSelected: { letter in
                scrollToLetter = letter
            }
        )
    }
    
    // MARK: - Helper Methods
    
    private func handleLetterChange(scrollProxy: ScrollViewProxy, oldValue: String?, newValue: String?) {
        if let letter = newValue {
            withAnimation {
                scrollProxy.scrollTo(letter, anchor: .top)
            }
            
            // Reset after scrolling
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                scrollToLetter = nil
            }
        }
    }
}

struct ExerciseListView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock viewModel for preview
        let mockViewModel = createMockViewModel()
        let workoutBuilder = WorkoutBuilderViewModel()
        
        ExerciseListView(
            viewModel: mockViewModel,
            workoutBuilder: workoutBuilder,
            scrollToLetter: .constant(nil),
            onToggleSelection: { _ in }
        )
        .previewLayout(.sizeThatFits)
        .frame(height: 600)
    }
    
    // Helper function to create a populated mock view model
    static func createMockViewModel() -> ExerciseViewModel {
        let viewModel = ExerciseViewModel()
        
        // Create mock exercises
        let mockExercises = [
            Exercise(
                id: "1",
                name: "Bench Press",
                exerciseType: "Strength",
                primaryMuscles: "Chest,Triceps",
                secondaryMuscles: "Shoulders",
                instructions: "Lie on a flat bench...",
                experienceLevel: "Intermediate",
                muscleGroup: "Chest",
                description: "The bench press is a compound exercise...",
                benefits: "Builds chest strength,Improves upper body power",
                equipment: "Barbell,Bench",
                forceType: "Push",
                mechanics: "Compound",
                bodyPart: "Chest",
                target: "Pecs",
                experience: "Intermediate"
            ),
            Exercise(
                id: "2",
                name: "Squat",
                exerciseType: "Strength",
                primaryMuscles: "Quadriceps,Glutes",
                secondaryMuscles: "Hamstrings,Lower back",
                instructions: "Stand with feet shoulder-width apart...",
                experienceLevel: "Intermediate",
                muscleGroup: "Legs",
                description: "The squat is a compound exercise...",
                benefits: "Builds leg strength,Improves core stability",
                equipment: "Barbell",
                forceType: "Push",
                mechanics: "Compound",
                bodyPart: "Legs",
                target: "Quadriceps",
                experience: "Intermediate"
            ),
            Exercise(
                id: "3",
                name: "Deadlift",
                exerciseType: "Strength",
                primaryMuscles: "Lower back,Glutes",
                secondaryMuscles: "Hamstrings,Traps",
                instructions: "Stand with feet hip-width apart...",
                experienceLevel: "Advanced",
                muscleGroup: "Back",
                description: "The deadlift is a compound exercise...",
                benefits: "Builds overall strength,Improves posture",
                equipment: "Barbell",
                forceType: "Pull",
                mechanics: "Compound",
                bodyPart: "Back",
                target: "Lower back",
                experience: "Advanced"
            )
        ]
        
        // Manually populate the exerciseGroups dictionary
        viewModel.exercises = mockExercises
        viewModel.filteredExercises = mockExercises
        
        // Organize exercises for the preview
        var groups: [String: [Exercise]] = [:]
        groups["B"] = [mockExercises[0]] // Bench Press
        groups["S"] = [mockExercises[1]] // Squat
        groups["D"] = [mockExercises[2]] // Deadlift
        viewModel.exerciseGroups = groups
        
        return viewModel
    }
}
