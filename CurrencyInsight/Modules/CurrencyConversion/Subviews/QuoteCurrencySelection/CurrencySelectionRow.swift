import SwiftUI

struct CurrencySelectionRow: View {
    let rowData: CurrencySelectionRowData

    var body: some View {
        HStack(spacing: 15) {
            rowData.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 22.0, height: 22.0)
                .symbolRenderingMode(.multicolor) // Set hierarchical rendering mode for this symbol
                .foregroundColor(rowData.imageColor)
                .onTapGesture {
                    let generator = UIImpactFeedbackGenerator(style: .soft)
                    generator.impactOccurred()
                    rowData.onSelect?()
                }

            HStack(alignment: .center, spacing: 10) {
                Text(rowData.currency.code).font(.system(.body, design: Font.Design.monospaced))
                // Text(", ").font(.body).foregroundColor(.secondary)
                Text(rowData.currency.name).font(.body).foregroundColor(.secondary)
            }

            Spacer()
            if rowData.isMovable {
                Image(systemName: "line.horizontal.3")
                    .foregroundColor(.gray)
            }
        }
        .tag(rowData.currency)
    }
}

struct CurrencyRow_Previews: PreviewProvider {
    static var previews: some View {
        CurrencySelectionRow(rowData:
                .init(
                    currency: .NOK,
                    isMovable: true,
                    image: Image(systemName: "minus.circle.fill"),
                    imageColor: .red,
                    onSelect: nil)
        )
    }
}
