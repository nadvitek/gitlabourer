import Foundation
import shared

public extension Kotlinx_datetimeInstant {
    var asDate: Date {
        let millis = toEpochMilliseconds()
        return Date(timeIntervalSince1970: TimeInterval(millis) / 1000.0)
    }

    func formatted(_ formatter: DateFormatter = .pipelineDateFormatter) -> String {
        formatter.string(from: asDate)
    }

    // Ultra-short relative string: y, m, w, d, h, min, s
    // Examples: "3d ago", "in 2h", "5min ago"
    func relativeString(reference: Date = Date()) -> String {
        let target = asDate
        let delta = target.timeIntervalSince(reference)
        let absDelta = abs(delta)

        let second: Double = 1
        let minute = 60.0 * second
        let hour = 60.0 * minute
        let day = 24.0 * hour
        let week = 7.0 * day
        let month = 30.0 * day
        let year = 365.0 * day

        let value: Int
        let unit: String

        switch absDelta {
        case year...:
            value = Int((absDelta / year).rounded(.towardZero))
            unit = "y"
        case month...:
            value = Int((absDelta / month).rounded(.towardZero))
            unit = "m" // month
        case week...:
            value = Int((absDelta / week).rounded(.towardZero))
            unit = "w"
        case day...:
            value = Int((absDelta / day).rounded(.towardZero))
            unit = "d"
        case hour...:
            value = Int((absDelta / hour).rounded(.towardZero))
            unit = "h"
        case minute...:
            value = Int((absDelta / minute).rounded(.towardZero))
            unit = "min"
        default:
            value = Int((absDelta / second).rounded(.towardZero))
            unit = "s"
        }

        if value == 0 {
            return "now"
        }

        if delta < 0 {
            return "\(value)\(unit) ago"
        } else {
            return "in \(value)\(unit)"
        }
    }
}

public extension DateFormatter {
    static let pipelineDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        df.locale = .current
        df.timeZone = .current
        return df
    }()
}
