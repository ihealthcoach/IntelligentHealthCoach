//
//  ExerciseDetailView.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 12/03/2025.
//

// ExerciseDetailView.swift
import SwiftUI
import Kingfisher

struct ExerciseDetailView: View {
    var exercise: Exercise
    @State private var isAdded = false
    @State private var showFullDescription = false
    @State private var currentStep = 1
    @State private var showingAddToWorkoutSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Exercise title and info
                VStack(alignment: .leading, spacing: 5) {
                    Text(exercise.name ?? "Unnamed Exercise")
                        .font(.system(size: 36, weight: .bold))
                    
                    Button(action: {
                        withAnimation {
                            showFullDescription.toggle()
                        }
                    }) {
                        (Text(exercise.description ?? "No description available")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            + Text(showFullDescription ? " Read less" : " Read more")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black))
                            .lineLimit(showFullDescription ? nil : 2)
                    }
                }
                .padding(.horizontal)
                
                // Exercise type info card
                HStack {
                    VStack(spacing: 10) {
                        VStack(spacing: 5) {
                            Text("Exercise type")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            
                            Text(exercise.exerciseType ?? "Unknown")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.indigo)
                        }
                        
                        VStack(spacing: 5) {
                            Text("Primary muscle group")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            
                            Text(exercise.primaryMusclesArray.joined(separator: ", "))
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.indigo)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack(spacing: 10) {
                        VStack(spacing: 5) {
                            Text("Equipment")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            
                            Text(exercise.equipmentArray.joined(separator: ", "))
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.indigo)
                        }
                        
                        VStack(spacing: 5) {
                            Text("Secondary muscle group")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            
                            Text(exercise.secondaryMusclesArray.joined(separator: ", "))
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.indigo)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                
                // Exercise demonstration
                HStack(spacing: 0) {
                    KFImage(URL(string: exercise.gifUrl))
                        .placeholder {
                            Rectangle()
                                .foregroundColor(.gray.opacity(0.2))
                                .overlay(
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                )
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width / 2)
                    
                    // Muscle diagram placeholder
                    ZStack {
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.1))
                            .frame(width: UIScreen.main.bounds.width / 2)
                        
                        Text("Muscle Diagram")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .frame(height: 180)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                
                // How to section with step navigation
                VStack(alignment: .leading, spacing: 15) {
                    Text("How to")
                        .font(.system(size: 24, weight: .semibold))
                    
                    // Step counter and navigation
                    let instructionsArray = exercise.instructionsArray
                    if !instructionsArray.isEmpty {
                        HStack {
                            Button(action: {
                                withAnimation {
                                    if currentStep > 1 {
                                        currentStep -= 1
                                    }
                                }
                            }) {
                                Image(systemName: "arrow.left.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(currentStep > 1 ? .indigo : .gray.opacity(0.3))
                            }
                            
                            Spacer()
                            
                            Text("Step \(currentStep) of \(instructionsArray.count)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    if currentStep < instructionsArray.count {
                                        currentStep += 1
                                    }
                                }
                            }) {
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(currentStep < instructionsArray.count ? .indigo : .gray.opacity(0.3))
                            }
                        }
                        .padding(.vertical, 10)
                        
                        // Current step instruction
                        if instructionsArray.indices.contains(currentStep - 1) {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(alignment: .top) {
                                    Text("\(currentStep).")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.indigo)
                                        .frame(width: 25, alignment: .leading)
                                    
                                    Text(instructionsArray[currentStep - 1])
                                        .font(.system(size: 16))
                                        .foregroundColor(.primary)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding()
                                .background(Color.indigo.opacity(0.1))
                                .cornerRadius(10)
                            }
                        }
                        
                        // All steps (collapsed)
                        DisclosureGroup("View all steps") {
                            VStack(alignment: .leading, spacing: 15) {
                                ForEach(Array(instructionsArray.enumerated()), id: \.offset) { index, instruction in
                                    HStack(alignment: .top, spacing: 10) {
                                        Text("\(index + 1).")
                                            .font(.system(size: 16))
                                            .foregroundColor(.gray)
                                            .frame(width: 25, alignment: .leading)
                                        
                                        Text(instruction)
                                            .font(.system(size: 16))
                                            .foregroundColor(.gray)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    .padding(.vertical, 5)
                                }
                            }
                            .padding(.top, 10)
                        }
                        .accentColor(.indigo)
                        .padding(.top, 10)
                    } else {
                        Text("No instructions available for this exercise.")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                // Benefits section
                let benefitsArray = exercise.benefitsArray
                if !benefitsArray.isEmpty {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Benefits")
                            .font(.system(size: 24, weight: .semibold))
                        
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(benefitsArray, id: \.self) { benefit in
                                HStack(alignment: .top, spacing: 10) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    
                                    Text(benefit)
                                        .font(.system(size: 16))
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Action buttons
                VStack(spacing: 10) {
                    Button(action: {
                        showingAddToWorkoutSheet = true
                    }) {
                        HStack {
                            Image(systemName: "plus")
                                .font(.system(size: 16))
                            
                            Text("Add exercise to workout")
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle(bgColor: .indigo))
                    
                    Button(action: {
                        isAdded.toggle()
                    }) {
                        HStack {
                            Image(systemName: isAdded ? "heart.fill" : "heart")
                                .font(.system(size: 16))
                            
                            Text(isAdded ? "Remove from favorites" : "Add to favorites")
                        }
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
                .padding(.horizontal)
                .padding(.vertical, 20)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingAddToWorkoutSheet) {
                AddToWorkoutSheet(exercise: exercise)
            }
        }
    }
}

                            // Add to Workout Sheet
struct AddToWorkoutSheet: View {
    @Environment(\.presentationMode) var presentationMode
    var exercise: Exercise
    @State private var workoutName = ""
    @State private var selectedWorkoutId: String? = nil
    @State private var showNewWorkoutField = false
    @State private var isLoading = false
    
    // Mock workouts for demonstration
    let workouts = [
        ("Current Workout", "12345"),
        ("Upper Body", "23456"),
        ("Lower Body", "34567"),
        ("Full Body", "45678")
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header with exercise info
                HStack {
                    KFImage(URL(string: exercise.gifUrl))
                        .placeholder {
                            Rectangle()
                                .foregroundColor(.gray.opacity(0.2))
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .cornerRadius(6)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(exercise.name ?? "Unnamed Exercise")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Text(exercise.muscleGroup ?? "Unknown Muscle Group")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                                            
                                            Divider()
                                            
                                            // Select workout section
                                            VStack(alignment: .leading, spacing: 15) {
                                                Text("Select Workout")
                                                    .font(.headline)
                                                    .padding(.horizontal)
                                                
                                                ScrollView {
                                                    VStack(spacing: 12) {
                                                        ForEach(workouts, id: \.1) { workout in
                                                            Button(action: {
                                                                selectedWorkoutId = workout.1
                                                                showNewWorkoutField = false
                                                            }) {
                                                                HStack {
                                                                    Text(workout.0)
                                                                        .foregroundColor(.primary)
                                                                    
                                                                    Spacer()
                                                                    
                                                                    if selectedWorkoutId == workout.1 {
                                                                        Image(systemName: "checkmark.circle.fill")
                                                                            .foregroundColor(.green)
                                                                    }
                                                                }
                                                                .padding()
                                                                .background(
                                                                    RoundedRectangle(cornerRadius: 10)
                                                                        .fill(selectedWorkoutId == workout.1 ? Color.green.opacity(0.1) : Color.gray.opacity(0.1))
                                                                )
                                                            }
                                                        }
                                                        
                                                        Button(action: {
                                                            showNewWorkoutField = true
                                                            selectedWorkoutId = nil
                                                        }) {
                                                            HStack {
                                                                Image(systemName: "plus.circle.fill")
                                                                    .foregroundColor(.indigo)
                                                                
                                                                Text("Create New Workout")
                                                                    .foregroundColor(.indigo)
                                                                
                                                                Spacer()
                                                                
                                                                if showNewWorkoutField {
                                                                    Image(systemName: "checkmark.circle.fill")
                                                                        .foregroundColor(.indigo)
                                                                }
                                                            }
                                                            .padding()
                                                            .background(
                                                                RoundedRectangle(cornerRadius: 10)
                                                                    .fill(showNewWorkoutField ? Color.indigo.opacity(0.1) : Color.gray.opacity(0.1))
                                                            )
                                                        }
                                                        
                                                        if showNewWorkoutField {
                                                            TextField("Workout Name", text: $workoutName)
                                                                .padding()
                                                                .background(Color.gray.opacity(0.1))
                                                                .cornerRadius(10)
                                                                .padding(.top, 8)
                                                        }
                                                    }
                                                    .padding(.horizontal)
                                                }
                                                
                                                Spacer()
                                                
                                                // Add button
                                                Button(action: {
                                                    isLoading = true
                                                    // Simulate adding to workout
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                        isLoading = false
                                                        presentationMode.wrappedValue.dismiss()
                                                    }
                                                }) {
                                                    HStack {
                                                        Text("Add to Workout")
                                                        
                                                        if isLoading {
                                                            ProgressView()
                                                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                                                .padding(.leading, 5)
                                                        }
                                                    }
                                                }
                                                .buttonStyle(PrimaryButtonStyle())
                                                .padding(.horizontal)
                                                .disabled(selectedWorkoutId == nil && (showNewWorkoutField && workoutName.isEmpty) || isLoading)
                                                .opacity((selectedWorkoutId == nil && (showNewWorkoutField && workoutName.isEmpty) || isLoading) ? 0.6 : 1)
                                            }
                                        }
                                        .navigationTitle("Add to Workout")
                                        .navigationBarItems(
                                            trailing: Button("Cancel") {
                                                presentationMode.wrappedValue.dismiss()
                                            }
                                        )
                                    }
                                }
                            }

#Preview {
    ExerciseDetailView(exercise: Exercise(
        id: "1",
        name: "Bench Press",
        exerciseType: "Strength",
        primaryMuscles: "Chest,Triceps",
        secondaryMuscles: "Shoulders",
        instructions: "Lie on a flat bench with your feet flat on the floor.\nGrip the barbell slightly wider than shoulder-width apart.\nUnrack the barbell and lower it to your mid-chest.\nPress the barbell back up to starting position.\nRepeat for desired repetitions.",
        experienceLevel: "Intermediate",
        muscleGroup: "Chest",
        description: "The bench press is a compound exercise that primarily targets the pectoralis major and triceps.",
        benefits: "Builds chest strength,Improves upper body power",
        equipment: "Barbell,Bench",
        forceType: "Push",
        mechanics: "Compound",
        bodyPart: "Chest",
        target: "Pecs",
        experience: "Intermediate"
    ))
}
