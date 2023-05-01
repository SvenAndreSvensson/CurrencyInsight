import Foundation

extension CurrencyConversionViewData {
    static func swapBaseAndQuote(
        viewData: Self,
        baseCurrency: NorgesBank.Currency,
        selectedCurrencies: [NorgesBank.Currency]
    ) throws -> Self {

        if baseCurrency == .NOK {
            // switch Quote currency, use own multiplier in desimal
            // Alle observations verdier er i NOK(qoute), eks 100SEK == 98NOK
            // 100 i 100SEK er her pow(10, multiplier) som vil si pow(10, 2) = 100
            // 1. fin enhets verdi for nåværende base => 100SEK/100SEK = 98NOK/100SEK => 1SEK = 0.98NOK
            // 2. switch quote from NOK to SEK, 0.98NOK/0.98NOK = 1SEK/0.98NOK => 1NOK = 1/0.98 = 1.02SEK
            // 3. use own multiplier, observation value = multiplier * quote.value
            return try swapBaseAndQuote(viewData, baseCurrency: baseCurrency)

        } else {
            // switch via NOK, when base != NOK
            // take out the base from observations
            // create NOK serie
            return try rebaseAndSwap(viewData, baseCurrency: baseCurrency, selectedCurrencies: selectedCurrencies)
        }
    }
}

extension CurrencyConversionViewData {

    private static func rebaseAndSwap(
        _ viewData: Self,
        baseCurrency: NorgesBank.Currency,
        selectedCurrencies: [NorgesBank.Currency]
    ) throws -> Self {

        var series = viewData.series
        guard let index = series.firstIndex(where: { $0.baseCurrency == baseCurrency }) else {
            throw ExchangeError.missingSerieData(baseCurrency)
        }

        // Remove the serie to new base
        // Add it later if NOK is a part of selected currenccies
        let serieToNewBase = series.remove(at: index)

        // Find one unit value in NOK related to new Base currency
        // kunne vi kalt den newBaseRate
//        let newBaseRate = serieToNewBase.LastObservation.value / serieToNewBase.baseValue

        var rebasedSeries = [ExchangeRateSerie]()
        for serie in series {

            let rebasedSerie = rebaseAndSwap(serie: serie, newBaseSerie: serieToNewBase)
            rebasedSeries.append(rebasedSerie)
        }

        // We don't get NOK data from the API, so the 'serieToNewBase' is correcly set up as the serie of NOK
        // Already setup as currency pair (base/NOK)
        if selectedCurrencies.contains(.NOK) {
            rebasedSeries.append(serieToNewBase)
        }

        return .init(
            baseCurrency: viewData.baseCurrency,
            series: rebasedSeries,
            meta: viewData.meta,
            missingSeriesCurrencies: viewData.missingSeriesCurrencies
        )
    }

    private static func rebaseAndSwap(serie: ExchangeRateSerie, newBaseSerie: ExchangeRateSerie) -> ExchangeRateSerie {

        var convertedOservations = [ExchangeRateObservation]()

        for observation in serie.quoteObservations {
            guard
                let baseObservation = newBaseSerie.quoteObservations.first(where: { $0.key == observation.key })
            else {
                print("❌ No matching serie observation ?")
                continue
            }

            // krysskursmetoden
            // 1 USD = 10.3189 NOK
            // 1 SEK = 0.9906 NOK

            // Så nå kan du beregne 1 USD i SEK:
            // 1 USD i SEK = (1 USD i NOK) / (1 SEK i NOK) = 10.3189 / 0.9906 ≈ 10.4195
            // Derfor er 1 USD omtrent 10.4195 SEK (avhengig av de aktuelle valutakursene).

            // baseObservation.value = 10.3189NOK
            // observation.value = 0.9906NOK

            let convertedValue = baseObservation.value / observation.value
            let convertedAsString = (try? convertedValue.formatted(scale: 4)) ?? "N/A"

            let convertedObservation = ExchangeRateObservation(
                id: serie.id,
                value: convertedValue,
                valueAsString: convertedAsString,
                key: observation.key,
                start: observation.start,
                end: observation.end
            )
            convertedOservations.append(convertedObservation)
        }

        return .init(
            id: serie.id,
            frequency: serie.frequency,
            baseCurrency: newBaseSerie.quoteCurrency,
            baseValue: serie.baseValue /* is always 1.0 */,
            quoteCurrency: serie.baseCurrency,
            quoteObservations: convertedOservations,
            decimals: serie.decimals,
            collected: serie.collected
        )
    }
}

extension CurrencyConversionViewData {
    /// Quote currency is in NOK, then we only need to transforme this to the
    private static func swapBaseAndQuote(_ viewData: Self, baseCurrency: NorgesBank.Currency) throws -> Self {
        var swapedSeries = [ExchangeRateSerie]()

        for serie in viewData.series {
            let InvertedSerie = try swapBaseAndQuote(serie, baseCurrency: baseCurrency)
            swapedSeries.append(InvertedSerie)
        }
        return .init(
            baseCurrency: baseCurrency,
            series: swapedSeries,
            meta: viewData.meta,
            missingSeriesCurrencies: viewData.missingSeriesCurrencies
        )
    }

    private static func swapBaseAndQuote(_ serie: ExchangeRateSerie, baseCurrency: NorgesBank.Currency) throws -> ExchangeRateSerie {
        var swapedObservations = [ExchangeRateObservation]()
        for observation in serie.quoteObservations {

            let swapedObservation = try swapBaseAndQuote(
                observation,
                baseValue: serie.baseValue,
                decimals: serie.decimals
            )
            swapedObservations.append(swapedObservation)
        }

        return .init(
            id: serie.id,
            frequency: serie.frequency,
            baseCurrency: serie.quoteCurrency,
            baseValue: 1.0,
            quoteCurrency: serie.baseCurrency,
            quoteObservations: swapedObservations,
            decimals: serie.decimals,
            collected: serie.collected
        )
    }

    private static func swapBaseAndQuote(
        _ observation: ExchangeRateObservation,
        baseValue: Double,
        decimals: Int
    ) throws -> ExchangeRateObservation {

        let swapedValue = baseValue / observation.value

        return .init(
            id: observation.id,
            value: swapedValue,
            valueAsString: try swapedValue.formatted(scale: decimals),
            key: observation.key,
            start: observation.start,
            end: observation.end
        )
    }
}
