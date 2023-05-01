import SwiftUI

class CurrencyConversionStateViewModel: ObservableObject {
    @Published var state: State
    @Published var configuration: CurrencyConversionConfig
    @Published var showingCurrencySelection: Bool

    // Used to check if it is nesesary to do a update
    private var previousRequestConfiguration: CurrencyConversionConfig?
    private let client: NorgesBank.ExchangeRatesClient

    init(
        state: State = .initial,
        configuration: CurrencyConversionConfig = .defaultConfiguration(),
        client: NorgesBank.ExchangeRatesClient = .init(),
        showingCurrencySelection: Bool = false
    ) {
        self.state = state
        self.client = client
        self.configuration = configuration
        self.showingCurrencySelection = showingCurrencySelection
    }

    @MainActor
    func fetchExchangeRates(withFetchingState: Bool = true) async {
        if withFetchingState {
            state = .loading
        }

        var dto: NorgesBank.ExchangeRatesResponse?
        var metaMessage: String = ""

        if !CurrencyConversionConfig.hasSavedConfiguration && configuration.selectedCurrencies.isEmpty {
            // Add default currencies for first-time app usage
            configuration.selectedCurrencies = [.NOK, .SEK, .DKK, .ISK, .GBP, .EUR, .USD]
        }

        do {
            // Fetch data for all currencies to enable offline usage
            dto = try await client.getOneOfAllExchangeRates()
            saveLastDTO(dto: dto)
            metaMessage = ""

        } catch {
            print("❌ Unexpected error: \(error)")

            if let latestDTO = loadLastDTO() {
                // Load data from the latest result
                dto = latestDTO
                metaMessage = "Offline, using previous result"
            } else if let backupDTO = loadBackupDTO() {
                // Load data from fixture backup
                dto = backupDTO
                metaMessage = "Offline - No previous result - Using fixture backup"
            } else {
                // Handle case when no data is available
                print("❌ Houston, we have a problem!")
                state = .failed(viewData: .init(message: "Please try again later."))
                return
            }
        }

        do {
            guard
                let dto = dto,
                let viewData: CurrencyConversionViewData = CurrencyConversionViewData.map(
                    dto: dto,
                    configuration: configuration
                )
            else {
                state = .failed(viewData: .init(message: "Failed mapping response. Please try again later."))
                return
            }

            if !NorgesBank.Currency.allCurrencies.contains(configuration.baseCurrency) {
                configuration.baseCurrency = .NOK
                CurrencyConversionConfig.save(config: configuration)
            }

            // VALIDATE DATA
            // TODO: Add comments explaining the validation process
            if !viewData.missingSeriesCurrencies.isEmpty {
                configuration.excludedCurrencies = viewData.missingSeriesCurrencies
                if viewData.missingSeriesCurrencies.contains(viewData.baseCurrency) {
                    configuration.baseCurrency = .NOK
                }
                CurrencyConversionConfig.save(config: configuration)
            }

            // Filter, swap, and sort view data
            let filteredViewData = try CurrencyConversionViewData.filter(
                viewData: viewData,
                includedCurrencies: configuration.requiredCurrenciesForPresentation
            )
            let swappedViewData = try CurrencyConversionViewData.swapBaseAndQuote(
                viewData: filteredViewData,
                baseCurrency: configuration.baseCurrency,
                selectedCurrencies: configuration.selectedCurrencies
            )
            let viewDataSorted = try CurrencyConversionViewData.sortSeries(
                viewData: swappedViewData,
                sortOrder: configuration.selectedCurrencies
            )

            // Add metadata about the request and online status
            let viewDataWithMeta = CurrencyConversionViewData(
                baseCurrency: viewDataSorted.baseCurrency,
                series: viewDataSorted.series,
                meta: .init(prepared: viewDataSorted.meta.prepared, message: metaMessage),
                missingSeriesCurrencies: viewDataSorted.missingSeriesCurrencies
            )

            state = .dataLoaded(viewData: viewDataWithMeta)
            previousRequestConfiguration = configuration

        } catch let ExchangeError.missingSerieData(currency) {
            print("❌ Unexpected error: missing series" +
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

extension CurrencyConversionStateViewModel {
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

extension CurrencyConversionStateViewModel {
    func update(selectedCurrencies: [NorgesBank.Currency]) {
        configuration.updateSelectedCurrencies(selectedCurrencies)
        CurrencyConversionConfig.save(config: configuration)
        Task { await fetchExchangeRatesIfNeeded(withFetchingState: false)}
    }
}

extension CurrencyConversionStateViewModel {
    enum State {
        case initial
        case loading
        case dataLoaded(viewData: CurrencyConversionViewData)
        case failed(viewData: ErrorMessageViewData)
    }
}

extension CurrencyConversionStateViewModel: CurrencyConversionActions {
    func update(baseCurrency: NorgesBank.Currency) {
        configuration.baseCurrency = baseCurrency
        CurrencyConversionConfig.save(config: configuration)

        Task {
            await fetchExchangeRates(withFetchingState: false)
        }
    }
}
