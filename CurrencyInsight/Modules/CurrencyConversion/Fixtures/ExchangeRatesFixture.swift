//
//  ExchangeRatesFixture.swift
//  Networking
//
//  Created by Sven Svensson on 04/03/2023.
//

import Foundation

struct ExchangeRatesFixture {

    static func loadData(fileName: String) -> Data? {
        guard
            let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
            let data = try? Data(contentsOf: url)
        else {
            return nil
        }
        return data
    }

    static func loadFixture(fileName: String) -> NorgesBank.ExchangeRatesResponse? {
        guard let data = loadData(fileName: fileName) else { return nil }

        return try? JSONDecoder.norgesBankDecoder.decode(NorgesBank.ExchangeRatesResponse.self, from: data)
    }

    static func viewData(
        for fixtureCase: FixtureCase = .exr_1mnd_of_Business_USD_GBP_DKK_EUR_SEK
    ) -> CurrencyConversionView.ViewData {
        guard let dto = loadFixture(fileName: fixtureCase.rawValue) else {
            fatalError("❌ we couldn't find the fixture for \(fixtureCase.rawValue)")
        }

        guard let viewData = CurrencyConversionView.ViewData.map(
            dto: dto,
            configuration: .defaultConfiguration()
        ) else {
            fatalError("❌ we couldn't find the fixture for \(fixtureCase.rawValue)")
        }
        return viewData
    }
}

extension ExchangeRatesFixture {
    enum FixtureCase: String {
        case exr_1week_of_Business_USD
        case exr_1mnd_of_Business_USD_GBP_DKK_EUR_SEK
        case exr_10years_of_Annual_USD_GBP_DKK_EUR_SEK
        case exr_12months_of_Monthly_USD_GBP_DKK_EUR_SEK
        case exr_all
    }
}
