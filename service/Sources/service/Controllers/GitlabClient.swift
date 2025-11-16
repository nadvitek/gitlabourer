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

        // Optional: sanity check
        guard response.status == .ok else {
            throw Abort(response.status)
        }

        let decodedResponse = try response.content.decode([MergeRequest].self)

        // Concurrently fetch the latest pipeline for each MR, then filter by running status
        let pairs: [(MergeRequest, Pipeline?)] = try await withThrowingTaskGroup(
            of: (
                MergeRequest,
                Pipeline?
            ).self
        ) { group in
            for mr in decodedResponse {
                group.addTask {
                    let pipeline = try await pipelineForMergeRequest(mergeRequest: mr)
                    return (mr, pipeline)
                }
            }

            var results: [(MergeRequest, Pipeline?)] = []
            results.reserveCapacity(decodedResponse.count)

            for try await result in group {
                results.append(result)
            }
            return results
        }

        let filteredResponse = pairs.compactMap { mr, pipeline in
            if
                let pipeline,
                pipeline.status.isRunning == true
            {
                return Result(
                    mergeRequest: mr,
                    pipeline: pipeline
                )
            } else {
                return nil
            }
        }

        return filteredResponse
    }

    func pipelineForMergeRequest(mergeRequest: MergeRequest) async throws -> Pipeline? {
        var url = baseURL
        url.path = baseURL.path.finished(with: "/") + "projects/\(mergeRequest.project_id)/merge_requests/\(mergeRequest.iid)/pipelines"
        url.query = "per_page=1&order_by=id&sort=desc"

        let response = try await client.get(url) { req in
            req.headers.add(name: "PRIVATE-TOKEN", value: token)
        }

        // Optional: sanity check
        guard response.status == .ok else {
            throw Abort(response.status)
        }

        let decodedResponse = try response.content.decode([Pipeline].self)

        return decodedResponse.first
    }
}
