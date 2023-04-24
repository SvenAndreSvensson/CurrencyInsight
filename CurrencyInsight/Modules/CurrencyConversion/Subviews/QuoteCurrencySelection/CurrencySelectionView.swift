import SwiftUI

struct CurrencySelectionView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ViewModel
    var onDone:(([NorgesBank.Currency])  -> Void)?

    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(viewModel.filteredSelectedCurrencies) { currency in
                        selectedCurrency(currency)
                    }
                    .onMove(perform: viewModel.moveSelection)
                } header: { selectedCurrenciesHeader }

                Section {
                    ForEach(viewModel.filteredAvailableCurrencies) { currency in
                        availableCurrency(currency)
                    }
                } header: { availableCurrencyHeader }
            }
            .searchable(text: $viewModel.searchString, prompt: "Search currencies...")
            .listStyle(InsetGroupedListStyle())
            .toolbar { toolbar }
        }
    }

    func selectedCurrency(_ currency: NorgesBank.Currency) -> some View {
        CurrencySelectionRow(
            currency: currency,
            isMovable: true,
            actionImage: Image(systemName: "minus.circle.fill"),
            actionImageColor: .red
        ) {
            viewModel.removeFromSelected(currency: currency)
        }
    }

    var selectedCurrenciesHeader: some View {
        HStack {
            Text("Selected Currencies")
            Spacer()

            if !viewModel.selectedCurrencies.isEmpty {
                Button { viewModel.unselectAll() } label: {
                    Text("Clear selection")
                        .textCase(.none)
                }
            }
        }
    }

    func availableCurrency(_ currency: NorgesBank.Currency) -> some View {
        CurrencySelectionRow(
            currency: currency,
            isMovable: false,
            actionImage: Image(systemName: "plus.circle.fill"),
            actionImageColor: .green
        ) {
            viewModel.addToSelected(currency: currency)
        }
    }

    var availableCurrencyHeader: some View {
        HStack {
            Text("Available Currencies")
            Spacer()
            if !viewModel.currencies.isEmpty {
                Button { viewModel.selectAll() } label: {
                    Text("select all")
                        .textCase(.none)
                }
            }
        }
    }

    var toolbar: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                    onDone?(viewModel.selectedCurrencies)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}

struct CurrencySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencySelectionView(
            viewModel:
                    .init(
                        currencies: [.SEK, .EUR, .AUD, .BDT],
                        selectedCurrencies: [.BRL]
                    )
        )
    }
}
