import SwiftUI

struct CurrencySelectionRowData {
    let currency: NorgesBank.Currency
    let isMovable: Bool
    let image: Image
    let imageColor: Color
    let onSelect: (() -> Void)?
}
