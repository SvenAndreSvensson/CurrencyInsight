import Foundation

public class ApiClient {
    let networkSession: NetworkSession

    required public init(networkSession: NetworkSession = URLSession.shared) {
        self.networkSession = networkSession
    }
}
