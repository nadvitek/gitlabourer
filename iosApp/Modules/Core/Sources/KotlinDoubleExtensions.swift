import Foundation
import shared

extension KotlinDouble {
    /// Converts this KotlinDouble (interpreted as seconds) to a compact string like "1h 23m 30s".
    /// Rules:
    /// - For 0 seconds -> "0s"
    /// - Include hours if >= 1 hour
    /// - Include minutes if >= 1 minute or when hours are present (show "0m" if hours exist and minutes are zero)
    /// - Always include seconds to match "1h 23m 30s" style
    public func asDurationString() -> String {
        let value = Double(truncating: self)
        guard value.isFinite, value >= 0 else { return "0s" }

        let total = Int(value) // truncate toward zero; change to rounding if desired
        let hours = total / 3600
        let minutes = (total % 3600) / 60
        let secs = total % 60

        if hours == 0 && minutes == 0 {
            return "\(secs)s"
        }

        var parts: [String] = []
        if hours > 0 {
            parts.append("\(hours)h")
        }

        // Show minutes if any, or if hours are present (show "0m")
        if hours > 0 || minutes > 0 {
            parts.append("\(minutes)m")
        }

        // Always include seconds to match "1h 23m 30s"
        parts.append("\(secs)s")

        return parts.joined(separator: " ")
    }
}
