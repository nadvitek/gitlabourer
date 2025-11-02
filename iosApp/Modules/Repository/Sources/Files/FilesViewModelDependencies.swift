import Foundation
import shared

public struct FilesViewModelDependencies {
    public let getFileData: GetFileDataUseCase

    public init(getFileData: GetFileDataUseCase) {
        self.getFileData = getFileData
    }
}
