import Foundation

enum ExchangeError: Error {
    case UnexpectedError(String)
    case missingSerieData(NorgesBank.Currency)
}
