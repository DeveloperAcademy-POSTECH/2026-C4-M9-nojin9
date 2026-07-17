//
//  Color.swift
//  Nojin9
//
//  Created by Kimseoyeon on 7/15/26.
//

import SwiftUI

// MARK: - Color

extension Color {

    static let customBlack = Color(hex: "#171819")
    static let customWhite = Color(hex: "#FFFFFF")

    static let gray80 = Color(hex: "#2B2D33")
    static let gray60 = Color(hex: "#575B66")
    static let gray40 = Color(hex: "#878B99")
    static let gray20 = Color(hex: "#BEC1CC")
    static let gray10 = Color(hex: "#DCDFE5")
    static let gray5  = Color(hex: "#E9EBF2")

    static let brandPrimary = Color(hex: "#FF2580")
    static let brandPrimary10 = Color(hex: "#FFE5F0")
}

// MARK: - Hex Color

extension Color {

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)

        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64

        switch hex.count {
        case 3:
            (a, r, g, b) = (
                255,
                ((int >> 8) & 0xF) * 17,
                ((int >> 4) & 0xF) * 17,
                (int & 0xF) * 17
            )

        case 6:
            (a, r, g, b) = (
                255,
                int >> 16,
                int >> 8 & 0xFF,
                int & 0xFF
            )

        case 8:
            (a, r, g, b) = (
                int >> 24,
                int >> 16 & 0xFF,
                int >> 8 & 0xFF,
                int & 0xFF
            )

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
