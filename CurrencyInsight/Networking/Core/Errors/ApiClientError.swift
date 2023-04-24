import Foundation

/// Default client error object for 4xx status codes
public struct ApiClientError: Error {
    public let statusCode: Int
    public let body: String?

    public let message: String?
    public let userMessage: String?
    public let traceId: String?

    public init(
        statusCode: Int,
        body: String?
    ) {
        self.statusCode = statusCode
        self.body = body

        // The backend will start sending
        // formatted error data, which may not
        // be present for all endpoints just yet
        let errorDetails = body
            .flatMap { $0.data(using: .utf8) }
            .flatMap { try? JSONDecoder().decode(BackendErrorDetails.self, from: $0) }

        self.userMessage = errorDetails?.userMessage
        self.message = errorDetails?.message
        self.traceId = errorDetails?.traceId
    }
}

extension ApiClientError {
    struct BackendErrorDetails: Decodable {
        let message: String
        let userMessage: String
        let traceId: String
    }
}
