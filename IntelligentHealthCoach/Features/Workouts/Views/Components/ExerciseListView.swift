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
    @Binding var selectedExerciseIds: Set<String>
    @Binding var scrollToLetter: String?
    var onToggleSelection: (Exercise) -> Void
    
    var body: some View {
        ZStack(alignment: .trailing) {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // Using List instead of ScrollView for better performance
                ScrollViewReader { scrollProxy in
                    List {
                        ForEach(Array(viewModel.exerciseGroups.keys.sorted()), id: \.self) { key in
                            if let exercises = viewModel.exerciseGroups[key], !exercises.isEmpty {
                                Section(header: Text(key)
                                    .font(.system(size: 36, weight: .semibold))
                                    .foregroundColor(Color("gray900"))
                                    .padding()
                                    .id(key)
                                    .listRowInsets(EdgeInsets())
                                    .background(Color("gray100"))
                                ) {
                                    ForEach(exercises) { exercise in
                                        ExerciseRow(
                                            exercise: exercise,
                                            isSelected: selectedExerciseIds.contains(exercise.id),
                                            onToggle: { onToggleSelection(exercise) }
                                        )
                                        .listRowSeparator(.hidden)
                                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .padding(.bottom, selectedExerciseIds.isEmpty ? 0 : 120)
                    .onChange(of: scrollToLetter) { oldValue, newValue in
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
                
                // Enhanced Alphabet selector
                EnhancedAlphabetSelector(
                    availableLetters: Set(viewModel.exerciseGroups.keys),
                    onLetterSelected: { letter in
                        scrollToLetter = letter
                    }
                )
            }
        }
    }
}
