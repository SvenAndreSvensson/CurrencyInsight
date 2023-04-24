import Foundation

struct Backend {
    let components: URLComponents
    let path: String
    let host: String
    let scheme: String

    private static var environment: BackendEnvironment {
        ApiConfiguration.shared.environment
    }

    init(components: URLComponents?) {
        guard
            let components = components,
            let host = components.host,
            let scheme = components.scheme
        else {
            fatalError("❌ cannot initialize host with components")
        }

        self.path = components.path
        self.host = host
        self.scheme = scheme
        self.components = components
    }
}

// MARK: Internal static properties

extension Backend {
    static var norgesBankApi: Backend {
        switch environment {
        case .production:
            return .init(components: URLComponents(string: "https://data.norges-bank.no"))

        case .test:
            return .init(components: URLComponents(string: "https://data.norges-bank.no"))
        }
    }
}
