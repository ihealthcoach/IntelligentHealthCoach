// WorkoutsView.swift
import SwiftUI

struct WorkoutsView: View {
    @StateObject var viewModel = WorkoutViewModel()
    @State private var showingExerciseLibrary = false
    @State private var showingCreateWorkout = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorMessage {
                    errorView(message: error)
                } else if viewModel.workouts.isEmpty {
                    emptyStateView
                } else {
                    workoutListView
                }
            }
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingCreateWorkout = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.primary)
                    }
                }
            }
            .sheet(isPresented: $showingExerciseLibrary) {
                ExerciseLibraryView()
            }
            .sheet(isPresented: $showingCreateWorkout) {
                CreateWorkoutView(viewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.fetchWorkouts()
        }
    }
    
    // Error view
    func errorView(message: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("Something went wrong")
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Try Again") {
                viewModel.fetchWorkouts()
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // Empty state view
    var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "dumbbell.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray)
                .padding()
            
            Text("No workouts yet")
                .font(.headline)
            
            Text("Start tracking your fitness journey by creating your first workout")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            VStack(spacing: 16) {
                Button("Create Workout") {
                    showingCreateWorkout = true
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Button("Browse Exercise Library") {
                    showingExerciseLibrary = true
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            .padding(.top, 20)
            .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // Workout list view
    var workoutListView: some View {
        VStack(spacing: 16) {
            // Quick action buttons
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    quickActionButton(title: "Track Workout", icon: "plus", action: {
                        showingCreateWorkout = true
                    })
                    
                    quickActionButton(title: "Exercise Library", icon: "list.bullet", action: {
                        showingExerciseLibrary = true
                    })
                    
                    quickActionButton(title: "Statistics", icon: "chart.bar.fill", action: {
                        // Show statistics
                    })
                    
                    quickActionButton(title: "My Routines", icon: "calendar", action: {
                        // Show routines
                    })
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 8)
            
            // Workouts list
            List {
                Section(header: Text("Recent Workouts")) {
                    ForEach(viewModel.workouts) { workout in
                        NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                            WorkoutRowView(workout: workout)
                        }
                    }
                }
                
                if !viewModel.templates.isEmpty {
                    Section(header: Text("My Templates")) {
                        ForEach(viewModel.templates) { template in
                            NavigationLink(destination: TemplateDetailView(template: template)) {
                                TemplateRowView(template: template)
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
    
    // Quick action button
    func quickActionButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.indigo)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.primary)
            }
            .frame(width: 100, height: 80)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}

// Workout row view
struct WorkoutRowView: View {
    var workout: Workout
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon or thumbnail
            ZStack {
                Circle()
                    .fill(Color.indigo.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "dumbbell.fill")
                    .foregroundColor(.indigo)
                    .font(.system(size: 20))
            }
            
            // Workout info
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.title ?? "Workout")
                    .font(.system(size: 16, weight: .semibold))
                
                HStack(spacing: 12) {
                    Label("\(workout.exercises?.count ?? 0) exercises", systemImage: "list.bullet")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    Label(formattedDate(workout.createdAt), systemImage: "calendar")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // Status indicator
            if workout.status == "completed" {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else if workout.status == "active" {
                Image(systemName: "hourglass")
                    .foregroundColor(.orange)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

// Template row view (placeholder for now)
struct TemplateRowView: View {
    var template: WorkoutTemplate
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon or thumbnail
            ZStack {
                Circle()
                    .fill(Color.purple.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "star.fill")
                    .foregroundColor(.purple)
                    .font(.system(size: 20))
            }
            
            // Template info
            VStack(alignment: .leading, spacing: 4) {
                Text(template.name)
                    .font(.system(size: 16, weight: .semibold))
                
                HStack(spacing: 12) {
                    Label("\(template.exerciseCount) exercises", systemImage: "list.bullet")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    Label(template.intensity, systemImage: "flame.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// Placeholder views for linked destinations
struct WorkoutDetailView: View {
    var workout: Workout
    
    var body: some View {
        Text("Workout Detail View - Coming Soon")
            .navigationTitle(workout.title ?? "Workout")
    }
}

struct TemplateDetailView: View {
    var template: WorkoutTemplate
    
    var body: some View {
        Text("Template Detail View - Coming Soon")
            .navigationTitle(template.name)
    }
}

struct CreateWorkoutView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var workoutName = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Workout Details")) {
                    TextField("Workout Name", text: $workoutName)
                    
                    // More fields can be added here
                }
                
                Section {
                    Button("Create Workout") {
                        viewModel.createWorkout(name: workoutName)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(workoutName.isEmpty)
                }
            }
            .navigationTitle("New Workout")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}


#Preview {
    WorkoutsView()
        .environmentObject(AuthViewModel.preview)
}
