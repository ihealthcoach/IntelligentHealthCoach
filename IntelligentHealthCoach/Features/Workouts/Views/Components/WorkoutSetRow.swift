//
//  WorkoutSetRow.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// WorkoutSetRow.swift
import SwiftUI

struct WorkoutSetRow: View {
    @ObservedObject var viewModel: WorkoutSetViewModel
    var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(String(format: "%02d", viewModel.setNumber))
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Text(viewModel.type)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                HStack(spacing: 16) {
                    VStack(alignment: .center, spacing: 0) {
                        Text("\(viewModel.weight, specifier: "%.1f")")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.primary)
                        
                        Text("kg")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.gray)
                    }
                    
                    Text("×")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .center, spacing: 0) {
                        Text("\(viewModel.reps)")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.primary)
                        
                        Text("reps")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                if viewModel.completed {
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                } else {
                    Text("RPE")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

class WorkoutSetViewModel: ObservableObject {
    var id: String
    @Published var setNumber: Int
    @Published var type: String
    @Published var weight: Double
    @Published var reps: Int
    @Published var completed: Bool
    
    init(set: Set) {
        self.id = set.id
        self.setNumber = set.id.hashValue % 100 // Placeholder for demo
        self.type = set.type
        self.weight = set.weight
        self.reps = set.reps
        self.completed = set.completed
    }
}