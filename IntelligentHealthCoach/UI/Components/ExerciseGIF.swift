//
//  ExerciseGIF.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 21/03/2025.
//

import SwiftUI
import Kingfisher

struct ExerciseGIF: View {
    var gifUrl: String?
    var size: CGSize
    var cornerRadius: CGFloat = 6
    
    var body: some View {
        if let gifUrlString = gifUrl, !gifUrlString.isEmpty, let gifUrl = URL(string: gifUrlString) {
            KFImage(gifUrl)
                .placeholder {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.2))
                        .frame(width: size.width, height: size.height)
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width, height: size.height)
                .blendMode(.multiply)
                .background(Color("gray50"))
                .cornerRadius(cornerRadius)
        } else {
            // Fallback icon when no GIF is available
            Image(systemName: "figure.run")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(12)
                .frame(width: size.width, height: size.height)
                .foregroundColor(.gray)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(cornerRadius)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    VStack(spacing: 20) {
        Text("Different sizes and states of ExerciseGIF")
            .font(.headline)
        
        HStack(spacing: 20) {
            // With valid GIF URL
            ExerciseGIF(
                gifUrl: "https://fleiivpyjkvahakriuta.supabase.co/storage/v1/object/public/exercises/gifs/3_4_sit_up.gif",
                size: CGSize(width: 100, height: 100)
            )
            
            // With nil URL (fallback icon)
            ExerciseGIF(
                gifUrl: nil,
                size: CGSize(width: 100, height: 100)
            )
        }
        
        HStack(spacing: 20) {
            // Small size
            ExerciseGIF(
                gifUrl: "https://fleiivpyjkvahakriuta.supabase.co/storage/v1/object/public/exercises/gifs/3_4_sit_up.gif",
                size: CGSize(width: 60, height: 60),
                cornerRadius: 8
            )
            
            // Medium size
            ExerciseGIF(
                gifUrl: "https://fleiivpyjkvahakriuta.supabase.co/storage/v1/object/public/exercises/gifs/3_4_sit_up.gif",
                size: CGSize(width: 120, height: 120),
                cornerRadius: 12
            )
        }
    }
    .padding()
}
