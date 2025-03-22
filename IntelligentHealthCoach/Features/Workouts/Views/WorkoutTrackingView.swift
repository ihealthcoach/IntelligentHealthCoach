//
//  WorkoutTrackingView.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 12/03/2025.
//

import SwiftUI
import Kingfisher

class WorkoutTrackingViewModel: ObservableObject {
    @Published var workout: Workout
    @Published var exercises: [Exercise] = []
    @Published var exerciseDetails: [WorkoutExerciseDetails] = []
    @Published var sets: [WorkoutSet] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let supabaseService: SupabaseServiceProtocol
    
    init(workout: Workout, exercises: [Exercise] = [], supabaseService: SupabaseServiceProtocol = SupabaseService.shared) {
        self.workout = workout
        self.supabaseService = supabaseService
        
        // Use provided exercises if available, otherwise extract from workout
        if !exercises.isEmpty {
            self.exercises = exercises
            
            // Instead of directly creating WorkoutExerciseDetails objects, we'll use a simpler approach
            // to track which exercises are in the workout
            self.exerciseDetails = []  // Start with empty array
            
            // Add default sets for each exercise
            for exercise in exercises {
                let exerciseId = exercise.id
                let workoutExerciseDetailId = UUID().uuidString
                
                // Create sets for the exercise
                let newSets = (0..<3).map { _ in  // Default 3 sets per exercise
                    WorkoutSet(
                        id: UUID().uuidString,
                        workoutExerciseDetailsId: workoutExerciseDetailId,
                        weight: 0,
                        type: "normal",
                        reps: 0,
                        completed: false,
                        createdAt: Date(),
                        updatedAt: Date()
                    )
                }
                
                // Add to the sets collection
                self.sets.append(contentsOf: newSets)
            }
            
            isLoading = false
        } else {
            loadWorkoutData()
        }
    }
    
