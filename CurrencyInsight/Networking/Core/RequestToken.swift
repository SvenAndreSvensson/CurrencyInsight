import Foundation
import Combine

public final class RequestToken {
    private weak var task: URLSessionTask?

    init(task: URLSessionTask) {
        self.task = task
    }

    /// This initializer is intended for testing purposes only.
    /// Use **init(task: URLSessionTask)** instead.
    public init() {
        self.task = nil
    }

    public func cancel() {
        task?.cancel()
    }
}

extension RequestToken: Cancellable {}
