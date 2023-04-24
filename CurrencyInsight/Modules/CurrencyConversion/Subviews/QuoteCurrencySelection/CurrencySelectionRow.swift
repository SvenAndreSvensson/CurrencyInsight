import SwiftUI

struct CurrencySelectionRow: View {
    let currency: NorgesBank.Currency
    let isMovable: Bool
    let actionImage: Image
    let actionImageColor: Color
    let action: () -> Void

    var body: some View {
        HStack(spacing: 15) {
            actionImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 22.0, height: 22.0)
                .symbolRenderingMode(.multicolor) // Set hierarchical rendering mode for this symbol
                .foregroundColor(actionImageColor)
                .onTapGesture {
                    let generator = UIImpactFeedbackGenerator(style: .soft)
                    generator.impactOccurred()
                    action()
                }

            HStack(alignment: .center, spacing: 10) {
                Text(currency.code).font(.system(.body, design: Font.Design.monospaced))
                // Text(", ").font(.body).foregroundColor(.secondary)
                Text(currency.name).font(.body).foregroundColor(.secondary)
            }

            Spacer()
            if isMovable {
                Image(systemName: "line.horizontal.3")
                    .foregroundColor(.gray)
            }
        }
        .tag(currency)
    }
}

struct CurrencyRow_Previews: PreviewProvider {
    static var previews: some View {
        CurrencySelectionRow(
            currency: .SEK,
            isMovable: false,
            actionImage: Image(systemName: "minus.circle.fill"),
            actionImageColor: .green,
            action: {}
        )
    }
}
