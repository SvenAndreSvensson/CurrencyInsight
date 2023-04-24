//
//  Models.swift
//  Networking
//
//  Created by Sven Svensson on 01/04/2023.
//

import Foundation

extension NorgesBank {

    // Response

    public struct ExchangeRatesResponse: Codable {
        let meta: ExchangeRatesMeta
        let data: ExchangeRatesData
    }

    struct ExchangeRatesData: Codable {
        var dataSets: [ExchangeRateDataSet]
        var structure: ExchangeRateStructure
    }

    struct ExchangeRateDataSet: Codable {
        var links: [NbLink]
        var action: String
        var series: [String: NBSerie]
    }

    struct ExchangeRateStructure: Codable {
        var links: [NbLink]
        var name: String
        var names: [String: String]
        var description: String
        var descriptions: [String: String]
        var dimensions: NbDimensions
        var attributes: NbAttributes
    }

    /// Frekvens.BasisValuta.Valuta.Tenor
    enum NbDemensionSeriesKey: String {

        /// Frequency of series to be retrieved
        /// M - Monthly, A - Annual, B - Business
        case FREQ

        /// Base currency - Currency you want to see the exchange rate for
        /// example: USD, EUR, NOK, SEK
        case BASE_CUR
        case QUOTE_CUR
        case TENOR
    }

    enum NbDemensionOservationKey: String {
        /// The time interval for observations over a given time period.
        case TIME_PERIOD
    }

    enum NbExrRequestType: String, CaseIterable {
        case timeInterval, lastNObservations, firstNObservations
    }

    /* Supports English and Norwegian */
    struct NbLocale {
        let value: String
        let name: String

        static let no: Self = .init(value: "no", name: "Norwegian")
        static let en: Self = .init(value: "en", name: "English")
    }

//    struct CodeValue: Hashable {
//        // Used for
//        // examples: SerieFrequence:B for buisnesss, Local: AUG for Australien dollar, sp for Spot
//        var code: String
//        var value: String
//    }

    struct NbDimensions {
        var dataSets: [ExchangeRateDataSet]?
        var series: [NbDimensionsSerie]
        var observation: [NbDimensionsObservation]
    }

    struct NbAttributes {
        var series: [NbAttributeSerie]
    }

    struct NbAttributeSerie: Codable {
        var id: String
        var name: String
        var description: String
        var relationship: NbAttributeDimension
        var role: String?
        var values: [NbValue]
    }

    struct NbAttributeDimension: Codable {
        var dimensions: [String]
    }

    struct NbDimensionsSerie: Codable {
        var id: String
        var name: String
        var description: String
        var keyPosition: Int
        var role: String?
        var values: [NbValue]
    }

    struct NbDimensionsObservation: Codable {
        var id: String
        var name: String
        var description: String
        var keyPosition: Int
        var role: String?
        var values: [NbTimeValue]
    }

    struct NbValue: Codable {
        var id: String
        var name: String
    }

    struct NbTimeValue: Identifiable, Codable {
        var id: String
        var name: String
        var start: Date
        var end: Date
    }

    struct NbLink: Codable {
        var rel: String
        var urn: String
        var uri: String?
    }

    struct NBSerie: Codable {
        var attributes: [Int]
        var observations: [Int: [String]]
    }

    // META

    struct ExchangeRatesMeta: Codable {
        var id: String
        var prepared: Date
        var test: Bool
        var sender: NbEndpoint
        var receiver: NbEndpoint
        var links: [NbMetaLink]
    }

    struct NbEndpoint: Codable {
        var id: String
    }

    struct NbMetaLink: Identifiable {
        var id = UUID()

        var href: String
        var rel: String
        var uri: String?
    }
}

extension NorgesBank.NbDimensions: Codable {
    enum CodingKeys: String, CodingKey {
        case dataSets, series, observation
    }
}
extension NorgesBank.NbAttributes: Codable {
    enum CodingKeys: String, CodingKey {
        case series
    }
}

extension NorgesBank.NbMetaLink: Codable {
    enum CodingKeys: String, CodingKey {
        case href, rel, uri
    }
}

