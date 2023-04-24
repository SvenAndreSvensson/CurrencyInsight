import Foundation

extension NorgesBank.GetLastNObservationsRequest: ApiRequest {
    func makeRequest() throws -> URLRequest {

        // https://data.norges-bank.no/api/data/EXR/B.SEK+USD.NOK.SP?format=sdmx-json&lastNObservations=1&locale=no

        let language = locale == "no" ? "no" : "en"
        let currency = currencies.map { $0.code }.joined(separator: "+")
        let path = "/api/data/EXR/B.\(currency).NOK.SP"

        // default query items
        let format = URLQueryItem(name: "format", value: "sdmx-json")
        let lastObservations = URLQueryItem(name: "lastNObservations", value: "1") // number of observations
        let locale = URLQueryItem(name: "locale", value: language) // 'no' or 'en'

        return URLRequest.get(
            backend: Backend.norgesBankApi,
            path: path,
            queryItems: [format, lastObservations, locale]
        )
    }

    typealias ResponseData = NorgesBank.ExchangeRatesResponse
    typealias ClientError = ApiClientError
}


extension NorgesBank {
    public struct GetLastNObservationsRequest {
        /// Example: ['NOK', 'SEK', 'USD']
        let currencies: [Currency]
        let locale: String
    }
}
