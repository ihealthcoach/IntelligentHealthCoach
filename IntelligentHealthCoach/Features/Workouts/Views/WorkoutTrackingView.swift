//
//  WorkoutTrackingView.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 12/03/2025.
//

// WorkoutTrackingView.swift
import SwiftUI
import Kingfisher

struct WorkoutTrackingView: View {
    @ObservedObject var viewModel: WorkoutTrackingViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingFinishConfirmation = false
    @State private var showingExerciseLibrary = false
    @State private var timerActive = false
    @State private var timeElapsed: TimeInterval = 0
    @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing: 0) {
            // Top bar with timer
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.workout.title ?? "Workout")
                        .font(.headline)
                    
                    Text(formattedElapsedTime())
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: {
                    if timerActive {
                        pauseTimer()
                    } else {
                        startTimer()
                    }
                }) {
                    Image(systemName: timerActive ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(timerActive ? .orange : .green)
                }
                
                Button(action: {
                    showingFinishConfirmation = true
                }) {
                    Text("Finish")
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.indigo)
                        .foregroundColor(.offwhite)
                        .cornerRadius(8)
                }
                .padding(.leading, 12)
            }
            .padding()
            .background(Color.offwhite)
            .shadow(color: Color.gray900.opacity(0.05), radius: 5, x: 0, y: 2)
            
            // Exercise list
            if viewModel.exercises.isEmpty {
                emptyWorkoutView
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(viewModel.exerciseDetails) { detail in
                            if let exercise = viewModel.exercises.first(where: { $0.id == detail.exerciseId }) {
                                exerciseCard(exercise: exercise, detail: detail)
                            }
                        }
                        
                        Button(action: {
                            showingExerciseLibrary = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.indigo)
                                
                                Text("Add Exercise")
                                    .foregroundColor(.indigo)
                                    .font(.system(size: 16, weight: .medium))
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color.indigo.opacity(0.1))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 100)
                    }
                    .padding(.top)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            showingFinishConfirmation = true
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.primary)
        })
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
        .sheet(isPresented: $showingExerciseLibrary) {
            ExerciseLibraryView(selectionMode: true, onExerciseSelected: { exercise in
                viewModel.addExercise(exercise)
                showingExerciseLibrary = false
            })
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            pauseTimer()
        }
    }
    
    var emptyWorkoutView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "dumbbell.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.7))
                .padding()
            
            Text("No exercises yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Add exercises to your workout to get started")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                showingExerciseLibrary = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Exercise")
                }
                .padding()
                .frame(width: 200)
                .background(Color.indigo)
                .foregroundColor(.offwhite)
                .cornerRadius(10)
            }
            .padding(.top, 10)
            
            Spacer()
        }
    }
    
    func exerciseCard(exercise: Exercise, detail: WorkoutExerciseDetails) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // Exercise header
            HStack {
                KFImage(URL(string: exercise.gifUrl ?? ""))
                    .placeholder {
                        Rectangle().foregroundColor(.gray.opacity(0.2))
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(exercise.name ?? "Unnamed Exercise")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text(exercise.muscleGroup ?? "Unknown Muscle Group")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Menu {
                    Button(action: {
                        // Add set
                        viewModel.addSet(for: detail)
                    }) {
                        Label("Add set", systemImage: "plus")
                    }
                    
                    Button(action: {
                        // View exercise details
                    }) {
                        Label("Exercise details", systemImage: "info.circle")
                    }
                    
                    Button(role: .destructive, action: {
                        // Remove exercise
                        viewModel.removeExercise(detail)
                    }) {
                        Label("Remove exercise", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 22))
                        .foregroundColor(.gray)
                        .padding(8)
                }
            }
            
            // Sets list
            VStack(spacing: 5) {
                // Header row
                HStack {
                    Text("SET")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.gray)
                        .frame(width: 40, alignment: .center)
                    
                    Text("PREVIOUS")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                    
                    Text("KG")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.gray)
                        .frame(width: 60)
                    
                    Text("REPS")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.gray)
                        .frame(width: 60)
                    
                    Text("")
                        .frame(width: 40)
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                
                // Sets
                let sets = viewModel.sets.filter { $0.workoutExerciseDetailsId == detail.id }
                
                ForEach(sets) { set in
                    setRow(set: set, index: sets.firstIndex(where: { $0.id == set.id }) ?? 0)
                }
                
                Button(action: {
                    viewModel.addSet(for: detail)
                }) {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("Add Set")
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.indigo)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(Color.indigo.opacity(0.1))
                    .cornerRadius(8)
                }
                .padding(.top, 5)
                .padding(.horizontal, 10)
            }
            .background(Color.gray.opacity(0.05))
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
    
    func setRow(set: WorkoutSet, index: Int) -> some View {
        HStack {
            Text("\(index + 1)")
                .font(.system(size: 14, weight: .semibold))
                .frame(width: 40, alignment: .center)
            
            Text("--") // Previous would be populated from history
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity)
            
            TextField("0", text: Binding(
                get: { String(format: "%.1f", set.weight) },
                set: { newValue in
                    if let newWeight = Double(newValue) {
                        viewModel.updateSet(set, weight: newWeight)
                    }
                }
            ))
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.center)
            .frame(width: 60)
            .padding(.vertical, 5)
            .background(Color.offwhite)
            .cornerRadius(6)
            
            TextField("0", text: Binding(
                get: { String(set.reps) },
                set: { newValue in
                    if let newReps = Int(newValue) {
                        viewModel.updateSet(set, reps: newReps)
                    }
                }
            ))
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .frame(width: 60)
            .padding(.vertical, 5)
            .background(Color.offwhite)
            .cornerRadius(6)
            
            Button(action: {
                viewModel.toggleSetCompletion(set)
            }) {
                Image(systemName: set.completed ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(set.completed ? .green : .gray)
            }
            .frame(width: 40)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(set.completed ? Color.green.opacity(0.1) : Color.clear)
        .cornerRadius(8)
    }
    
    // Timer functions
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

