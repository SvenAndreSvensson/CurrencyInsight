import SwiftUI

extension View {
    func card(
        withShadow: Bool = true,
        topLeft: CGFloat = .spacingS,
        topRight: CGFloat = .spacingS,
        bottomLeft: CGFloat = .spacingS,
        bottomRight: CGFloat = .spacingS
    ) -> some View {
        self.modifier(
            CardBackground(
                withShadow: withShadow,
                topLeft: topLeft,
                topRight: topRight,
                bottomLeft: bottomLeft,
                bottomRight: bottomRight
            )
        )
    }
}

struct CardBackground: ViewModifier {
    let withShadow: Bool
    var cornerRadii: (topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat)

    init(
        withShadow: Bool = true,
        topLeft: CGFloat = .spacingS,
        topRight: CGFloat = .spacingS,
        bottomLeft: CGFloat = .spacingS,
        bottomRight: CGFloat = .spacingS)
    {
        self.withShadow = withShadow
        self.cornerRadii = (topLeft: topLeft, topRight: topRight, bottomLeft: bottomLeft, bottomRight: bottomRight)
    }

    var hasCustomCornerRadius: Bool {
        [
            cornerRadii.topLeft,
            cornerRadii.topRight,
            cornerRadii.bottomLeft,
            cornerRadii.bottomRight
        ]
        .contains(where: { $0 != 0 })
    }

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, .spacingS)
            .padding(.vertical, .spacingS)
            .background(Color.cardBackground)
            .foregroundColor(.cardForground)
            .if(!hasCustomCornerRadius) { view in
                view.cornerRadius(.cornerRadiusS)
            }
            .if(hasCustomCornerRadius) { view in
                view.customCornerRadius(
                    topLeft: cornerRadii.topLeft,
                    topRight: cornerRadii.topRight,
                    bottomLeft: cornerRadii.bottomLeft,
                    bottomRight: cornerRadii.bottomRight
                )
            }
            .if(withShadow) { view in
                view.shadow(color: .cardShadow, radius: .cornerRadiusS, x: 2, y: 2)
            }
    }
}

struct CustomCornerRadius: ViewModifier {
    var topLeft: CGFloat
    var topRight: CGFloat
    var bottomLeft: CGFloat
    var bottomRight: CGFloat

    func body(content: Content) -> some View {
        content.clipShape(
            RoundedRectangle(
                topLeft: topLeft,
                topRight: topRight,
                bottomLeft: bottomLeft,
                bottomRight: bottomRight
            )
        )
    }
}

struct RoundedRectangle: Shape {
    var topLeft: CGFloat
    var topRight: CGFloat
    var bottomLeft: CGFloat
    var bottomRight: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX + topLeft, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - topRight, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - topRight, y: rect.minY + topRight), radius: topRight, startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRight))
        path.addArc(center: CGPoint(x: rect.maxX - bottomRight, y: rect.maxY - bottomRight), radius: bottomRight, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY - bottomLeft), radius: bottomLeft, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeft))
        path.addArc(center: CGPoint(x: rect.minX + topLeft, y: rect.minY + topLeft), radius: topLeft, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)

        return path
    }
}

extension View {
    func customCornerRadius(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) -> some View {
        self.modifier(CustomCornerRadius(topLeft: topLeft, topRight: topRight, bottomLeft: bottomLeft, bottomRight: bottomRight))
    }
}
