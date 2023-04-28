import Foundation

struct BaseCurrencySelectionRowData {
    let currency: NorgesBank.Currency
    let selected: Bool

    init(_ currency: NorgesBank.Currency, selected: Bool) {
        self.currency = currency
        self.selected = selected
    }
}
