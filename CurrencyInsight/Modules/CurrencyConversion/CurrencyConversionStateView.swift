import SwiftUI

struct CurrencyConversionStateView: View {
    @ObservedObject var viewModel: CurrencyConversionStateViewModel

    var body: some View {
        switch viewModel.state {
        case .initial:
            CurrencyConversionView(viewData: .placeholder)
                .redacted(reason: .placeholder)
                .task { await viewModel.fetchExchangeRates() }

        case .loading:
            CurrencyConversionView(viewData: .placeholder)
                .redacted(reason: .placeholder)

        case let .dataLoaded(viewData):
            NavigationView {
                exchangeRateListView(viewData: viewData)
            }

        case let .failed(viewData):
            ErrorMessageView(viewData: viewData) {
                viewModel.state = .initial
            }
        }
    }

    func exchangeRateListView(viewData: CurrencyConversionViewData) -> some View {
        CurrencyConversionView(viewData: viewData, actions: viewModel)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.showingCurrencySelection.toggle() }) {
                        Text("Edit")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingCurrencySelection, onDismiss: {
                Task { await viewModel.fetchExchangeRatesIfNeeded(withFetchingState: false) }
            }) {
                CurrencySelectionView(
                    viewModel:
                            .init(
                                currencies: viewModel.configuration.availableCurrencies,
                                selectedCurrencies: viewModel.configuration.selectedCurrencies
                            ), onDone:  viewModel.update
                )
            }
            .refreshable {
                await viewModel.fetchExchangeRates(withFetchingState: false)
            }
    }
}

struct CurrencyConversionStateView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CurrencyConversionStateView(viewModel: .init())
                .preferredColorScheme(.light)
                .previewDisplayName("Light Mode")

            CurrencyConversionStateView(viewModel: .init())
                //.preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")

            CurrencyConversionStateView(viewModel: .init(state: .loading))
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode - loading")

            CurrencyConversionStateView(viewModel: .init(state: .failed(viewData: .init())))
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode - failed")

        }
    }
}