    func loadWorkoutData() {
        isLoading = true
        
        Task {
            // Extract exercises from the workout if available
            if let exercises = workout.exercises {
                await MainActor.run {
                    self.exercises = exercises
                    self.isLoading = false
                }
            } else {
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
    
    func addExercise(_ exercise: Exercise) {
        if !exercises.contains(where: { $0.id == exercise.id }) {
            exercises.append(exercise)
        }
    }
    
    func addSet(for detail: WorkoutExerciseDetails) {
        let newSet = WorkoutSet(
            id: UUID().uuidString,
            workoutExerciseDetailsId: detail.id,
            weight: 0,
            type: "normal",
            reps: 0,
            completed: false,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        sets.append(newSet)
    }
    
    func updateSet(_ set: WorkoutSet, weight: Double? = nil, reps: Int? = nil) {
        if let index = sets.firstIndex(where: { $0.id == set.id }) {
            var updatedSet = set
            
            if let weight = weight {
                updatedSet = WorkoutSet(
                    id: set.id,
                    workoutExerciseDetailsId: set.workoutExerciseDetailsId,
                    weight: weight,
                    type: set.type,
                    reps: set.reps,
                    completed: set.completed,
                    createdAt: set.createdAt,
                    updatedAt: Date()
                )
            }
            
            if let reps = reps {
                updatedSet = WorkoutSet(
                    id: set.id,
                    workoutExerciseDetailsId: set.workoutExerciseDetailsId,
                    weight: set.weight,
                    type: set.type,
                    reps: reps,
                    completed: set.completed,
                    createdAt: set.createdAt,
                    updatedAt: Date()
                )
            }
            
            sets[index] = updatedSet
        }
    }
    
    func toggleSetCompletion(_ set: WorkoutSet) {
        if let index = sets.firstIndex(where: { $0.id == set.id }) {
            let updatedSet = WorkoutSet(
                id: set.id,
                workoutExerciseDetailsId: set.workoutExerciseDetailsId,
                weight: set.weight,
                type: set.type,
                reps: set.reps,
                completed: !set.completed,
                createdAt: set.createdAt,
                updatedAt: Date()
            )
            
            sets[index] = updatedSet
        }
    }
    
    func finishWorkout() {
        workout = Workout(
            id: workout.id,
            userId: workout.userId,
            title: workout.title,
            exercises: workout.exercises,
            createdAt: workout.createdAt,
            updatedAt: Date(),
            status: "completed"
        )
    }
    
    func isSuperset(_ exercise: Exercise) -> Bool {
        // Placeholder for superset functionality - will be implemented later
        return false
    }
}


struct WorkoutTrackingView: View {
    @ObservedObject var viewModel: WorkoutTrackingViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingFinishConfirmation = false
    @State private var timerActive = false
    @State private var timeElapsed: TimeInterval = 0
    @State private var timer: Timer?
    @State private var selectedExerciseIndex = 0
    @State private var showingSetInput = false
    @State private var selectedSetIndex: Int?
    @State private var currentWeight: String = ""
    @State private var currentReps: String = ""
    @State private var showingExerciseGuide = false
    @State private var showingPreviousStats = false
    @State private var showingOneRepMax = false
    @State private var showingNotes = false
    @State private var dragOffset = CGSize.zero
    @State private var showingWorkoutOptions = false
    
    var body: some View {
        ZStack {
            Color("gray50").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with navigation and timer
                workoutHeader
                
                if !viewModel.exercises.isEmpty {
                    // Exercise content with swipe gesture
                    GeometryReader { geometry in
                        exerciseContent
                            .offset(x: dragOffset.width, y: 0)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        dragOffset = gesture.translation
                                    }
                                    .onEnded { gesture in
                                        let threshold = geometry.size.width * 0.4
                                        if gesture.translation.width > threshold {
                                            // Swipe right - previous exercise
                                            if selectedExerciseIndex > 0 {
                                                withAnimation {
                                                    selectedExerciseIndex -= 1
                                                    dragOffset = .zero
                                                }
                                            } else {
                                                withAnimation {
                                                    dragOffset = .zero
                                                }
                                            }
                                        } else if gesture.translation.width < -threshold {
                                            // Swipe left - next exercise
                                            if selectedExerciseIndex < viewModel.exercises.count - 1 {
                                                withAnimation {
                                                    selectedExerciseIndex += 1
                                                    dragOffset = .zero
                                                }
                                            } else {
                                                withAnimation {
                                                    dragOffset = .zero
                                                }
                                            }
                                        } else {
                                            // Reset if threshold not met
                                            withAnimation {
                                                dragOffset = .zero
                                            }
                                        }
                                    }
                            )
                    }
                } else {
                    // Empty state
                    VStack {
                        Spacer()
                        Text("No exercises in this workout")
                            .font(.headline)
                            .foregroundColor(.gray)
                            
                        Button("Return to Exercise Library") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .padding()
                        
                        Spacer()
                    }
                }
            }
            
            // Bottom toolbar
            VStack {
                Spacer()
                toolbarView
                    .padding(.bottom, 30)
            }
            
            // Set input overlay
            if showingSetInput, let setIndex = selectedSetIndex {
                setInputOverlay(setIndex: setIndex)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            startTimer()
        }
        .onDisappear {
            pauseTimer()
        }
        .sheet(isPresented: $showingExerciseGuide) {
            exerciseGuideSheet
        }
        .sheet(isPresented: $showingPreviousStats) {
            previousStatsSheet
        }
        .sheet(isPresented: $showingOneRepMax) {
            oneRepMaxSheet
        }
        .sheet(isPresented: $showingNotes) {
            notesSheet
        }
        .alert(isPresented: $showingFinishConfirmation) {
            Alert(
                title: Text("Finish Workout"),
                message: Text("Are you sure you want to finish this workout?"),
                primaryButton: .default(Text("Save & Finish")) {
                    finishWorkout()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    // MARK: - View Components
    
    var workoutHeader: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    showingFinishConfirmation = true
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20))
                        .foregroundColor(Color("gray900"))
                }
                
                Spacer()
                
                HStack(spacing: 6) {
                    Text("Exercise")
                        .font(.system(size: 16))
                        .foregroundColor(Color("gray400"))
                    
                    Text("\(selectedExerciseIndex + 1) of \(viewModel.exercises.count)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color("gray900"))
                }
                
                Spacer()
                
                Button(action: {
                    // Show workout options
                    showingWorkoutOptions = true
                }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20))
                        .foregroundColor(Color("gray900"))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(height: 48)
            
            // Timer display
            HStack {
                Text(formattedElapsedTime())
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color("gray400"))
                
                Spacer()
                
                Button(action: {
                    if timerActive {
                        pauseTimer()
                    } else {
                        startTimer()
                    }
                }) {
                    Image(systemName: timerActive ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(timerActive ? .orange : .green)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(Color("gray50"))
        .background(.ultraThinMaterial)
    }
    
    var exerciseContent: some View {
        let exercise = viewModel.exercises[selectedExerciseIndex]
        let exerciseDetail = viewModel.exerciseDetails.first(where: { $0.exerciseId == exercise.id }) ?? viewModel.exerciseDetails[selectedExerciseIndex]
        let sets = viewModel.sets.filter { $0.workoutExerciseDetailsId == exerciseDetail.id }
        let completedSets = sets.filter { $0.completed }.count
        
        return ScrollView {
            VStack(spacing: 16) {
                // Exercise header with title and progress
                VStack(spacing: 8) {
                    TitleView(
                        title: exercise.name ?? "Unnamed Exercise",
                        subtitle: "\(completedSets) of \(sets.count) sets completed"
                    )
                    
                    if viewModel.isSuperset(exercise) {
                        HStack {
                            Spacer()
                            
                            Text("Superset")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.offwhite)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 4)
                                .background(Color("gray900"))
                                .cornerRadius(20)
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    Text("Exercise note...")
                        .font(.system(size: 11))
                        .foregroundColor(Color("gray400"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                }
                
                // Sets list
                VStack(spacing: 0) {
                    ForEach(Array(sets.enumerated()), id: \.element.id) { index, set in
                        WorkoutSetRow(
                            setNumber: String(format: "%02d", index + 1),
                            weight: set.weight > 0 ? String(format: "%.1f", set.weight) : "-",
                            reps: set.reps > 0 ? "\(set.reps)" : "-",
                            isCompleted: set.completed,
                            isActive: selectedSetIndex == index && !set.completed
                        )
                        .onTapGesture {
                            if !set.completed {
                                selectedSetIndex = index
                                currentWeight = set.weight > 0 ? String(format: "%.1f", set.weight) : ""
                                currentReps = set.reps > 0 ? "\(set.reps)" : ""
                                showingSetInput = true
                            } else {
                                // Maybe allow editing completed sets with a confirmation?
                            }
                        }
                    }
                }
                
                // Add set button
                Button(action: {
                    viewModel.addSet(for: exerciseDetail)
                }) {
                    HStack {
                        Spacer()
                        Text("Add set")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color("gray700"))
                        
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color("gray700"))
                        Spacer()
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 20)
                    .background(Color("offwhite"))
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color("gray200"), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            .padding(.top, 16)
            .padding(.bottom, 120) // Space for toolbar
        }
    }
    
    var toolbarView: some View {
        HStack(spacing: 16) {
            toolbarButton(icon: "info.circle", title: "Exercise guide") {
                showingExerciseGuide = true
            }
            toolbarButton(icon: "waveform.path.ecg", title: "Previous stats") {
                showingPreviousStats = true
            }
            toolbarButton(icon: "chart.bar", title: "One Rep Max") {
                showingOneRepMax = true
            }
            toolbarButton(icon: "note.text", title: "Notes") {
                showingNotes = true
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(Color("gray900"))
        .cornerRadius(999)
    }
    
    func toolbarButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.system(size: 9))
                    .foregroundColor(.white)
            }
            .frame(width: 60, height: 41)
        }
    }
    
    func setInputOverlay(setIndex: Int) -> some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                HStack {
                    Text("Set \(setIndex + 1)")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button(action: {
                        showingSetInput = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                HStack(spacing: 20) {
                    VStack(spacing: 8) {
                        Text("Weight (kg)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        TextField("0.0", text: $currentWeight)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 20, weight: .bold))
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color("gray100"))
                            .cornerRadius(8)
                            .frame(width: 120)
                    }
                    
                    VStack(spacing: 8) {
                        Text("Reps")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        TextField("0", text: $currentReps)
                            .keyboardType(.numberPad)
                            .font(.system(size: 20, weight: .bold))
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color("gray100"))
                            .cornerRadius(8)
                            .frame(width: 120)
                    }
                }
                
                Button(action: {
                    saveSet(setIndex: setIndex)
                    showingSetInput = false
                }) {
                    Text("Save Set")
                        .font(.headline)
                        .foregroundColor(.offwhite)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("indigo600"))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .disabled(currentWeight.isEmpty || currentReps.isEmpty)
                .opacity((currentWeight.isEmpty || currentReps.isEmpty) ? 0.5 : 1)
            }
            .padding(.vertical, 20)
            .background(Color.offwhite)
            .cornerRadius(16, corners: [.topLeft, .topRight])
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
        }
        .background(Color.black.opacity(0.4).ignoresSafeArea().onTapGesture {
            showingSetInput = false
        })
    }
    
    // MARK: - Sheet Views
    
    var exerciseGuideSheet: some View {
        let exercise = viewModel.exercises[selectedExerciseIndex]
        return FlexibleSheet(title: "Exercise Guide") {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        ExerciseGIF(
                            gifUrl: exercise.gifUrl,
                            size: CGSize(width: 150, height: 150)
                        )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(exercise.name ?? "Unnamed Exercise")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            if let muscleGroup = exercise.muscleGroup {
                                Text("Target: \(muscleGroup)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            if let equipment = exercise.equipment {
                                Text("Equipment: \(equipment)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    Text("Instructions")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    if let instructions = exercise.instructions {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(instructions.components(separatedBy: "\n").indices, id: \.self) { index in
                                let step = instructions.components(separatedBy: "\n")[index]
                                HStack(alignment: .top) {
                                    Text("\(index + 1).")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .frame(width: 30, alignment: .leading)
                                    
                                    Text(step)
                                        .font(.subheadline)
                                }
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        Text("No instructions available for this exercise.")
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                }
                .padding(.bottom, 40)
            }
        }
    }
    
    var previousStatsSheet: some View {
        let exercise = viewModel.exercises[selectedExerciseIndex]
        return FlexibleSheet(title: "Previous Stats") {
            VStack(alignment: .leading, spacing: 16) {
                Text("Stats for \(exercise.name ?? "Unnamed Exercise")")
                    .font(.headline)
                    .padding(.horizontal)
                
                Text("Your previous workout data will appear here.")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                Spacer()
            }
        }
    }
    
    var oneRepMaxSheet: some View {
        let exercise = viewModel.exercises[selectedExerciseIndex]
        return FlexibleSheet(title: "One Rep Max") {
            VStack(alignment: .leading, spacing: 16) {
                Text("\(exercise.name ?? "Unnamed Exercise") 1RM")
                    .font(.headline)
                    .padding(.horizontal)
                
                Text("Your one rep max estimates will appear here.")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                Spacer()
            }
        }
    }
    
    var notesSheet: some View {
        let exercise = viewModel.exercises[selectedExerciseIndex]
        return FlexibleSheet(title: "Exercise Notes") {
            VStack {
                Text("Notes for \(exercise.name ?? "Unnamed Exercise")")
                    .font(.headline)
                    .padding(.bottom, 10)
                
                TextEditor(text: .constant(""))
                    .frame(height: 200)
                    .padding(10)
                    .background(Color("gray100"))
                    .cornerRadius(8)
                
                Button(action: {
                    // Save notes
                }) {
                    Text("Save Notes")
                        .font(.headline)
                        .foregroundColor(.offwhite)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("indigo600"))
                        .cornerRadius(8)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Helper functions
    
    private func saveSet(setIndex: Int) {
        let exerciseDetails = viewModel.exerciseDetails[selectedExerciseIndex]
        let sets = viewModel.sets.filter { $0.workoutExerciseDetailsId == exerciseDetails.id }
        
        if setIndex < sets.count {
            let set = sets[setIndex]
            let weight = Double(currentWeight.replacingOccurrences(of: ",", with: ".")) ?? 0
            let reps = Int(currentReps) ?? 0
            
            viewModel.updateSet(set, weight: weight, reps: reps)
            viewModel.toggleSetCompletion(set)
        }
    }
    
    private func startTimer() {
        timerActive = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.timeElapsed += 1
        }
    }
    
    private func pauseTimer() {
        timerActive = false
        timer?.invalidate()
        timer = nil
    }
    
    private func formattedElapsedTime() -> String {
        let hours = Int(timeElapsed) / 3600
        let minutes = Int(timeElapsed) % 3600 / 60
        let seconds = Int(timeElapsed) % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    private func finishWorkout() {
        pauseTimer()
        viewModel.finishWorkout()
        presentationMode.wrappedValue.dismiss()
    }
}


// Preview
struct WorkoutTrackingView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock workout
        let mockWorkout = Workout(
            id: "preview-workout-id",
            userId: "preview-user-id",
            title: "Upper Body Workout",
            exercises: [],
            createdAt: Date(),
            updatedAt: Date(),
            status: "active"
        )
        
        let viewModel = WorkoutTrackingViewModel(workout: mockWorkout)
        
        // Add sample exercise
        let exercise = Exercise(
            id: "1",
            name: "Arnold Press",
            exerciseType: "Strength",
            primaryMuscles: "Shoulders,Triceps",
            secondaryMuscles: "Trapezius",
            instructions: "Start with the dumbbells at shoulder height.\nRotate your palms as you press upward.\nSlowly lower and rotate back to starting position.",
            experienceLevel: "Intermediate",
            muscleGroup: "Shoulders",
            description: "The Arnold Press is a variation of the shoulder press that rotates the wrists during the movement.",
            benefits: "Improved shoulder development,Better range of motion",
            equipment: "Dumbbells",
            forceType: "Push",
            mechanics: "Compound",
            bodyPart: "Shoulders",
            target: "Deltoids",
            experience: "Intermediate",
            gifUrl: "https://fleiivpyjkvahakriuta.supabase.co/storage/v1/object/public/exercises/gifs/3_4_sit_up.gif"
        )
        
        viewModel.exercises = [exercise]
        
        // Remove the dummyDetails variable and PreviewExerciseDetails struct
        
        // Add mock sets for preview
        viewModel.sets = [
            WorkoutSet(
                id: "set1",
                workoutExerciseDetailsId: "dummy-id",
                weight: 41.3,
                type: "normal",
                reps: 20,
                completed: true,
                createdAt: Date(),
                updatedAt: Date()
            ),
            WorkoutSet(
                id: "set2",
                workoutExerciseDetailsId: "dummy-id",
                weight: 61.3,
                type: "normal",
                reps: 12,
                completed: true,
                createdAt: Date(),
                updatedAt: Date()
            ),
            WorkoutSet(
                id: "set3",
                workoutExerciseDetailsId: "dummy-id",
                weight: 76.3,
                type: "normal",
                reps: 8,
                completed: true,
                createdAt: Date(),
                updatedAt: Date()
            ),
            WorkoutSet(
                id: "set4",
                workoutExerciseDetailsId: "dummy-id",
                weight: 0,
                type: "normal",
                reps: 0,
                completed: false,
                createdAt: Date(),
                updatedAt: Date()
            ),
            WorkoutSet(
                id: "set5",
                workoutExerciseDetailsId: "dummy-id",
                weight: 0,
                type: "normal",
                reps: 0,
                completed: false,
                createdAt: Date(),
                updatedAt: Date()
            )
        ]
        
        // Remove the JSON decoding part for WorkoutExerciseDetails
        
        return WorkoutTrackingView(viewModel: viewModel)
    }
}
