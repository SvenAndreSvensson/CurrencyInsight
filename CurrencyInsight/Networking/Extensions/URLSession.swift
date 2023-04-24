import Foundation

extension URLSession: NetworkSession {
    public func loadData(
        with urlRequest: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> RequestToken {
        let task = dataTask(with: urlRequest, completionHandler: completionHandler)
        task.resume()
        return RequestToken(task: task)
    }
}
