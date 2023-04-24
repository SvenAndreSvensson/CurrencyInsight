import Foundation

public protocol Logger {
    /// Intended for debugging purposes only, to show a full request
    /// made to the backend
    var curlDetails: Bool { get set }

    func debug(_ message: String)
    func info(_ message: String)
    func verbose(_ message: String)
    func warning(_ message: String)
    func error(_ message: String)
}

extension Logger {
    func log(_ urlRequest: URLRequest, withId requestId: String) {
        let extraInfo = curlDetails ? "\n\(urlRequest.generateCurlString())" : ""
        verbose("⏫[\(requestId)] \(urlRequest.logDescription)\(extraInfo)")
    }

    func log(_ response: URLResponse?, for requestId: String) {
        guard let response = response else {
            verbose("⏬[\(requestId)] no response...")
            return
        }

        verbose("⏬[\(requestId)] \(response.logDescription)")
    }
}
