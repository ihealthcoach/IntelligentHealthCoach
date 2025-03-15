//
//  ExerciseLibraryView.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// ExerciseLibraryView.swift
import SwiftUI
import Kingfisher

struct ExerciseLibraryView: View {
    @StateObject var viewModel = ExerciseViewModel()
    @State private var selectedCategory = "A-Z"
    @State private var showingFilters = false
    
    var selectionMode: Bool = false
    var onExerciseSelected: ((Exercise) -> Void)? = nil
    let categories = ["A-Z", "Recent", "Favorites", "My workouts"]
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search exercises...", text: $viewModel.searchQuery)
                        .onChange(of: viewModel.searchQuery) { oldValue, newValue in
                            viewModel.filterExercises()
                        }
                    
                    if !viewModel.searchQuery.isEmpty {
                        Button(action: {
                            viewModel.searchQuery = ""
                            viewModel.filterExercises()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Category selection
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                HStack {
                                    if category == "A-Z" {
                                        Image(systemName: "arrow.up.arrow.down")
                                            .font(.system(size: 12))
                                    } else if category == "Recent" {
                                        Image(systemName: "clock")
                                            .font(.system(size: 12))
                                    } else if category == "Favorites" {
                                        Image(systemName: "heart")
                                            .font(.system(size: 12))
                                    } else if category == "My workouts" {
                                        Image(systemName: "list.clipboard")
                                            .font(.system(size: 12))
                                    }
                                    
                                    Text(category)
                                        .font(.system(size: 14, weight: .medium))
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .foregroundColor(selectedCategory == category ? .white : .gray)
                                .background(selectedCategory == category ? Color.black : Color.white)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: selectedCategory == category ? 0 : 1)
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 10)
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else {
                    // Exercise list by alphabet
                    HStack(alignment: .top, spacing: 0) {
                        // Main list
                        List {
                            ForEach(Array(viewModel.exerciseGroups.keys.sorted()), id: \.self) { key in
                                Section(header: Text(key)
                                    .font(.system(size: 36, weight: .semibold))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.trailing)
                                    .listRowInsets(EdgeInsets())
                                ) {
                                    ForEach(viewModel.exerciseGroups[key] ?? [], id: \.id) { exercise in
                                        if selectionMode {
                                            Button(action: {
                                                onExerciseSelected?(exercise)
                                            }) {
                                                ExerciseRow(exercise: exercise)
                                            }
                                        } else {
                                            NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                                                ExerciseRow(exercise: exercise)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        
                        // Alphabet index
                        ScrollView {
                            VStack(spacing: 2) {
                                ForEach(["#"] + (65...90).map { String(UnicodeScalar($0)) }, id: \.self) { letter in
                                    Button(action: {
                                        scrollToLetter(letter)
                                    }) {
                                        Text(letter)
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(viewModel.exerciseGroups.keys.contains(letter) ? .gray : .gray.opacity(0.3))
                                            .frame(width: 20, height: 20)
                                    }
                                }
                            }
                            .padding(.vertical)
                        }
                        .frame(width: 30)
                    }
                }
            }
            .navigationTitle("Library")
            .navigationBarItems(
                leading: Button(action: { }) {
                    Image(systemName: "arrow.left")
                },
                trailing: Button(action: {
                    showingFilters.toggle()
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.black)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                        )
                }
            )
            .sheet(isPresented: $showingFilters) {
                ExerciseFiltersView(isPresented: $showingFilters)
            }
            .onAppear {
                viewModel.fetchExercises()
            }
        }
    }
    
    func scrollToLetter(_ letter: String) {
        // This would be implemented with UIKit coordination
        // to scroll to the appropriate section
        print("Scroll to letter: \(letter)")
    }
}

struct ExerciseFiltersView: View {
    @Binding var isPresented: Bool
    @State private var exerciseType = "All"
    @State private var muscleGroup = "Middle Back"
    @State private var equipment = "All"
    @State private var forceType = "All"
    @State private var mechanics = "All"
    @State private var experience = "Intermediate"
    @State private var exercisesAdded = 4
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("Exercise type")
                        .font(.system(size: 16, weight: .medium))
                    
                    Spacer()
                    
                    Text(exerciseType)
                        .foregroundColor(.gray)
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("Muscle group")
                        .font(.system(size: 16, weight: .medium))
                    
                    Spacer()
                    
                    Text(muscleGroup)
                        .foregroundColor(.gray)
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("Equipment")
                        .font(.system(size: 16, weight: .medium))
                    
                    Spacer()
                    
                    Text(equipment)
                        .foregroundColor(.gray)
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("Force type")
                        .font(.system(size: 16, weight: .medium))
                    
                    Spacer()
                    
                    Text(forceType)
                        .foregroundColor(.gray)
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("Mechanics")
                        .font(.system(size: 16, weight: .medium))
                    
                    Spacer()
                    
                    Text(mechanics)
                        .foregroundColor(.gray)
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("Experience")
                        .font(.system(size: 16, weight: .medium))
                    
                    Spacer()
                    
                    Text(experience)
                        .foregroundColor(.gray)
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("Exercises added")
                        .font(.system(size: 16, weight: .medium))
                    
                    Spacer()
                    
                    Text("\(exercisesAdded)")
                        .foregroundColor(.gray)
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Exercise filters")
            .navigationBarItems(
                trailing: Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark")
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                }
            )
        }
    }
}


#Preview {
    ExerciseLibraryView()
}
