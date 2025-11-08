import Foundation
import shared

public struct PipelinesViewModelDependencies {
    let getPipelinesForProjectUseCase: GetPipelinesForProjectUseCase

    public init(getPipelinesForProjectUseCase: GetPipelinesForProjectUseCase) {
        self.getPipelinesForProjectUseCase = getPipelinesForProjectUseCase
    }
}
