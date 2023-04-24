import Foundation
import Combine

/// Orchestrates the networking for an api request
struct ApiRequestLoader<RequestType: ApiRequest> {
    let apiRequest: RequestType
    let networkSession: NetworkSession

    public init(
        apiRequest: RequestType,
        networkSession: NetworkSession
    ) {
        self.apiRequest = apiRequest
        self.networkSession = networkSession
    }

    typealias ApiRequestError = ApiError<RequestType.ClientError>
    typealias ApiResult = Result<RequestType.ResponseData, ApiRequestError>
}

// MARK: Internal methods

extension ApiRequestLoader {
    @discardableResult
    func load(completionHandler: @escaping (ApiResult) -> Void) -> RequestToken? {
        let logRequestId = createLogRequestId()
        let urlRequest: URLRequest

        do {
            urlRequest = try apiRequest.makeRequest()
            ApiConfiguration.logger?.log(urlRequest, withId: logRequestId)
        } catch {
            completionHandler(.failure(.encodeRequest(error)))
            return nil
        }

        let token = networkSession.loadData(with: urlRequest) { data, response, error in
            let apiResult = makeApiResult(data: data, response: response, error: error)
            ApiConfiguration.logger?.log(response, for: logRequestId)

            DispatchQueue.main.async {
                completionHandler(apiResult)
            }
        }

        return token
    }

    func loadPublisher() -> AnyPublisher<RequestType.ResponseData, ApiRequestError> {
        Future { promise in
            self.load { result in
                switch result {
                case let .success(responseData):
                    promise(.success(responseData))

                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    func load() async throws -> RequestType.ResponseData {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case let .success(responseData):
                    continuation.resume(returning: responseData)
                case let .failure(apiError):
                    continuation.resume(throwing: apiError)
                }
            }
        }
    }
}

// MARK: Private methods

private extension ApiRequestLoader {
    private func makeApiResult(data: Data?, response: URLResponse?, error: Error?) -> ApiResult {
        if let error = error {
            return .failure(.network(error))
        }

        let httpResponse = response as? HTTPURLResponse
        let httpStatusCode = httpResponse?.statusCode ?? 0

        do {
            switch httpStatusCode {
            case 200 ... 299:
//                Successful response
//                200 OK: The request was successful
//                201 Created: The request was successful and a resource was created
//                202 Accepted: The request was accepted for processing, but the processing has
//                etc
                let apiResponse = try apiRequest.decodeResponse(data: data)
                return .success(apiResponse)

            case 400 ... 499:
//                Client error
//                400 Bad Request: The request was invalid or cannot be served
//                401 Unauthorized: Authentication failed or user does not have permission
//                403 Forbidden: Authentication succeeded, but access to the requested resource is forbidden
//                404 Not Found: The requested resource could not be found
//                etc
                let body = parseBodyString(from: data)
                let clientError = try apiRequest.decodeClientError(
                    statusCode: httpStatusCode,
                    body: body
                )
                return .failure(.client(clientError))

            case 500 ... 599:
//                Server error
//                500 Internal Server Error: An internal server error occurred while processing the request
//                502 Bad Gateway: The server received an invalid response from an upstream server
//                503 Service Unavailable: The server is temporarily unable to handle the request
//                etc
                let body = parseBodyString(from: data)
                return .failure(.server(statusCode: httpStatusCode, body: body))

            default:
                return .failure(.unknown)
            }

        } catch {
            guard let requestError = error as? ApiRequestError else {
                return .failure(.unknown)
            }
            return .failure(requestError)
        }
    }

    private func parseBodyString(from data: Data?) -> String? {
        guard let data = data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    /// For debugging purposes a pseudo-id to match log entried for the same request
    private func createLogRequestId() -> String {
        String(UUID().uuidString.split(separator: "-").first ?? "")
    }
}
