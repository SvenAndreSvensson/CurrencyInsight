import Foundation

extension NorgesBank {
    public struct SeriesFrequency: Codable {
        let value: String
        let name: String
        let dateFormat: String

        static let annual: Self = .init(value: "A", name: "Annual", dateFormat: "yyyy")
        static let monthly: Self = .init(value: "M", name: "Monthly", dateFormat: "yyyy-MM")
        /// Working days (monday - friday)
        static let business: Self = .init(value: "B", name: "Business", dateFormat: "yyyy-MM-dd")

        static let defaultFrequency: Self = .business
    }
}
extension NorgesBank.SeriesFrequency: Identifiable, Hashable {
    public var id: String {
        value
    }
}

extension NorgesBank.SeriesFrequency {
    static func map(_ value: String) -> Self? {
        switch value.uppercased() {
        case "A":
            return .annual
        case "M":
            return .monthly
        case "B":
            return .business
        default:
            return .monthly
        }
    }
}
