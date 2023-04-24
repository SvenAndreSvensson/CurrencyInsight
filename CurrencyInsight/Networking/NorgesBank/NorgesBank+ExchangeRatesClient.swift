//
//  ExchangeratesClient.swift
//  Networking
//
//  Created by Sven Svensson on 09/02/2023.
//

import Foundation

extension NorgesBank {
    class ExchangeRatesClient: ApiClient {

        func getExchangeRates(
            frequency: SeriesFrequency,
            interval: DateInterval,
            currencies: [Currency]
        ) async throws -> ExchangeRatesResponse {
            return try await ApiRequestLoader(
                apiRequest: GetExchangeRatesRequest(
                    frequency: frequency,
                    interval: interval,
                    currencies: currencies
                ),
                networkSession: networkSession
            )
            .load()
        }

        func getOneOfAllExchangeRates() async throws -> ExchangeRatesResponse {
            return try await ApiRequestLoader(
                apiRequest: GetOneOfAllExchangeRatesRequest(),
                networkSession: networkSession
            )
            .load()
        }

        func getLastNObservations(
            currencies: [NorgesBank.Currency],
            locale: String = "no"
        ) async throws -> ExchangeRatesResponse {
            return try await ApiRequestLoader(
                apiRequest: GetLastNObservationsRequest(currencies: currencies, locale: locale),
                networkSession: networkSession
            )
            .load()

        }
    }
}
