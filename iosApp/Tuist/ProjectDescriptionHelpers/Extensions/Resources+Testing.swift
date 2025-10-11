import Foundation
import ProjectDescription

public extension ProjectDescription.SourceFilesList {
    /// Checks if there is _Testing_ folder at given path and if used configuration is debug and returns its glob if so.
    /// - Parameter path: Path where existence of _Testing_ folder should be checked
    /// - Parameter isResourceFolder: When true, looks for `Testing/Resources` instead of `Testing`
    /// - Returns: Glob for testing resources folder if any, nil otherwise
    static func testing(
        at path: String,
        isResourceFolder: Bool = false
//        isDebug: Bool = Configuration.current.isDebug
    ) -> ResourceFileElement? {
        var isDirectory: ObjCBool = false
        let testingPath = isResourceFolder ? path + "/Testing/Resources" : path + "/Testing"

        let exists = FileManager.default.fileExists(atPath: testingPath, isDirectory: &isDirectory)

        guard exists, isDirectory.boolValue else {
            return nil
        }

        return "\(testingPath)/**"
    }
}

public extension ProjectDescription.SourceFileGlob {
    /// Returns a source glob for `Testing` folder if it exists at the given path.
    /// - Parameter path: Base module path (e.g. "Modules/FeatureName")
    /// - Returns: SourceFileGlob for `Testing/**` if the folder exists, nil otherwise.
    static func testing(
        at path: String,
        isResourceFolder: Bool = false
//        isDebug: Bool = Configuration.current.isDebug
    ) -> ProjectDescription.SourceFileGlob? {
        var isDirectory: ObjCBool = true
        let testingPath = isResourceFolder ? path + "/Testing/Resources" : path + "/Testing"

        let exists = FileManager.default.fileExists(atPath: testingPath, isDirectory: &isDirectory)

        guard exists, isDirectory.boolValue else {
            return nil
        }

        return "\(testingPath)/**"
    }
}
