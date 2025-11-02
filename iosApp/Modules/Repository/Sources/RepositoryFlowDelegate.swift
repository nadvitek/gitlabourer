import Foundation
import shared

public protocol RepositoryFlowDelegate: AnyObject {
    func openFile(file: TreeItem, selectedBranchName: String, branches: [String])
}
