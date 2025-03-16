//
//  ExerciseLibraryView.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


import SwiftUI
import Kingfisher

struct ExerciseLibraryView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = ExerciseViewModel()
    @State private var selectedCategory = "A-Z"
    @State private var selectedExerciseIds: Set<String> = []
    @State private var showingSetsSheet = false
    @State private var scrollToLetter: String? = nil
    
    private let letters = ["#"] + (65...90).map { String(UnicodeScalar($0)) }
    
    var selectionMode: Bool = true
    var onExerciseSelected: ((Exercise) -> Void)? = nil
    
    var body: some View {
        ZStack {
            // Main content
            VStack(spacing: 0) {
                // Header row
                HStack {
                    // Back button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    // View workout button
                    Button(action: {
                        // Will implement later
                    }) {
                        HStack(spacing: 2) {
                            Text("View workout")
                                .font(.system(size: 14))
                            
                            Image(systemName: "chevron.down")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(.gray)
                    }
                    
                    // Add exercise button
                    Button(action: {
                        // Will implement later
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                            .padding(8)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    
                    // Done button
                    Button(action: {
                        // Will implement later - finalize workout
                    }) {
                        HStack {
                            Text("Done")
                            Image(systemName: "checkmark")
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color(.darkText))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                // Title and description
                VStack(alignment: .leading, spacing: 4) {
                    Text("Library")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("Add exercises to your workout")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom, 16)
                
                // Category selection with our new component
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        // A-Z category
                        CategoryButton(
                            icon: "arrow.up.arrow.down",
                            label: "A-Z",
                            isSelected: selectedCategory == "A-Z"
                        ) {
                            selectedCategory = "A-Z"
                        }
                        
                        // Recent category
                        CategoryButton(
                            icon: "clock",
                            label: "Recent",
                            isSelected: selectedCategory == "Recent"
                        ) {
                            selectedCategory = "Recent"
                        }
                        
                        // Favorites category
                        CategoryButton(
                            icon: "heart",
                            label: "Favorites",
                            isSelected: selectedCategory == "Favorites"
                        ) {
                            selectedCategory = "Favorites"
                        }
                        
                        // Search category
                        CategoryButton(
                            icon: "magnifyingglass",
                            label: "Search",
                            isSelected: selectedCategory == "Search"
                        ) {
                            selectedCategory = "Search"
                            // Will implement search functionality later
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 10)
                
                // Exercise list with alphabet index
                ZStack(alignment: .trailing) {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        // Main scrollable exercise list
                        ScrollViewReader { scrollProxy in
                            ScrollView {
                                LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                                    ForEach(Array(viewModel.exerciseGroups.keys.sorted()), id: \.self) { key in
                                        if let exercises = viewModel.exerciseGroups[key], !exercises.isEmpty {
                                            Section(header:
                                                HStack {
                                                    Spacer()
                                                Text(key)
                                                    .font(.system(size: 36, weight: .semibold))
                                                    .foregroundColor(Color("gray900"))
                                                    .padding()
                                                    .id(key) //
                                                }
                                            ) {
                                                ForEach(exercises) { exercise in
                                                    ExerciseRow(
                                                        exercise: exercise,
                                                        isSelected: selectedExerciseIds.contains(exercise.id),
                                                        onToggle: { toggleExerciseSelection(exercise) }
                                                    )
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.bottom, selectedExerciseIds.isEmpty ? 0 : 120) // Add padding if buttons should appear
                            }
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
                        
                        // Alphabet selector using our new component
                        AlphabetSelector(
                            availableLetters: Set(viewModel.exerciseGroups.keys),
                            onLetterSelected: { letter in
                                scrollToLetter = letter
                            }
                        )
                    }
                }
                
                Spacer(minLength: 0)
            }
            
            // Bottom action buttons (conditionally shown)
            if !selectedExerciseIds.isEmpty {
                VStack {
                    Spacer()
                    
                    VStack(spacing: 8) {
                        // Add exercises button
                        Button(action: {
                            showingSetsSheet = true
                        }) {
                            Text("Add \(selectedExerciseIds.count > 1 ? "\(selectedExerciseIds.count) exercises" : "exercise")")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color("gray900"))
                                .cornerRadius(8)
                        }
                        
                        // Build Super Set button (only if more than 1 exercise selected)
                        if selectedExerciseIds.count > 1 {
                            Button(action: {
                                // Will implement later
                            }) {
                                Text("Build Super Set")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16, corners: [.topLeft, .topRight])
                    .shadow(color: Color.black.opacity(0.1), radius: 4, y: -2)
                }
            }
            
            // Exercise count indicator (bottom right)
            if !selectedExerciseIds.isEmpty {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 40, height: 40)
                            
                            Text("\(selectedExerciseIds.count)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding()
                        .padding(.bottom, selectedExerciseIds.isEmpty ? 16 : 100) // Adjust based on buttons
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.fetchExercises()
        }
        .sheet(isPresented: $showingSetsSheet) {
            // We'll implement this sets selection sheet later
            Text("Select number of sets")
                .presentationDetents([.medium])
        }
    }
    
    // Helper function to toggle exercise selection
    private func toggleExerciseSelection(_ exercise: Exercise) {
        if selectedExerciseIds.contains(exercise.id) {
            selectedExerciseIds.remove(exercise.id)
        } else {
            selectedExerciseIds.insert(exercise.id)
        }
    }
}

// Preview for development
struct ExerciseLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseLibraryView()
    }
}
