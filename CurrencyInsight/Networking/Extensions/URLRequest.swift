import Foundation

extension URLRequest {
    /// Factory method for a POST URLRequest
    /// - Parameters:
    ///   - backend: the backend the request will be towards
    ///   - path: the endpoint path
    ///   - queryItems: optional query string data
    ///   - body: optional data to be encoded
    ///   - headers: Additional headers used in conjunction with the common headers
    ///   - configuration: ApiConfiguration
    ///   - cachePolicy: (default: useProtocolCachePolicy)
    ///   - timeoutInterval: (default: 20)
    /// - Throws: a Encoding error if the passed body was not successfully encoded
    /// - Returns: a ready to perform POST URLRequest
    static func post<RequestData: Encodable>(
        backend: Backend,
        path: String,
        queryItems: [URLQueryItem]? = nil,
        body: RequestData?,
        headers: [String: String]? = nil,
        configuration: ApiConfiguration = .shared,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 20
    ) throws -> URLRequest {
        var encodedBody: Data?

        if let body = body {
            encodedBody = try ApiConfiguration.shared.encoder.encode(body)
        }

        return buildUrlRequest(
            httpMethod: "POST",
            backend: backend,
            path: path,
            queryItems: queryItems,
            body: encodedBody,
            headers: headers,
            configuration: configuration,
            cachePolicy: cachePolicy,
            timeoutInterval: timeoutInterval
        )
    }

    /// Factory method for a PUT URLRequest
    /// - Parameters:
    ///   - backend: the backend the request will be towards
    ///   - path: the endpoint path
    ///   - queryItems: optional query string data
    ///   - body: optional data to be encoded
    ///   - headers: Additional headers used in conjunction with the common headers
    ///   - configuration: ApiConfiguration
    ///   - cachePolicy: (default: useProtocolCachePolicy)
    ///   - timeoutInterval: (default: 20)
    /// - Throws: a Encoding error if the passed body was not successfully encoded
    /// - Returns: a ready to perform PUT URLRequest
    static func put<RequestData: Encodable>(
        backend: Backend,
        path: String,
        queryItems: [URLQueryItem]? = nil,
        body: RequestData?,
        headers: [String: String]? = nil,
        configuration: ApiConfiguration = .shared,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 20
    ) throws -> URLRequest {
        var encodedBody: Data?

        if let body = body {
            encodedBody = try ApiConfiguration.shared.encoder.encode(body)
        }

        return buildUrlRequest(
            httpMethod: "PUT",
            backend: backend,
            path: path,
            queryItems: queryItems,
            body: encodedBody,
            headers: headers,
            configuration: configuration,
            cachePolicy: cachePolicy,
            timeoutInterval: timeoutInterval
        )
    }

    /// Factory method for a PATCH URLRequest
    /// - Parameters:
    ///   - backend: the backend the request will be towards
    ///   - path: the endpoint path
    ///   - queryItems: optional query string data
    ///   - body: optional data to be encoded
    ///   - headers: Additional headers used in conjunction with the common headers
    ///   - configuration: ApiConfiguration
    ///   - cachePolicy: (default: useProtocolCachePolicy)
    ///   - timeoutInterval: (default: 20)
    /// - Throws: a Encoding error if the passed body was not successfully encoded
    /// - Returns: a ready to perform PATCH URLRequest
    static func patch<RequestData: Encodable>(
        backend: Backend,
        path: String,
        queryItems: [URLQueryItem]? = nil,
        body: RequestData?,
        headers: [String: String]? = nil,
        configuration: ApiConfiguration = .shared,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 20
    ) throws -> URLRequest {
        var encodedBody: Data?

        if let body = body {
            encodedBody = try ApiConfiguration.shared.encoder.encode(body)
        }

        return buildUrlRequest(
            httpMethod: "PATCH",
            backend: backend,
            path: path,
            queryItems: queryItems,
            body: encodedBody,
            headers: headers,
            configuration: configuration,
            cachePolicy: cachePolicy,
            timeoutInterval: timeoutInterval
        )
    }

    /// Factory method for a DELETE URLRequest
    /// - Parameters:
    ///   - backend: the backend the request will be towards
    ///   - path: the endpoint path
    ///   - queryItems: optional query string data
    ///   - body: optional data to be encoded
    ///   - headers: Additional headers used in conjunction with the common headers
    ///   - configuration: ApiConfiguration
    ///   - cachePolicy: (default: useProtocolCachePolicy)
    ///   - timeoutInterval: (default: 20)
    /// - Throws: a Encoding error if the passed body was not successfully encoded
    /// - Returns: a ready to perform DELETE URLRequest
    static func delete<RequestData: Encodable>(
        backend: Backend,
        path: String,
        queryItems: [URLQueryItem]? = nil,
        body: RequestData?,
        headers: [String: String]? = nil,
        configuration: ApiConfiguration = .shared,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 20
    ) throws -> URLRequest {
        var encodedBody: Data?

        if let body = body {
            encodedBody = try ApiConfiguration.shared.encoder.encode(body)
        }

        return buildUrlRequest(
            httpMethod: "DELETE",
            backend: backend,
            path: path,
            queryItems: queryItems,
            body: encodedBody,
            headers: headers,
            configuration: configuration,
            cachePolicy: cachePolicy,
            timeoutInterval: timeoutInterval
        )
    }

