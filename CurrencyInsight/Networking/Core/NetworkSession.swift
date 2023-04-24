import Foundation

/// An abstraction for URLSession. Enables the injection of mocks while testing
public protocol NetworkSession {
    func loadData(
        with urlRequest: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> RequestToken
}
