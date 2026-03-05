import SwiftUI

struct MenuItemCard: View {
    let item: MenuItem

    private var accentColor: Color {
        Color(hex: item.cardColorHex) ?? Color.guadGold.opacity(0.3)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // ── Graphic Area ──────────────────────────────────────────────────
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(accentColor.opacity(0.55))
                    .frame(height: 110)
                    .overlay(
                        Text(item.category.emoji)
                            .font(.system(size: 48))
                            .opacity(0.8)
                    )

                // Popular badge
                if item.isPopular {
                    Text("★ Popular")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(Color.guadOrange)
                        .clipShape(Capsule())
                        .padding(8)
                }

                // Vegetarian badge
                if item.isVegetarian {
                    VStack {
                        Spacer()
                        HStack {
                            Text("🌿 Veggie")
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundColor(.guadGreen)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(Color.guadGreen.opacity(0.12))
                                .clipShape(Capsule())
                                .padding(8)
                            Spacer()
                        }
                    }
                }
            }

            // ── Text Area ─────────────────────────────────────────────────────
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.guadDark)
                    .lineLimit(1)

                Text(item.description)
                    .font(.system(size: 11))
                    .foregroundColor(.guadMedGray)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                HStack {
                    Text(String(format: "$%.2f", item.price))
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.guadRed)

                    Spacer()

                    // Add button
                    ZStack {
                        Circle()
                            .fill(Color.guadRed)
                            .frame(width: 28, height: 28)
                        Image(systemName: "plus")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.top, 2)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
        }
        .background(Color.guadCardBg)
        .clipShape(RoundedRectangle(cornerRadius: GuadTheme.cardCornerRadius))
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)
    }
}

// MARK: - Color(hex:) Helper
extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        guard hexSanitized.count == 6,
              let rgb = UInt64(hexSanitized, radix: 16)
        else { return nil }
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8)  & 0xFF) / 255
        let b = Double(rgb         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
