import SwiftUI

struct HorizontalDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color(.separator))
            .frame(height: 1)
            .edgesIgnoringSafeArea(.horizontal)
    }
}

struct HorizontalDivider_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            HorizontalDivider()
            Image(systemName: "arrow.up.arrow.down.circle.fill")
                .resizable()
                .frame(width: 34, height: 34)
            HorizontalDivider()
        }
        .padding()
    }
}
