import SwiftUI

extension BaseCurrencySelectionRow {
    class ViewData {
        var currency: NorgesBank.Currency
        var selected: Bool

        init(_ currency: NorgesBank.Currency, selected: Bool) {
            self.currency = currency
            self.selected = selected
        }
    }
}

struct BaseCurrencySelectionRow: View {
    var viewData: ViewData

    var body: some View {

        HStack(alignment: .center, spacing: .spacingS) {
            RoundFlag(currency: viewData.currency)

            VStack(alignment: .leading, spacing: .spacingXXS) {
                currencyCode
                currencyName
            }

            Spacer()
            checkMarkIfSelected
        }
    }

    var currencyCode: some View {
        Text(viewData.currency.code)
            .font(.callout)
            .foregroundColor(.secondary)
    }

    var currencyName: some View {
        Text(viewData.currency.name)
    }

    @ViewBuilder
    var checkMarkIfSelected: some View {
        if viewData.selected {
            Image(systemName: "checkmark")
               
        }
    }
}

struct BaseCurrencySelectionRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            BaseCurrencySelectionRow(viewData: .init(.NOK, selected: false))
            BaseCurrencySelectionRow(viewData: .init(.NOK, selected: true))
        }
    }
}
