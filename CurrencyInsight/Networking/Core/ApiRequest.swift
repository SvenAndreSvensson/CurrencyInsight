import Foundation

/// Represents an api request to the SATS backend.
///
/// An object conforming to this type contains
/// the logic for handling the request data, the response data, and client errors.
protocol ApiRequest {
    associatedtype ResponseData
    associatedtype ClientError: Error

    func makeRequest() throws -> URLRequest
    func decodeResponse(data: Data?) throws -> ResponseData

    /// Backend returned a 4xx http status code.
    func decodeClientError(statusCode: Int, body: String?) throws -> ClientError
}

extension ApiRequest where ResponseData: Decodable {
    /// Use the default decoder when the response data is decodable,
    /// now only methods that need to override the default behavior must do so
    func decodeResponse(data: Data?) throws -> ResponseData {
        guard let data = data else { throw ApiError<ClientError>.missingData }

        do {
            return try ApiConfiguration.shared.decoder.decode(ResponseData.self, from: data)
        } catch {
            throw ApiError<ClientError>.decodeResponse(error)
        }
    }
}

extension ApiRequest where ResponseData == Void {
    func decodeResponse(data: Data?) throws -> ResponseData {
        () as ResponseData
    }
}

extension ApiRequest where ResponseData == Data {
    func decodeResponse(data: Data?) throws -> ResponseData {
        guard let data = data else { throw ApiError<ClientError>.missingData }
        return data
    }
}

extension ApiRequest where ClientError == ApiClientError {
    func decodeClientError(statusCode: Int, body: String?) -> ClientError {
        .init(statusCode: statusCode, body: body)
    }
}
