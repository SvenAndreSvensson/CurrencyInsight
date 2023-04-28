import SwiftUI

struct BaseCurrencySelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: BaseCurrencySelectionViewModel
    var onSelect: ((NorgesBank.Currency) -> Void)?

    var body: some View {
        List {
            ForEach(viewModel.filteredCurrencies) { currency in
                Button {
                    onSelect?(currency)
                    dismiss()
                } label: {
                    BaseCurrencySelectionRow(viewData: .init(currency, selected: currency.id == viewModel.selected.id))
                        .cornerRadius(.cornerRadiusS)
                }
            }
        }
        .searchable(
            text: $viewModel.searchable,
            placement: SearchFieldPlacement.automatic, prompt: "Search currencies..."
        )
        .listStyle(.plain)
        .navigationTitle("Select Base Currency")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }

    
}

struct BaseCurrencySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        BaseCurrencySelectionView(viewModel: .init(selected: .NOK, currencies: [.NOK, .SEK, .USD]))
    }
}
