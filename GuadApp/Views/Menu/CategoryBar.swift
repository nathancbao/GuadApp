import SwiftUI

struct CategoryBar: View {
    @Binding var selected: MenuCategory

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(MenuCategory.allCases, id: \.self) { cat in
                    CategoryPill(
                        category: cat,
                        isSelected: selected == cat
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selected = cat
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
        }
        .background(Color.guadCream)
    }
}

// MARK: - Category Pill
struct CategoryPill: View {
    let category: MenuCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Text(category.emoji)
                    .font(.system(size: 14))
                Text(category.rawValue)
                    .font(.system(size: 13, weight: isSelected ? .bold : .medium))
            }
            .foregroundColor(isSelected ? .white : .guadDark)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? Color.guadRed : Color.white)
                    .shadow(
                        color: isSelected ? Color.guadRed.opacity(0.3) : Color.black.opacity(0.06),
                        radius: isSelected ? 6 : 3, x: 0, y: 2
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
