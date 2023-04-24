import SwiftUI

public extension Color {
    // MARK: Primary
    static var backgroundPrimary: Color { color(.backgroundPrimary) }
    static var forgroundPrimary: Color { color(.forgroundPrimary) }

    // MARK: Secondary
    // used in text and icons "on" top of another color
    static var forgroundSecondary: Color { color(.forgroundSecondary) }
    static var backgroundSecondary: Color { color(.backgroundSecondary) }

    // MARK: Card
    static var cardShadow: Color { color(.cardShadow) }
    static var cardForground: Color { color(.cardForground) }
    static var cardBackground: Color { color(.cardBackground) }

    // MARK: Coin
    static var coinForground: Color { color(.coinForground) }
    static var coinBackground: Color { color(.coinBackground) }

    // MARK: Gradient Background
    static var gradientEnd: Color { color(.gradientEnd) }
    static var gradientStart: Color { color(.gradientStart) }

    // MARK: View
    static var backgroundTitleView: Color { color(.backgroundTitleView) }

    private static func color(_ name: ColorName) -> Color {
        Color(name.rawValue, bundle: Bundle.main)
    }
}

enum ColorName: String, CaseIterable {
    case forgroundPrimary
    case backgroundPrimary

    case forgroundSecondary
    case backgroundSecondary

    case cardShadow
    case cardForground
    case cardBackground

    case coinBackground
    case coinForground

    case backgroundTitleView

    case gradientStart
    case gradientEnd
}
