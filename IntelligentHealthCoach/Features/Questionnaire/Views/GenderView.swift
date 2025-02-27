//
//  GenderView.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// GenderView.swift (Example of one questionnaire screen)
import SwiftUI

struct GenderView: View {
    @ObservedObject var viewModel: QuestionnaireViewModel
    var onContinue: () -> Void
    
    @State private var selectedGender: String? = nil
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 10) {
                Text("What is your")
                    .font(.system(size: 20, weight: .semibold))
                    .italic()
                    .foregroundColor(.teal.opacity(0.7))
                
                Text("Gender?")
                    .font(.system(size: 48, weight: .heavy))
                    .foregroundColor(.teal.opacity(0.9))
                    .padding(.bottom, 20)
                
                VStack(spacing: 10) {
                    GenderOptionCard(
                        title: "Male",
                        isSelected: selectedGender == "male",
                        action: {
                            selectedGender = "male"
                            viewModel.updateGender("male")
                        }
                    )
                    
                    GenderOptionCard(
                        title: "Female",
                        isSelected: selectedGender == "female",
                        action: {
                            selectedGender = "female"
                            viewModel.updateGender("female")
                        }
                    )
                    
                    GenderOptionCard(
                        title: "I'd rather not say",
                        isSelected: selectedGender == "unknown",
                        action: {
                            selectedGender = "unknown"
                            viewModel.updateGender("unknown")
                        }
                    )
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            // Continue button
            Button("Continue") {
                onContinue()
            }
            .buttonStyle(PrimaryButtonStyle(bgColor: .teal))
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
            .disabled(selectedGender == nil)
            .opacity(selectedGender == nil ? 0.6 : 1)
            
            Text("Already have an account? Sign in")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.teal.opacity(0.8))
                .padding(.bottom, 35)
        }
    }
}

struct GenderOptionCard: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.teal.opacity(0.9))
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.teal : Color.teal.opacity(0.6), lineWidth: 2)
                        .frame(width: 22, height: 22)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.teal)
                            .frame(width: 14, height: 14)
                    }
                }
            }
            .padding()
            .background(isSelected ? Color.teal.opacity(0.2) : Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.teal : Color.teal.opacity(0.6), lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}