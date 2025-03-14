//
//  SettingOption.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 13/03/2025.
//

import SwiftUI
import Foundation

struct SettingOption: Identifiable {
    let id: Int
    let title: String
    let iconName: String
    var value: String? = nil
    var hasToggle: Bool = false
}
