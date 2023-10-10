//
//  AppColors.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 24/09/2023.
//

import Foundation
import SwiftUI

struct AppColors {
    static let originalGreen = Color(hex: "#5FB87E")
    static let darkerGreen = Color(hex: "#3C8A56")
    static let lighterGreen = Color(hex: "#81D8A6")
    static let lightGray = Color(hex: "#EAE9ED")
    
//  Dark mode
    static let darkGray = Color(hex: "#1C1C1E")
    static let textFieldsBackgroundDarkMode = Color(hex: "#333333")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0

        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
