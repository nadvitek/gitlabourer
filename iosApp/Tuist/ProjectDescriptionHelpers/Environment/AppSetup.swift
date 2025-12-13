import AckeeTemplate
import struct ProjectDescription.Configuration
import typealias ProjectDescription.SettingsDictionary

public struct AppSetup {
    public static var current: Self {
        .init(environment: .current, configuration: .current)
    }

    public let environment: Environment
    public let configuration: Configuration

    public var bundleID: String {
        "cz.ackee.gitlabourer"
    }

    public var appNameValue: String {
        if configuration == .release, environment == .production {
            return ""
        }

        return environment.appNameValue
    }

    public var appGroup: String {
        "group." + bundleID
    }

    public var projectConfigurations: [ProjectDescription.Configuration] {
        switch configuration {
        case .debug:
            return [.debug(name: "Debug")]
        case .beta, .release:
            return [.release(name: "Release")]
        }
    }

    public var teamID: TeamID {
        switch (configuration, environment) {
        case (.debug, _), (.beta, .stage), (.release, .production):
            .ackeeProduction

        case (.beta, _), (.release, _):
            fatalError("Not supported combination \(AppSetup.current.description)")
        }
    }

    public var codeSignStyle: String {
        switch configuration {
        case .debug:
            return "Automatic"
        case .beta, .release:
            return "Manual"
        }
    }
}

extension AppSetup: CustomStringConvertible {
    public var description: String { "\(configuration)/\(environment)" }
}
