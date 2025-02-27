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
    
    let supabaseService = SupabaseService.shared
    
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
    
    func saveQuestionnaire() async throws {
        guard let userId = SupabaseService.shared.client.auth.session?.user?.id else {
            throw AuthError.sessionExpired
        }
        
        let data: [String: Any] = [
            "user_id": userId,
            "gender": questionnaire.gender ?? "",
            "goal": questionnaire.goal ?? "",
            "workout_days": questionnaire.workoutDays,
            "level": questionnaire.level ?? "",
            "weight": questionnaire.weight ?? 0,
            "height": questionnaire.height ?? 0,
            "age": questionnaire.age ?? 0,
            "bodytype": questionnaire.bodytype ?? ""
        ]
        
        try await SupabaseService.shared.client
            .from("profile")
            .insert(data)
            .execute()
    }
}