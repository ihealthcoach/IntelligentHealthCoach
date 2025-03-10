//
//  ProgressBar.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


// ProgressBar.swift
import SwiftUI

struct ProgressBar: View {
    var progress: Double
    var color: Color = .blue
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: 6)
                    .opacity(0.3)
                    .foregroundColor(color)
                
                Rectangle()
                    .frame(width: min(CGFloat(self.progress) * geometry.size.width, geometry.size.width), height: 6)
                    .foregroundColor(color)
                    .animation(.linear, value: progress)
            }
            .cornerRadius(3.0)
        }
    }
}