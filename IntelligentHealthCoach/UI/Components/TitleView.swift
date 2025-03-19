//
//  TitleView.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 18/03/2025.
//

import SwiftUI

struct TitleView: View {
    var title: String
    var subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(Color(red: 0.067, green: 0.094, blue: 0.153))
            
            Text(subtitle)
                .font(.system(size: 14))
                .foregroundColor(Color(red: 0.612, green: 0.639, blue: 0.686))
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView(title: "Library", subtitle: "Add exercises to your workout")
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color("gray100"))
    }
}
