import Foundation

public typealias BaseError = ApiError<ApiClientError>

public enum ApiError<ClientError: Error>: Error {
    case encodeRequest(Error)
    case network(Error)
    case client(ClientError)
    case server(statusCode: Int, body: String?)
    case decodeResponse(Error)
    case missingData
    case unknown
}
