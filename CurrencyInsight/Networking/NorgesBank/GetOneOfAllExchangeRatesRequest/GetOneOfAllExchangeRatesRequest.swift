import Foundation

extension NorgesBank.GetOneOfAllExchangeRatesRequest: ApiRequest {
    func makeRequest() throws -> URLRequest {

        // https://data.norges-bank.no/api/data/EXR/B..NOK.SP?format=sdmx-json&lastNObservations=1&locale=no

        let path = "/api/data/EXR/B..NOK.SP"

        // default query items
        let format = URLQueryItem(name: "format", value: "sdmx-json")
        let lastObservations = URLQueryItem(name: "lastNObservations", value: "1") // number of observations
        let locale = URLQueryItem(name: "locale", value: "en") // 'no' or 'en'

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
    public struct GetOneOfAllExchangeRatesRequest {

    }
}
