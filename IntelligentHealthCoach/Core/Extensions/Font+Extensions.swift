//
//  Font+Extensions.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 16/03/2025.
//

// IntelligentHealthCoach/Core/Extensions/Font+Extensions.swift

import SwiftUI
import UIKit

extension UIFont {
    static func registerInterFonts() {
        // Register the Inter variable fonts
        if let interVarFontURL = Bundle.main.url(forResource: "Inter-VariableFont_opsz,wght", withExtension: "ttf"),
           let interItalicVarFontURL = Bundle.main.url(forResource: "Inter-Italic-VariableFont_opsz,wght", withExtension: "ttf") {
            
            CTFontManagerRegisterFontsForURL(interVarFontURL as CFURL, .process, nil)
            CTFontManagerRegisterFontsForURL(interItalicVarFontURL as CFURL, .process, nil)
            
            print("Inter fonts registered successfully")
        } else {
            print("Failed to find Inter font files")
        }
    }
    
    static func overrideSystemFont() {
        // Override the system font to use Inter
        overrideInitialize()
    }

    private static func overrideInitialize() {
        // Must be called once to swizzle font methods for the whole app
        guard self == UIFont.self else { return }
        
        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
           let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }
        
        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
           let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        }
        
        if let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:))),
           let myItalicSystemFontMethod = class_getClassMethod(self, #selector(myItalicSystemFont(ofSize:))) {
            method_exchangeImplementations(italicSystemFontMethod, myItalicSystemFontMethod)
        }
        
        if let systemFontWeightMethod = class_getClassMethod(self, #selector(systemFont(ofSize:weight:))),
           let mySystemFontWeightMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:weight:))) {
            method_exchangeImplementations(systemFontWeightMethod, mySystemFontWeightMethod)
        }
    }
    
    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Inter", size: size) ?? mySystemFont(ofSize: size)
    }
    
    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-Bold", size: size) ?? myBoldSystemFont(ofSize: size)
    }
    
    @objc class func myItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-Italic", size: size) ?? myItalicSystemFont(ofSize: size)
    }
    
    @objc class func mySystemFont(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let fontName: String
        
        switch weight {
        case .black:
            fontName = "Inter-Black"
        case .heavy:
            fontName = "Inter-ExtraBold" // Heavy maps to ExtraBold
        case .bold:
            fontName = "Inter-Bold"
        case .semibold:
            fontName = "Inter-SemiBold"
        case .medium:
            fontName = "Inter-Medium"
        case .regular:
            fontName = "Inter"
        case .light:
            fontName = "Inter-Light"
        case .thin:
            fontName = "Inter-Light" // Thin maps to Light since Inter might not have Thin
        case .ultraLight:
            fontName = "Inter-Light" // UltraLight maps to Light
        default:
            fontName = "Inter"
        }
        
        return UIFont(name: fontName, size: size) ?? mySystemFont(ofSize: size, weight: weight)
    }
}
