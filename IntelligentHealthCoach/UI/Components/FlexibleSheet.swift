//
//  FlexibleSheet.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 16/03/2025.
//

// IntelligentHealthCoach/UI/Components/FlexibleSheet.swift

import SwiftUI

struct FlexibleSheet<Content: View>: View {
    @Environment(\.presentationMode) var presentationMode
    var title: String
    var showCloseButton: Bool = true
    var showTopDragIndicator: Bool = true
    var showBottomDragIndicator: Bool = true
    var content: Content
    
    init(
        title: String,
        showCloseButton: Bool = true,
        showTopDragIndicator: Bool = true,
        showBottomDragIndicator: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.showCloseButton = showCloseButton
        self.showTopDragIndicator = showTopDragIndicator
        self.showBottomDragIndicator = showBottomDragIndicator
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Top drag indicator
            if showTopDragIndicator {
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color("gray300"))
                    .frame(width: 48, height: 5)
                    .padding(.top, 24)
                    .padding(.bottom, 24)
            }
            
            // Header with title and close button
            HStack {
                Text(title)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(Color("gray900"))
                
                Spacer()
                
                if showCloseButton {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color("gray900"))
                            .padding(12)
                            .background(Color("gray100"))
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            
            // Content
            content
                .frame(maxWidth: .infinity)
            
            // Bottom drag indicator
            if showBottomDragIndicator {
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color("black"))
                    .frame(width: 134, height: 5)
                    .padding(.vertical, 16)
            }
        }
        .background(Color("White"))
        .cornerRadius(20, corners: [.topLeft, .topRight])
    }
}

// Extension to apply cornerRadius to specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// MARK: - Common Sheet Components

// Button for workout action sheets (for Image 1)
struct SheetActionButton: View {
    var title: String
    var action: () -> Void
    var showArrow: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                
                if showArrow {
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color("gray400"))
                        .font(.system(size: 16))
                }
            }
        }
        .tertiaryStyle()
    }
}

// Option button for metrics sheets (for Image 2)
struct SheetOptionButton: View {
    var title: String
    var subtitle: String
    var isSelected: Bool = false
    var showArrow: Bool = false
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(isSelected ? Color("gray900") : Color.gray.opacity(0.5))
                    
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(Color.gray.opacity(0.5))
                }
                
                Spacer()
                
                if showArrow {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color("gray900"))
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
        }
        .buttonStyle(PlainButtonStyle())
        .background(isSelected ? Color.white : Color.clear)
    }
}

// MARK: - Preview Examples

// Example 1: Workout sheet (as in Image 1)
struct WorkoutSheetPreview: View {
    var body: some View {
        FlexibleSheet(title: "Workouts") {
            VStack(spacing: 0) {
                SheetActionButton(title: "Track a workout") {
                    print("Track a workout tapped")
                }
                
                SheetActionButton(title: "Workout history") {
                    print("Workout history tapped")
                }
                
                SheetActionButton(title: "My workout templates") {
                    print("My workout templates tapped")
                }
                
                SheetActionButton(title: "Find a workout") {
                    print("Find a workout tapped")
                }
                
                Spacer()
            }
            .padding(.top, 8)
        }
    }
}

// Example 2: Body metric sheet (as in Image 2)
struct BodyMetricSheetPreview: View {
    var body: some View {
        FlexibleSheet(title: "Add a body metric") {
            VStack(spacing: 0) {
                SheetOptionButton(
                    title: "Weight",
                    subtitle: "Update your body weight",
                    isSelected: false
                ) {
                    print("Weight option tapped")
                }
                
                Divider().padding(.leading, 24)
                
                SheetOptionButton(
                    title: "Measurements",
                    subtitle: "Update body measurements",
                    isSelected: true,
                    showArrow: true
                ) {
                    print("Measurements option tapped")
                }
                
                Divider().padding(.leading, 24)
                
                SheetOptionButton(
                    title: "Fat percentage",
                    subtitle: "Update body fat percentage",
                    isSelected: false
                ) {
                    print("Fat percentage option tapped")
                }
                
                Divider().padding(.leading, 24)
                
                SheetOptionButton(
                    title: "Number",
                    subtitle: "Update numbers",
                    isSelected: false
                ) {
                    print("Number option tapped")
                }
                
                Spacer()
                
                Button("Continue") {
                    print("Continue tapped")
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(24)
            }
        }
    }
}

// Example 3: Exercise details sheet (simplified version of Image 3)
struct ExerciseDetailsSheetPreview: View {
    var body: some View {
        FlexibleSheet(title: "Exercise guide") {
            VStack(alignment: .leading, spacing: 16) {
                Text("Arnold press")
                    .font(.system(size: 24, weight: .bold))
                
                Image("exercise_placeholder") // Placeholder image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 150)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                Text("How to")
                    .font(.system(size: 18, weight: .bold))
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("1. Start from the chest with your palms facing your body")
                    Text("2. Twist your forearms outwards as you move the weight upwards")
                    Text("3. Slowly lower the weights back to the starting position")
                }
                .font(.system(size: 14))
                .padding(.horizontal)
                
                Spacer()
                
                Button("Save") {
                    print("Save tapped")
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 24)
        }
    }
}

// MARK: - Preview Provider
struct FlexibleSheet_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview for Workout Sheet (Image 1)
            ZStack {
                Color("white").edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    WorkoutSheetPreview()
                }
            }
            .previewDisplayName("Workout Sheet")
            
            // Preview for Body Metric Sheet (Image 2)
            ZStack {
                Color.gray.opacity(0.3).edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    BodyMetricSheetPreview()
                }
            }
            .previewDisplayName("Body Metric Sheet")
            
            // Preview for Exercise Details Sheet (Image 3 simplified)
            ZStack {
                Color.gray.opacity(0.3).edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    ExerciseDetailsSheetPreview()
                }
            }
            .previewDisplayName("Exercise Details Sheet")
        }
    }
}
