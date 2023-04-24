import Foundation

extension NorgesBank.GetExchangeRatesRequest: ApiRequest {
    func makeRequest() throws -> URLRequest {

        // https://data.norges-bank.no/api/data/EXR/B.USD+AUD.NOK.SP?format=sdmx-json&startPeriod=2022-02-10&endPeriod=2023-02-10&locale=no
        // https://data.norges-bank.no/api/data/EXR/B..NOK.SP?lastNObservations=1&format=sdmx-json
        // url path
        // let currency = currencies.map { $0.code }.joined(separator: "+")
        let path = "/api/data/EXR/B..NOK.SP"

        // add date interval
        let formatter = DateFormatter()
        formatter.dateFormat = frequency.dateFormat

        let start = formatter.string(from: interval.start)
        let end = formatter.string(from: interval.end)
        let startItem = URLQueryItem(name: "startPeriod", value: start)
        let endItem = URLQueryItem(name: "endPeriod", value: end)

        // default query items
        let format = URLQueryItem(name: "format", value: "sdmx-json")
        let locale = URLQueryItem(name: "locale", value: "en") // 'no' or 'en'

        return URLRequest.get(
            backend: Backend.norgesBankApi,
            path: path,
            queryItems: [startItem, endItem, format, locale]
        )
    }

    typealias ResponseData = NorgesBank.ExchangeRatesResponse
    typealias ClientError = ApiClientError
}

extension NorgesBank {
    public struct GetExchangeRatesRequest {
        /// Possible values 'A ' - Annual, 'M' - Monthly, 'B' - Bussines
        let frequency: SeriesFrequency
        let interval: DateInterval
        /// Example: ['NOK', 'SEK', 'USD']
        let currencies: [Currency]
    }
}
