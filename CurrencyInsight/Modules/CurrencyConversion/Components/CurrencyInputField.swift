import SwiftUI

struct CurrencyInputField: View {
    @ObservedObject var viewModel: CurrencyInputFieldModel
    var update: ((_ newMultiplier:Double) -> Void)?

    var body: some View {
        VStack(spacing: .spacingM) {
            HStack {
                currencySymbol

                currencyInputField

                clearInputFieldButton
            }
            .background(Color(.systemGray6))
            .cornerRadius(.cornerRadiusM)

            errorMessage
        }
    }

    var currencySymbol: some View {
        Text(viewModel.currency.symbol)
            .foregroundColor(.gray)
            .padding(.leading, .spacingXS)
    }

    var currencyInputField: some View {
        TextField("Enter amount (e.g., \(viewModel.currency.symbol) 100)", text: $viewModel.textField)
            .keyboardType(.decimalPad)
            .padding(.vertical, 8)
            .onChange(of: viewModel.textField) { newInput in
                viewModel.validateTyped(input: newInput)
                update?(viewModel.multiplier)
            }
    }

    @ViewBuilder
    var clearInputFieldButton: some View {
        if !viewModel.textField.isEmpty {
            Button { viewModel.textField = "" } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
            .padding(.trailing, .spacingXS)
        }
    }

    @ViewBuilder
    var errorMessage: some View {
        if let errorMessage = viewModel.errorMessage {
            Text(errorMessage)
                .foregroundColor(.red)
        }
    }
}

struct CurrencyInputField_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyInputField(viewModel:
                .init(
                    multiplier: 1.0,
                    currency: .NOK,
                    formatter: NumberFormatter.currencyTextField
                )
        )
    }
}
