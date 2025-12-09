import Foundation
import Vapor

struct GitLabClient {
    let client: any Client
    var baseURL: URI
    let token: String

    func mergeRequests() async throws -> [Result] {
        var url = baseURL
        url.path = baseURL.path.finished(with: "/") + "merge_requests"
        url.query = "state=opened"

        let response = try await client.get(url) { req in
            req.headers.add(name: "PRIVATE-TOKEN", value: token)
        }

        guard response.status == .ok else {
            throw Abort(response.status)
        }

        let mergeRequests = try response.content.decode([MergeRequest].self)

        let enriched: [(MergeRequest, Pipeline?, String)] = try await withThrowingTaskGroup(
            of: (MergeRequest, Pipeline?, String).self
        ) { group in

            for mr in mergeRequests {
                group.addTask {
                    async let pipeline = pipelineForMergeRequest(mergeRequest: mr)
                    async let projectName = projectNameForProject(id: mr.project_id)

                    return (mr, try await pipeline, try await projectName)
                }
            }

            var results: [(MergeRequest, Pipeline?, String)] = []
            results.reserveCapacity(mergeRequests.count)

            for try await result in group {
                results.append(result)
            }
            return results
        }

        return enriched.compactMap { mr, pipeline, projectName in
            guard let pipeline else { return nil }
            return Result(
                projectName: projectName,
                mergeRequest: mr,
                pipeline: pipeline,
            )
        }
    }

    func pipelineForMergeRequest(mergeRequest: MergeRequest) async throws -> Pipeline? {
        var url = baseURL
        url.path = baseURL.path.finished(with: "/") +
            "projects/\(mergeRequest.project_id)/merge_requests/\(mergeRequest.iid)/pipelines"
        url.query = "per_page=1&order_by=id&sort=desc"

        let response = try await client.get(url) { req in
            req.headers.add(name: "PRIVATE-TOKEN", value: token)
        }

        guard response.status == .ok else {
            throw Abort(response.status)
        }

        let pipelines = try response.content.decode([Pipeline].self)
        return pipelines.first
    }

    func projectNameForProject(id: Int) async throws -> String {
        var url = baseURL
        url.path = baseURL.path.finished(with: "/") + "projects/\(id)"

        let response = try await client.get(url) { req in
            req.headers.add(name: "PRIVATE-TOKEN", value: token)
        }

        guard response.status == .ok else {
            throw Abort(response.status)
        }

        let project = try response.content.decode(Project.self)
        return project.name
    }
}
