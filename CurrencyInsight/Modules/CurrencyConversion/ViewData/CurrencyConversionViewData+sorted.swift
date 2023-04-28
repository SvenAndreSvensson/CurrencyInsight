import Foundation

extension CurrencyConversionViewData {

    static func sortSeries(viewData: Self, sortOrder currencies: [NorgesBank.Currency]) throws -> Self {

        let sortedSeries = sortSeries(viewData.series, sortOrder: currencies)

        return .init(
            baseCurrency: viewData.baseCurrency,
            multiplier: viewData.multiplier,
            series: sortedSeries,
            meta: viewData.meta,
            missingSeriesCurrencies: viewData.missingSeriesCurrencies
        )
    }

    private static func sortSeries(_ series: [ExchangeRateSerie], sortOrder currencies: [NorgesBank.Currency]) -> [ExchangeRateSerie] {
        // Create a dictionary using the currency code as the key and its position in the selectedCurrencies array as the value
        let currencyPositions = Dictionary(uniqueKeysWithValues: currencies.enumerated().map { ($1.code, $0) })

        // Sort the series array using the position of the corresponding currency in the selectedCurrencies array
        let sortedSeries = series.sorted { (serie1, serie2) in
            let position1 = currencyPositions[serie1.quoteCurrency.code] ?? Int.max
            let position2 = currencyPositions[serie2.quoteCurrency.code] ?? Int.max
            return position1 < position2
        }

        return sortedSeries
    }
}
