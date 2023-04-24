import SwiftUI

extension CurrencySelectionView {
    class ViewModel: ObservableObject {
        @Published var currencies: [NorgesBank.Currency]
        @Published var selectedCurrencies: [NorgesBank.Currency]
        @Published var searchString: String

        init(currencies: [NorgesBank.Currency], selectedCurrencies: [NorgesBank.Currency], searchString: String = "") {
            self.currencies = currencies
            self.selectedCurrencies = selectedCurrencies
            self.searchString = searchString
        }

        var filteredSelectedCurrencies: [NorgesBank.Currency] {
            if searchString.isEmpty {
                return selectedCurrencies
            } else {
                return selectedCurrencies.filter {
                    $0.code.lowercased().contains(searchString.lowercased()) ||
                    $0.name.lowercased().contains(searchString.lowercased())
                }
            }
        }

        var filteredAvailableCurrencies: [NorgesBank.Currency] {
            if searchString.isEmpty {
                return currencies
            } else {
                return currencies.filter {
                    $0.code.lowercased().contains(searchString.lowercased()) ||
                    $0.name.lowercased().contains(searchString.lowercased())
                }
            }
        }

        func addToSelected(currency: NorgesBank.Currency) {
            withAnimation {
                currencies.removeAll { $0.id == currency.id }
                selectedCurrencies.append(currency)
            }
        }

        func removeFromSelected(currency: NorgesBank.Currency) {
            withAnimation {
                selectedCurrencies.removeAll { $0.id == currency.id }
                currencies.append(currency)
                currencies.sort { $0.name < $1.name }
            }
        }

        func moveSelection(from source: IndexSet, to destination: Int) {
            selectedCurrencies.move(fromOffsets: source, toOffset: destination)
        }

        func selectAll(){
            for currency in currencies {
                currencies.removeAll { $0.id == currency.id }
                selectedCurrencies.append(currency)
            }
        }

        func unselectAll(){
            for currency in selectedCurrencies {
                selectedCurrencies.removeAll { $0.id == currency.id }
                currencies.append(currency)
            }
            currencies.sort { $0.name < $1.name }
        }
    }
}
