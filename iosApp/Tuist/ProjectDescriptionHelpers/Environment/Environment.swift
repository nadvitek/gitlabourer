import enum ProjectDescription.Environment

public enum Environment: String {
    public static var current: Self {
        .init(
            rawValue: ProjectDescription.Environment.environment
                .getString(default: Self.development.rawValue)
        ) ?? .development
    }

    case development = "Development"
    case stage = "Stage"
    case production = "Production"

    public var appNameValue: String {
        switch self {
        case .development:
            return "DEV"
        case .stage:
            return "STAGE"
        case .production:
            return ""
        }
    }
}

extension Environment: CustomStringConvertible {
    public var description: String { rawValue }
}
