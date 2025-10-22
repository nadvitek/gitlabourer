import Foundation
import SwiftUI

public extension String {
    func convertToColor() -> Color {
        var hex = self.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.replacingOccurrences(of: "#", with: "")

        guard hex.count == 6 || hex.count == 8 else { return .red }

        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b, a: UInt64
        if hex.count == 8 {
            r = (int >> 24) & 0xFF
            g = (int >> 16) & 0xFF
            b = (int >> 8) & 0xFF
            a = int & 0xFF
        } else {
            r = (int >> 16) & 0xFF
            g = (int >> 8) & 0xFF
            b = int & 0xFF
            a = 0xFF
        }

        return Color(
            .sRGB,
            red: Double(r) / 255.0,
            green: Double(g) / 255.0,
            blue: Double(b) / 255.0,
            opacity: Double(a) / 255.0
        )
    }

    func getNameInitials() -> String {
        let components = self
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }

        guard let firstWord = components.first else {
            return ""
        }

        let lastWord = components.last ?? firstWord

        let firstInitial = firstWord.first.map { String($0).uppercased() } ?? ""
        let lastInitial = lastWord.first.map { String($0).uppercased() } ?? ""

        return firstInitial + lastInitial
    }
}

