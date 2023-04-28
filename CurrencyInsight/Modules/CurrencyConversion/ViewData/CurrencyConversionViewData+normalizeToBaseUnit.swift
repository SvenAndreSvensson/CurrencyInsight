//import Foundation
//
//extension ExchangeRateListViewData {
//    /// Quote currency is in NOK, then we only need to transforme this to the
//    static func normalizeToBaseUnit(viewData: Self) throws -> Self {
//        var normalizedSeries = [ExchangeRateSerie]()
//
//        for serie in viewData.series {
//            let normalizedSerie = try normalizeToBaseUnit(serie: serie)
//            normalizedSeries.append(normalizedSerie)
//        }
//        return .init(
//            baseCurrency: viewData.baseCurrency,
//            multiplier: viewData.multiplier,
//            series: normalizedSeries,
//            meta: viewData.meta,
//            missingSeriesCurrencies: viewData.missingSeriesCurrencies
//        )
//    }
//
//    static func normalizeToBaseUnit(serie: ExchangeRateSerie) throws -> ExchangeRateSerie {
//        var normalizedObservations = [ExchangeRateObservation]()
//        for observation in serie.observations {
//            let normalizedObservation = try normalizeToBaseUnit(
//                observation,
//                units: serie.baseValue,
//                decimals: serie.decimals
//            )
//            normalizedObservations.append(normalizedObservation)
//        }
//
//        return .init(
//            id: serie.id,
//            observations: normalizedObservations,
//            frequncy: serie.frequncy,
//            baseCurrency: serie.baseCurrency,
//            quoteCurrency: serie.quoteCurrency,
//            decimals: serie.decimals,
//            calculated: true,
//            multiplier: 0,
//            collected: serie.collected
//        )
//    }
//
//    private static func normalizeToBaseUnit(
//        _ observation: ExchangeRateObservation,
//        units: Double,
//        decimals: Int
//    ) throws -> ExchangeRateObservation {
//
//        // 1 unit value
//        let oneUnitValue = observation.value / units
//
//        // normalize value
//        // let normalizedValue = try (1.0 / oneUnitValue).rounded(precision: decimals)
//
//        return .init(
//            id: observation.id,
//            value: oneUnitValue,
//            valueAsString: try oneUnitValue.formatted(precision: decimals),
//            key: observation.key,
//            start: observation.start,
//            end: observation.end
//        )
//    }
//}
