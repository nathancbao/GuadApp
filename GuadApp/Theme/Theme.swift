import SwiftUI

// MARK: - Brand Colors
extension Color {
    static let guadRed      = Color(red: 0.753, green: 0.196, blue: 0.102)  // #C03219
    static let guadGold     = Color(red: 0.941, green: 0.647, blue: 0.000)  // #F0A500
    static let guadCream    = Color(red: 0.984, green: 0.969, blue: 0.937)  // #FBF6EF
    static let guadDark     = Color(red: 0.11,  green: 0.11,  blue: 0.118)  // #1C1C1E
    static let guadGreen    = Color(red: 0.122, green: 0.616, blue: 0.341)  // #1F9D57
    static let guadOrange   = Color(red: 0.910, green: 0.490, blue: 0.180)  // #E87D2E
    static let guadCardBg   = Color.white
    static let guadMedGray  = Color(red: 0.557, green: 0.557, blue: 0.576)  // #8E8E93
}

// MARK: - Design Tokens
enum GuadTheme {
    static let cornerRadius: CGFloat    = 16
    static let cardCornerRadius: CGFloat = 14
    static let cardShadow: CGFloat      = 6
    static let spacing: CGFloat         = 16
    static let cardPadding: CGFloat     = 12

    static func cardShadowStyle() -> some View {
        AnyView(
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .fill(Color.guadCardBg)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)
        )
    }
}
