import Foundation

class BaseCurrencySelectionViewModel: ObservableObject {
    let selected: NorgesBank.Currency
    let currencies: [NorgesBank.Currency]
    @Published var searchable: String

    init(selected: NorgesBank.Currency, currencies: [NorgesBank.Currency], searchable: String = "") {
        self.selected = selected
        self.currencies = currencies
        self.searchable = ""
    }

    var filteredCurrencies: [NorgesBank.Currency] {
        if searchable.isEmpty {
            return currencies
        } else {
            return currencies.filter {
                $0.code.lowercased().contains(searchable.lowercased()) ||
                $0.name.lowercased().contains(searchable.lowercased())
            }
        }
    }
}
