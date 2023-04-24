import SwiftUI

struct RoundFlag: View {
    let currency: NorgesBank.Currency

    var body: some View {
        currency.flag
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.primary, lineWidth: 0.5))
            .shadow(radius: 2)
    }
}

struct RoundFlag_Previews: PreviewProvider {
    static var previews: some View {
        RoundFlag(currency: .NOK)
    }
}
