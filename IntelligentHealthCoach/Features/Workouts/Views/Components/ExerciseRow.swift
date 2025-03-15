//
//  ExerciseRow.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// ExerciseRow.swift
import SwiftUI
import Kingfisher

struct ExerciseRow: View {
    var exercise: Exercise
    var isSelected: Bool = false
    
    var body: some View {
        HStack {
            KFImage(URL(string: exercise.gifUrl))
                .placeholder {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.2))
                        .frame(width: 60, height: 60)
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .cornerRadius(6)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(exercise.name ?? <#default value#>)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(exercise.primaryMuscles.joined(separator: ", "))
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if isSelected {
                Text("Added")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.indigo)
            } else {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
}
