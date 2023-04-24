import SwiftUI

extension CurrencyConversionStateView {
    class ViewModel: ObservableObject {
        @Published var state: State
        @Published var configuration: CurrencyConversionConfig

        private var previousRequestConfiguration: CurrencyConversionConfig?
        private let client: NorgesBank.ExchangeRatesClient

        init(
            state: State = .initial,
            configuration: CurrencyConversionConfig = .defaultConfiguration(),
            client: NorgesBank.ExchangeRatesClient = .init()
        ) {
            self.state = state
            self.client = client
            self.configuration = configuration
        }

        @MainActor
        func fetchExchangeRates(withFetchingState: Bool = true) async {
            if withFetchingState {
                state = .loading
            }

            var dto: NorgesBank.ExchangeRatesResponse?
            var metaMessage: String = ""

            do {

                if !CurrencyConversionConfig.hasSavedConfiguration && configuration.selectedCurrencies.count == 0 {
                    // setup defaults
                    configuration.selectedCurrencies = [.NOK, .SEK, .DKK, .ISK, .GBP, .EUR, .USD]
                }

                // TODO: should be get all, when no network, you can end up not having all data.
                //dto = try await client.getOneOfAllExchangeRates()
                dto = try await client.getLastNObservations(
                    currencies: configuration.requiredCurrenciesForRequest,
                    locale: "no"
                )
                saveLastDTO(dto: dto)
                metaMessage = ""

            } catch {
                print("❌ Caught an unexpected error: \(error)")
                if let latestDTO = loadLastDTO() {
                    // Present the latestResult
                    dto = latestDTO
                    metaMessage = "Not online, data from previous result"
                } else if let backupDTO = loadBackupDTO() {
                    // Present the backupResult
                    dto = backupDTO
                    metaMessage = "Not online - No previous result - data from fixture backup"
                } else {
                    // Handle the case when no data is available
                    print("❌ we have a PROBLEM Huston!")
                    state = .failed(viewData: .init(message: "Please try again later."))
                    return
                }
            }

            do {
                guard
                    let dto = dto,
                    let viewData: CurrencyConversionView.ViewData = CurrencyConversionView.ViewData.map(
                        dto: dto,
                        configuration: configuration
                    )
                else {
                    state = .failed(viewData: .init( message: "Faild mapping response, Please try again later."))
                    return
                }

                if !NorgesBank.Currency.allCurrencies.contains(configuration.baseCurrency) {
                    configuration.baseCurrency = .NOK
                    CurrencyConversionConfig.save(config: configuration)
                }

                // VALIDATE DATA, Check that we have serie data for the
                if !viewData.missingSeriesCurrencies.isEmpty {
                    configuration.excludedCurrencies = viewData.missingSeriesCurrencies
                    if viewData.missingSeriesCurrencies.contains(viewData.baseCurrency) {
                        configuration.baseCurrency = .NOK
                    }
                    CurrencyConversionConfig.save(config: configuration)
                }

                // switch base and qoute. NOK is quote for all currency pairs
                let swappedViewData = try CurrencyConversionView.ViewData.swapBaseAndQuote(
                    viewData: viewData,
                    baseCurrency: configuration.baseCurrency,
                    selectedCurrencies: configuration.selectedCurrencies
                )

                // Sort
                let viewDataSorted = try CurrencyConversionView.ViewData.sortSeries(
                    viewData: swappedViewData,
                    sortOrder: configuration.selectedCurrencies
                )

                // Add meta about when data is requested and if online or not
                let viewDatawithMeta = CurrencyConversionView.ViewData(
                    baseCurrency: viewDataSorted.baseCurrency,
                    multiplier: viewDataSorted.multiplier,
                    series: viewDataSorted.series,
                    meta: .init(prepared: viewDataSorted.meta.prepared, message: metaMessage),
                    missingSeriesCurrencies: viewDataSorted.missingSeriesCurrencies
                )

                state = .dataLoaded(viewData: viewDatawithMeta)
                previousRequestConfiguration = configuration

            }
            catch let ExchangeError.missingSerieData(currency) {
                print(
                "❌ Unexpected error?, " +
                "the serie for the new base should and must exist: \(currency.code)"
                )

                // TODO: PRESENT FAILIUR
                if currency != .NOK {
                    update(baseCurrency: .NOK)
                }
                // Hmm when base currency is different than .NOK, do I take with new base in the request
                // 1. Yes, fetching all
            }
            catch let ExchangeError.UnexpectedError(message) {
                state = .failed(viewData: .init(message: "\(message).\nPlease try again later."))
            }
            catch {
                state = .failed(viewData: .init(message: "Please try again later."))
            }
        }

        @MainActor
        func fetchExchangeRatesIfNeeded(withFetchingState: Bool = true) async {
            if previousRequestConfiguration != configuration {
                await fetchExchangeRates(withFetchingState: withFetchingState)
            }
        }
    }
}

extension CurrencyConversionStateView.ViewModel {
    private func saveLastDTO(dto: NorgesBank.ExchangeRatesResponse?) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(dto)
            UserDefaults.standard.set(data, forKey: "exchangRatesOneOfAll")
        } catch {
            print("Error saving one of all exchange rates: \(error)")
        }
    }

    private func loadLastDTO() -> NorgesBank.ExchangeRatesResponse? {
        if let data = UserDefaults.standard.data(forKey: "exchangRatesOneOfAll") {
            let decoder = JSONDecoder()
            do {
                let loadedDTO = try decoder.decode(NorgesBank.ExchangeRatesResponse.self, from: data)
                return loadedDTO
            } catch {
                print("Error loading one of all exchange rates: \(error)")
            }
        }
        return nil
    }

    private func loadBackupDTO() -> NorgesBank.ExchangeRatesResponse? {
        return ExchangeRatesFixture.loadFixture(fileName: ExchangeRatesFixture.FixtureCase.exr_all.rawValue)
    }
}

extension CurrencyConversionStateView.ViewModel {
    func update(selectedCurrencies: [NorgesBank.Currency]) {
        configuration.updateSelectedCurrencies(selectedCurrencies)
        CurrencyConversionConfig.save(config: configuration)
        Task { await fetchExchangeRatesIfNeeded(withFetchingState: false)}
    }
}

extension CurrencyConversionStateView.ViewModel {
    enum State {
        case initial
        case loading
        case dataLoaded(viewData: CurrencyConversionView.ViewData)
        case failed(viewData: ErrorMessageViewData)
    }
}

extension CurrencyConversionStateView.ViewModel: CurrencyConversionActions {
    func update(baseCurrency: NorgesBank.Currency) {
        configuration.baseCurrency = baseCurrency
        CurrencyConversionConfig.save(config: configuration)

        Task {
            await fetchExchangeRates(withFetchingState: false)
        }
    }

    func update(multiplier: Double) {
        // save it, then it can be used on refrech.
        // the same amount in text field as whene you start pulling
        CurrencyConversionConfig.save(config: configuration)
    }
}