    /// Factory method for a GET URLRequest
    /// - Parameters:
    ///   - backend: the backend the request will be towards
    ///   - path: the endpoint path
    ///   - headers: Additional headers used in conjunction with the common headers
    ///   - configuration: ApiConfiguration
    ///   - cachePolicy: (default: useProtocolCachePolicy)
    ///   - timeoutInterval: (default: 20)
    /// - Returns: a ready to perform GET URLRequest
    static func get(
        backend: Backend,
        path: String,
        queryItems: [URLQueryItem]? = nil,
        headers: [String: String]? = nil,
        configuration: ApiConfiguration = .shared,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 20
    ) -> URLRequest {
        buildUrlRequest(
            httpMethod: "GET",
            backend: backend,
            path: path,
            queryItems: queryItems,
            body: nil,
            headers: headers,
            configuration: configuration,
            cachePolicy: cachePolicy,
            timeoutInterval: timeoutInterval
        )
    }

    private static func buildUrlRequest(
        httpMethod: String,
        backend: Backend,
        path: String,
        queryItems: [URLQueryItem]? = nil,
        body: Data? = nil,
        headers: [String: String]? = nil,
        configuration: ApiConfiguration = .shared,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 20
    ) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = backend.scheme
        urlComponents.host = backend.host
        urlComponents.path = concat(paths: [backend.path, path])
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            fatalError("❌ developer error: a request should be defined properly for \(path)")
        }

        print(url)

        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)

        request.httpMethod = httpMethod

        if httpMethod == "POST" || httpMethod == "PUT" || httpMethod == "PATCH" {
            request.httpBody = body
        }

        let mergedHeaders = make(headers, with: configuration)

        mergedHeaders.forEach({ header in
            request.setValue(header.value, forHTTPHeaderField: header.key)
        })

        return request
    }

    // MARK: Internal utilities

    private static func make(_ headers: [String: String]?, with configuration: ApiConfiguration) -> [String: String] {
        var headerDict: [String: String] = [:]

        if let preferredLanguage = configuration.preferredLanguage {
            headerDict[Self.preferredLanguageHeaderKey] = preferredLanguage
        }

        if let acceptLanguage = configuration.acceptLanguage {
            headerDict[Self.acceptLanguageHeaderKey] = acceptLanguage
        }

        if let userAgent = configuration.userAgent {
            headerDict[Self.userAgentHeaderKey] = userAgent
        }

        if let key = configuration.apimSubscriptionKey {
            headerDict[Self.apimSubscriptionHeaderKey] = key
        }

        if let token = configuration.authenticationToken {
            //headerDict[Self.cookieAuthenticationHeaderKey] = "Auth-SatsElixia=\(token)"
            headerDict[Self.cookieAuthenticationHeaderKey] = "Auth-'find-a-name-to-use'=\(token)"
        }

        if let targetingGroup = configuration.targetingGroup {
            headerDict[Self.targetingGroupHeaderKey] = targetingGroup
        }

        if let headers = headers {
            headerDict.merge(headers) { _, new in new }
        }

        if headerDict[Self.contentTypeHeaderKey] == nil {
            headerDict[Self.contentTypeHeaderKey] = "application/json"
        }

        return headerDict
    }

    internal static func concat(paths: [String]) -> String {
        var result = ""

        for var path in paths {
            guard !path.isEmpty else { continue }

            result += "/"

            if path.first == "/" {
                path.remove(at: path.startIndex)
            }

            if path.last == "/" {
                path.remove(at: path.index(before: path.endIndex))
            }

            result += path
        }

        return result
    }

    // MARK: Header keys

    static let contentTypeHeaderKey = "Content-Type"
    static let preferredLanguageHeaderKey = "X-preferred-language"
    static let acceptLanguageHeaderKey = "Accept-Language"
    static let userAgentHeaderKey = "User-Agent"
    static let apimSubscriptionHeaderKey = "Ocp-Apim-Subscription-Key"
    static let cookieAuthenticationHeaderKey = "X-CookieAuthentication"
    static let targetingGroupHeaderKey = "targeting-group"
}

// MARK: - Utilities

extension URLRequest {
    /// Creates a curl version of the same request
    func generateCurlString() -> String {
        guard let url = url else { return "" }

        var strings = ["curl \(url.absoluteString)"]

        if let method = httpMethod {
            strings.append("-X \(method)")
        }

        let headers = allHTTPHeaderFields ?? [:]
        for (key, value) in headers {
            strings.append("-H '\(key): \(value)'")
        }

        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
            strings.append("-d '\(body)'")
        }

        return strings.joined(separator: " \\\n\t")
    }

    var logDescription: String {
        guard
            let httpMethod = httpMethod,
            let absoluteString = url?.absoluteString
        else { return "bad URL data" }

        return "\(httpMethod) \(absoluteString)"
    }
}

extension URLResponse {
    var logDescription: String {
        guard
            let statusCode = (self as? HTTPURLResponse)?.statusCode
        else {
            return "not a HTTP response? huh?"
        }

        return "returned with: \(statusCode)"
    }
}
