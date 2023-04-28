import Foundation

struct CurrencyConversionConfig: Codable {
    var frequency: NorgesBank.SeriesFrequency
    var interval: DateInterval
    /// Selected currencies: This list contains the currencies that you have already chosen.
    /// These currencies are no longer available in the list of available currencies.
    var selectedCurrencies: [NorgesBank.Currency]
    var excludedCurrencies: [NorgesBank.Currency]
    var baseCurrency: NorgesBank.Currency
    var multiplier: Double

    init(
        frequency: NorgesBank.SeriesFrequency = .defaultFrequency,
        interval: DateInterval = .defaultInterval,
        selectedCurrencies: [NorgesBank.Currency] = [],
        excludedCurrencies: [NorgesBank.Currency] = [],
        baseCurrency: NorgesBank.Currency = .NOK,
        multiplier: Double = 1
    ) {
        self.frequency = frequency
        self.interval = interval
        self.selectedCurrencies = selectedCurrencies
        self.excludedCurrencies = excludedCurrencies
        self.baseCurrency = baseCurrency
        self.multiplier = multiplier
    }
}

extension CurrencyConversionConfig {
    /// Available currencies: This list contains all the currency options that you can choose from. These currencies have not been selected yet.
    var availableCurrencies: [NorgesBank.Currency] {
        NorgesBank.Currency.allCurrencies.filter {
            !excludedCurrencies.contains($0) && !selectedCurrencies.contains($0) && $0 != baseCurrency
        }
    }

    var requiredCurrenciesForRequest: [NorgesBank.Currency] {
        var list = selectedCurrencies
        if baseCurrency != .NOK && !selectedCurrencies.contains(baseCurrency) {
            list.append(baseCurrency)
        }
        return list
    }

    var requiredCurrenciesForPresentation: [NorgesBank.Currency] {
        var list = selectedCurrencies
        if baseCurrency != .NOK && !selectedCurrencies.contains(baseCurrency) {
            list.append(baseCurrency)
        }
        return list
    }
}

extension CurrencyConversionConfig {
    mutating func updateSelectedCurrencies(_ newSelectedCurrencies: [NorgesBank.Currency]) {
        selectedCurrencies = newSelectedCurrencies
    }
}

extension CurrencyConversionConfig {

    static func save(config: Self) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(config)
            UserDefaults.standard.set(data, forKey: "exchangeRateConfig")
        } catch {
            print("Error saving exchange rate config: \(error)")
        }
    }

    static func loadConfig() -> CurrencyConversionConfig? {
        if let data = UserDefaults.standard.data(forKey: "exchangeRateConfig") {
            let decoder = JSONDecoder()
            do {
                let loadedConfig = try decoder.decode(CurrencyConversionConfig.self, from: data)
                return loadedConfig
            } catch {
                print("Error decoding exchange rate config: \(error)")
            }
        }
        return nil
    }

    static var hasSavedConfiguration: Bool {
        loadConfig() != nil
    }
}

extension CurrencyConversionConfig {
    static func defaultConfiguration() -> CurrencyConversionConfig {
           return CurrencyConversionConfig(
               frequency: NorgesBank.SeriesFrequency.defaultFrequency,
               interval: DateInterval.defaultInterval,
               selectedCurrencies: [NorgesBank.Currency](),
               excludedCurrencies: [NorgesBank.Currency]()
           )
       }
}

extension CurrencyConversionConfig: Hashable {}
