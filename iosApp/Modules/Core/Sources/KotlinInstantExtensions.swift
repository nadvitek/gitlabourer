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

    func relativeString(reference: Date = Date()) -> String {
        let f = RelativeDateTimeFormatter()
        f.unitsStyle = .short
        return f.localizedString(for: asDate, relativeTo: reference)
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