// View Model
class WorkoutTrackingViewModel: ObservableObject {
    @Published var workout: Workout
    @Published var exercises: [Exercise] = []
    @Published var exerciseDetails: [WorkoutExerciseDetails] = []
    @Published var sets: [WorkoutSet] = []
    @Published var isLoading = false
    
    private let supabaseService: SupabaseServiceProtocol
    
    init(workout: Workout, supabaseService: SupabaseServiceProtocol = SupabaseService.shared) {
        self.workout = workout
        self.supabaseService = supabaseService
        
        loadWorkoutData()
    }
    
    func loadWorkoutData() {
        isLoading = true
        
        Task {
            do {
                // Make a throwing call to fetch data
                // For example:
                // let details = try await supabaseService.fetchWorkoutDetails(workoutId: workout.id)
                
                // Since we're just using mock data for now, we can comment out the throwing calls
                // and just set loading to false
                
                // Simulate a delay
                try await Task.sleep(nanoseconds: 1_000_000_000)
                
                await MainActor.run {
                    self.isLoading = false
                }
            } catch {
                print("Error loading workout data: \(error)")
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
    
    func addExercise(_ exercise: Exercise) {
        Task {
            do {
                // Create workout exercise details
                let details = try await supabaseService.createWorkoutExerciseDetails(
                    workoutId: workout.id,
                    exerciseId: exercise.id
                )
                
                // Add a default set
                let defaultSet = WorkoutSet(
                    id: UUID().uuidString,
                    workoutExerciseDetailsId: details.id,
                    weight: 0,
                    type: "Normal",
                    reps: 0,
                    completed: false,
                    createdAt: Date(),
                    updatedAt: Date()
                )
                
                await MainActor.run {
                    self.exercises.append(exercise)
                    self.exerciseDetails.append(details)
                    self.sets.append(defaultSet)
                }
            } catch {
                print("Error adding exercise: \(error)")
            }
        }
    }
    
    func removeExercise(_ detail: WorkoutExerciseDetails) {
        // Remove the exercise details and associated sets
        exerciseDetails.removeAll { $0.id == detail.id }
        sets.removeAll { $0.workoutExerciseDetailsId == detail.id }
        exercises.removeAll { $0.id == detail.exerciseId }
        
        // In a real app, you would also delete this from your backend
    }
    
    func addSet(for detail: WorkoutExerciseDetails) {
        let newSet = WorkoutSet(
            id: UUID().uuidString,
            workoutExerciseDetailsId: detail.id,
            weight: 0,
            type: "Normal",
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
            
            // In a real app, you would update this in your backend
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
            
            // In a real app, you would update this in your backend
        }
    }
    
    func finishWorkout() {
        // Update workout status to completed
        workout = Workout(
            id: workout.id,
            userId: workout.userId,
            title: workout.title,
            exercises: workout.exercises,
            createdAt: workout.createdAt,
            updatedAt: Date(),
            status: "completed"
        )
        
        // In a real app, you would update this in your backend
    }
}

struct WorkoutTrackingView_Previews: PreviewProvider {
    static var previews: some View {
        let mockWorkout = Workout(
            id: "preview-workout-id",
            userId: "preview-user-id",
            title: "Upper Body Workout",
            exercises: [],
            createdAt: Date(),
            updatedAt: Date(),
            status: "active"
        )
        
        let mockViewModel = WorkoutTrackingViewModel(workout: mockWorkout)
        mockViewModel.exercises = [
            Exercise(
                id: "ex1",
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
                experience: "Intermediate",
                gifUrl: "https://fleiivpyjkvahakriuta.supabase.co/storage/v1/object/public/exercises/gifs/decline_bench_press.gif"
            )
        ]
        
        return WorkoutTrackingView(viewModel: mockViewModel)
    }
}
