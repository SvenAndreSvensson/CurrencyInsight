import Foundation

extension CurrencyConversionViewData {
    static func filter(viewData: Self, includedCurrencies: [NorgesBank.Currency]) throws -> Self {

        return .init(
            baseCurrency: viewData.baseCurrency,
            multiplier: viewData.multiplier,
            series: viewData.series.filter {
                includedCurrencies.contains($0.baseCurrency)
            },
            meta: viewData.meta,
            missingSeriesCurrencies: viewData.missingSeriesCurrencies
        )
    }
}
