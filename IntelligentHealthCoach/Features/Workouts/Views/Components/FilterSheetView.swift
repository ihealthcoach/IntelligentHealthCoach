//
//  FilterSheetView.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 18/03/2025.
//

import SwiftUI
import Kingfisher

struct FilterSheetView: View {
    var onClose: () -> Void
    
    var body: some View {
        VStack {
            Text("Filters")
                .font(.title)
                .padding()
            
            Text("Filter options will be available here")
                .padding()
            
            Button("Close", action: onClose)
                .buttonStyle(PrimaryButtonStyle())
                .padding()
        }
        .presentationDetents([.medium])
    }
}
