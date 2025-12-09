import Foundation
import Vapor

struct NotificationFields: Content {
    let userId: FSString
    let projectId: FSInteger
    let mrIid: FSInteger
    let mrTitle: FSString
    let pipelineId: FSInteger
    let pipelineStatus: FSString
    let updatedAt: FSString
}

