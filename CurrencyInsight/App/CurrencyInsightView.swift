import SwiftUI

struct CurrencyInsightView: View {
    var body: some View {
        CurrencyConversionStateView(viewModel:
                .init(
                    state: .initial,
                    configuration: CurrencyConversionConfig.loadConfig() ?? .defaultConfiguration(),
                    client: .init()
                )
        )
    }
}

struct CurrencyInsightView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyInsightView()
    }
}
