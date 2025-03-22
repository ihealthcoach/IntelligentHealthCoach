//
//  WorkoutSetRow.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


import SwiftUI

struct WorkoutSetRow: View {
    let setNumber: String
    let weight: String
    let reps: String
    let isCompleted: Bool
    var isActive: Bool = false
    var isPR: Bool = false
    var showRPE: Bool = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(setNumber)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color("gray900"))
                    .frame(height: 23)
                
                Text("Standard set")
                    .font(.system(size: 11))
                    .foregroundColor(isActive && !isCompleted ? Color("gray200") : Color("gray400"))
                    .frame(height: 14)
            }
            .frame(width: 142, height: 37)
            
            Spacer()
            
            HStack(spacing: 8) {
                VStack(spacing: 0) {
                    Text(weight)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isActive && !isCompleted ? Color("gray200") : isCompleted ? Color("gray900") : Color("gray400"))
                        .frame(height: 23)
                    
                    Text("kg")
                        .font(.system(size: 11))
                        .foregroundColor(isActive && !isCompleted ? Color("gray200") : Color("gray400"))
                        .frame(height: 14)
                }
                .frame(width: 50, height: 37)
                
                Text("x")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isActive && !isCompleted ? Color("gray200") : Color("gray400"))
                    .padding(.top, 2)
                
                VStack(spacing: 0) {
                    Text(reps)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isActive && !isCompleted ? Color("gray200") : isCompleted ? Color("gray900") : Color("gray400"))
                        .frame(height: 23)
                    
                    Text("reps")
                        .font(.system(size: 11))
                        .foregroundColor(isActive && !isCompleted ? Color("gray200") : Color("gray400"))
                        .frame(height: 14)
                }
                .frame(width: 50, height: 37)
            }
            
            Spacer()
            
            if isPR {
                HStack(spacing: 4) {
                    Text("PR")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color("gray500"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color("gray200"), lineWidth: 1)
                        )
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color("indigo600"))
                }
            } else if showRPE {
                Text("RPE")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color("gray500"))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color("gray200"), lineWidth: 1)
                    )
            } else if isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color("indigo600"))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .frame(height: 57)
        .background(isActive ? Color("offwhite") : Color.clear)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color("gray200")),
            alignment: .bottom
        )
    }
}

#Preview {
    VStack {
        // Completed set
        WorkoutSetRow(
            setNumber: "01",
            weight: "41.3",
            reps: "20",
            isCompleted: true
        )
        
        // Active set
        WorkoutSetRow(
            setNumber: "02",
            weight: "-",
            reps: "-",
            isCompleted: false,
            isActive: true,
            showRPE: true
        )
        
        // Set with PR
        WorkoutSetRow(
            setNumber: "03",
            weight: "76.3",
            reps: "8",
            isCompleted: true,
            isPR: true
        )
    }
    .padding()
    .background(Color("gray50"))
}
