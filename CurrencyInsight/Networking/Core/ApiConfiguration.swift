import Foundation

public class ApiConfiguration {
    // MARK: Public properties

    public static let shared: ApiConfiguration = .init()

    // MARK: Internal properties

    var authenticationToken: String?
    var apimSubscriptionKey: String?
    var userAgent: String?
    var preferredLanguage: String?
    var acceptLanguage: String?
    var targetingGroup: String?

    var environment: BackendEnvironment = .production
    var decoder: JSONDecoder = .norgesBankDecoder
    var encoder: JSONEncoder = JSONEncoder()
    var logger: Logger?

    static var logger: Logger? { shared.logger }
}

// MARK: Public methods

extension ApiConfiguration {
    public func setup(
        apimSubscriptionKey: String,
        userAgent: String,
        preferredLanguage: String = "*",
        acceptLanguage: String = "en",
        targetingGroup: String? = nil,
        environment: BackendEnvironment? = nil,
        decoder: JSONDecoder? = nil,
        encoder: JSONEncoder? = nil,
        logger: Logger? = nil
    ) {
        self.apimSubscriptionKey = apimSubscriptionKey
        self.userAgent = userAgent
        self.preferredLanguage = preferredLanguage
        self.acceptLanguage = acceptLanguage
        self.targetingGroup = targetingGroup
        self.logger = logger

        if let environment = environment {
            self.environment = environment
        }

        if let decoder = decoder {
            self.decoder = decoder
        }

        if let encoder = encoder {
            self.encoder = encoder
        }
    }

    public func set(authenticationToken: String?) {
        self.authenticationToken = authenticationToken
    }
}
