import SwiftUI

protocol CurrencyConversionActions {
    func update(baseCurrency: NorgesBank.Currency)
}

struct CurrencyConversionView: View {
    let viewData: CurrencyConversionViewData
    var actions: CurrencyConversionActions?
    @AppStorage("CurrencyConversionView.multiplier") private var multiplier: Double = 1.0
    @FocusState private var isInputActive: Bool

    init(viewData: CurrencyConversionViewData, actions: CurrencyConversionActions? = nil) {
        self.viewData = viewData
        self.actions = actions
    }

    var body: some View {
        ZStack(alignment: .center) {
            background

            ScrollView {

                VStack(spacing: .spacingS) {
                    VStack(spacing: .spacingXXXS) {
                        baseCurrencySelection
                        baseCurrencyInputField
                    }

                    baseAndQuoteDivider

                    quoteCurrencies

                    metaData
                }
                .padding(.horizontal, .spacingXS)
                .navigationTitle("Convert")
                .onTapGesture {
                    isInputActive = false
                }
            }
        }
    }

    private var background: some View {
        LinearGradient(gradient: Gradient(colors: [Color.gradientStart, Color.gradientEnd]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
    }

    var baseCurrencySelection: some View {
        NavigationLink {
            BaseCurrencySelectionView(viewModel:
                    .init(
                        selected: viewData.baseCurrency,
                        currencies: NorgesBank.Currency.allCurrencies)
            ) { newBaseCurrencySelection in
                actions?.update(baseCurrency: newBaseCurrencySelection)
            }
        } label: {
            baseCurrencyLabel
        }
    }

    var baseCurrencyLabel: some View {
        HStack(alignment: .center, spacing: .spacingS) {
            RoundFlag(currency: viewData.baseCurrency)

            VStack(alignment: .leading, spacing: .spacingXXXS) {
                Text( viewData.baseCurrency.code)
                    .font(.callout)
                    .foregroundColor(.secondary)

                Text(viewData.baseCurrency.name)
            }

            Spacer()
            Image(systemName: "chevron.forward")
                .foregroundColor(.forgroundSecondary)
        }
        .card(withShadow: true, bottomLeft: 0, bottomRight: 0)
    }

    var baseCurrencyInputField: some View {
        CurrencyInputField(viewModel: .init(multiplier: $multiplier, currency: viewData.baseCurrency) )
        .card(withShadow: true, topLeft: 0, topRight: 0)
        .focused($isInputActive)
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Close") {
                    isInputActive = false
                }
            }
        }
    }

    var baseAndQuoteDivider: some View {
        HStack(spacing: .spacingL) {
            HorizontalDivider()
            Image(systemName: "arrow.up.arrow.down")
                .resizable()
                .foregroundColor(.secondary)
                .frame(width: 20, height: 20)

            HorizontalDivider()
        }
        .padding(.vertical, .spacingXS)
        .padding(.horizontal, .spacingL)
    }

    var quoteCurrencies: some View {
        LazyVStack {
            ForEach(viewData.series) { serie in
                HStack(alignment: .center, spacing: .spacingXS) {
                    quoteCurrency(serie: serie)
                        .contextMenu {
                            Button(action: {
                                actions?.update(baseCurrency: serie.quoteCurrency)
                            }) {
                                Text("Set as base currency")
                            }
                        }
                }
            }
        }
    }

    var metaData: some View {
        VStack(alignment: .leading, spacing: .spacingXXS) {
            Text(viewData.meta.prepared.formatted())

            if !viewData.meta.message.isEmpty {
                Text(viewData.meta.message)
            }
        }
    }

    func quoteCurrency(serie: ExchangeRateSerie) -> some View {
        HStack(alignment: .center, spacing: .spacingS) {
            RoundFlag(currency: serie.quoteCurrency)

            VStack(alignment: .leading, spacing: .spacingXXXS) {
                HStack(alignment: .center, spacing: .spacingXXS) {
                    Text(serie.quoteCurrency.code)
                        .font(.callout)
                        .foregroundColor(.secondary)

                    Spacer()
//                    Text(viewModel.calculateQuoteValue(serie: serie))
                    Text(serie.calculateQuoteValue(multiplier: multiplier))
                    Text(serie.quoteCurrency.symbol)
                        .foregroundColor(.secondary)
                }
                Text(serie.quoteCurrency.name)
            }
        }
        .card(withShadow: true)
    }
}

struct ExchangeRatesView_Previews: PreviewProvider {
    static let viewData = ExchangeRatesFixture.viewData()
    static var previews: some View {
        CurrencyConversionView(viewData: viewData)
            //.preferredColorScheme(.dark)
    }
}
