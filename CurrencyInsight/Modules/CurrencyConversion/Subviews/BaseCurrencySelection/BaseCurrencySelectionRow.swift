import SwiftUI

struct BaseCurrencySelectionRow: View {
    var viewData: BaseCurrencySelectionRowData

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
