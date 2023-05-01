import Foundation

struct CurrencyConversionViewData {
    let baseCurrency: NorgesBank.Currency
    let series: [ExchangeRateSerie]
    let meta: CurrencyConversionMeta
    let missingSeriesCurrencies: [NorgesBank.Currency]
}

struct CurrencyConversionMeta {
    let prepared: Date
    let message: String
}

struct ExchangeRateSerie: Identifiable, Hashable {
    let id: Int
    let frequency: NorgesBank.SeriesFrequency
    let baseCurrency: NorgesBank.Currency
    let baseValue: Double
    let quoteCurrency: NorgesBank.Currency
    let quoteObservations: [ExchangeRateObservation]
    let decimals: Int
    // Datoer eller perioder for når verdien ble innhentet.
    let collected: String
}

extension ExchangeRateSerie {
    var minValue: Double {
        guard let firstObservation = quoteObservations.first else { return 0 }
        let values = quoteObservations.map { $0.value }
        return values.min() ?? firstObservation.value
    }

    var maxValue: Double {
        guard let firstObservation = quoteObservations.first else { return 0 }
        let values = quoteObservations.map { $0.value }
        return values.max() ?? firstObservation.value
    }

    var firstObservation: ExchangeRateObservation {
        return quoteObservations.first ?? .init(id: 0, value: 0, valueAsString: "nil", key: "nil", start: Date.now, end: Date.now)
    }

    var LastObservation: ExchangeRateObservation {
        return quoteObservations.last ?? .init(id: 0, value: 0, valueAsString: "nil", key: "nil", start: Date.now, end: Date.now)
    }

    func calculateQuoteValue(multiplier: Double, formatter: NumberFormatter = .currencyText) -> String {
        if self.LastObservation.value == 0 {
            return "0"
        }
        if multiplier == 0 {
            return "0"
        }
        let newValue =  multiplier * self.LastObservation.value
        let formatter = NumberFormatter.currencyText

        if let formatted = formatter.string(from: NSDecimalNumber(floatLiteral: newValue)) {
            return formatted
        }
        return formatter.notANumberSymbol
    }
}

struct ExchangeRateObservation: Identifiable, Hashable {
    // From value observation
    let id: Int // id - index - "0" "1" osv
    let value: Double // 6.12345
    let valueAsString: String // "6.12345"
    // Frome date observation
    let key: String // date key - yyyy-MM-dd, yyyy-MM, yyyy. dependent on frequence
    let start: Date // from format "2011-09-01T00:00:00"
    let end: Date // from format "2011-09-30T23:59:59"
}

extension CurrencyConversionViewData {
    static let placeholder: Self = previewValues()

    static func previewValues(msg: String = "Error" ) -> Self {
        .init(
            baseCurrency: .NOK,
            series: [],
            meta: .init(prepared: Date(), message: ""),
            missingSeriesCurrencies: []
        )
    }
}
