import SwiftUI

struct ErrorMessageViewData {
    let title: String
    let message: String

    init(
        title: String = "Oops! An error occurred.",
        message: String = "Please try again later."
    ) {
        self.title = title
        self.message = message
    }
}

struct ErrorMessageView: View {
    let viewData: ErrorMessageViewData
    var retry: (()-> Void)?

    var body: some View {
        ZStack {
            background
            
            VStack {
                Text(viewData.title)
                    .font(.headline)
                    .foregroundColor(.red)

                Text(viewData.message)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Button(action: {
                    retry?()
                }) {
                    Text("Retry")
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }

    private var background: some View {
        LinearGradient(gradient: Gradient(colors: [Color.gradientStart, Color.gradientEnd]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
    }
}

struct ErrorMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorMessageView(viewData: .init())
    }
}
