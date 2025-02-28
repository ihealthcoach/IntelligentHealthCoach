//
//  QuestionnaireViewModel.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// QuestionnaireViewModel.swift
import SwiftUI
import Combine

class QuestionnaireViewModel: ObservableObject {
    @Published var questionnaire = Questionnaire()
    @Published var currentProgress: Double = 12.5 // Starting progress
    @Published var currentStep = 1
    @Published var totalSteps = 8 // Total number of steps in questionnaire
    
    private let supabaseService: SupabaseServiceProtocol
    
    init(supabaseService: SupabaseServiceProtocol = SupabaseService.shared) {
        self.supabaseService = supabaseService
    }
    
    func incrementProgress() {
        let incrementValue: Double = 100.0 / Double(totalSteps)
        currentProgress += incrementValue
        currentStep += 1
    }
    
    func decrementProgress() {
        let decrementValue: Double = 100.0 / Double(totalSteps)
        currentProgress -= decrementValue
        currentStep -= 1
    }
    
    func updateGender(_ gender: String) {
        questionnaire.gender = gender
    }
    
    func updateGoal(_ goal: String) {
        questionnaire.goal = goal
    }
    
    func updateWorkoutDays(_ days: [Int]) {
        questionnaire.workoutDays = days
    }
    
    func updateLevel(_ level: String) {
        questionnaire.level = level
    }
    
    func updateWeight(_ weight: Int) {
        questionnaire.weight = weight
    }
    
    func updateHeight(_ height: Int) {
        questionnaire.height = height
    }
    
    func updateAge(_ age: Int) {
        questionnaire.age = age
    }
    
    func updateBodyType(_ bodyType: String) {
        questionnaire.bodytype = bodyType
    }
    
    // Create an encodable struct for questionnaire data - KEEP THIS AT CLASS LEVEL
    private struct QuestionnaireData: Encodable {
        let user_id: String
        let gender: String
        let main_goal: String  // Changed from goal to match the renamed column
        let workout_days: [Int]
        let level: String
        let weight: Int
        let height: Int
        let age: Int
        let body_type: String  // Changed from bodytype to match the renamed column
    }

    func saveQuestionnaire() async throws {
        guard let userId = supabaseService.client.auth.session?.user?.id else {
            throw AuthError.sessionExpired
        }
        
        let data = QuestionnaireData(
            user_id: userId,
            gender: questionnaire.gender ?? "",
            main_goal: questionnaire.goal ?? "",  // Use questionnaire.goal but map to main_goal field
            workout_days: questionnaire.workoutDays,
            level: questionnaire.level ?? "",
            weight: questionnaire.weight ?? 0,
            height: questionnaire.height ?? 0,
            age: questionnaire.age ?? 0,
            body_type: questionnaire.bodytype ?? ""  // Use questionnaire.bodytype but map to body_type field
        )
        
        // Change from "profile" to "profiles"
        let _ = try await supabaseService.client
            .from("profiles")
            .insert(data)
            .execute()
    }
}
