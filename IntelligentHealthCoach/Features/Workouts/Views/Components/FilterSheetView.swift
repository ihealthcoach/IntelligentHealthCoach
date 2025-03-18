//
//  FilterSheetView.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 18/03/2025.
//

import SwiftUI

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

struct FilterSheetView_Previews: PreviewProvider {
    static var previews: some View {
        FilterSheetView(onClose: {})
            .previewLayout(.sizeThatFits)
    }
}
