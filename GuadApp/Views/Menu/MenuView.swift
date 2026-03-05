import SwiftUI

struct MenuView: View {
    @EnvironmentObject var cartStore: CartStore
    @Binding var showCart: Bool
    @Binding var showProfile: Bool

    @State private var selectedCategory: MenuCategory = .all
    @State private var selectedItem: MenuItem?
    @State private var searchText = ""

    private var filteredItems: [MenuItem] {
        let byCategory = selectedCategory == .all
            ? allMenuItems
            : allMenuItems.filter { $0.category == selectedCategory }

        guard !searchText.isEmpty else { return byCategory }
        return byCategory.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.description.localizedCaseInsensitiveContains(searchText)
        }
    }

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ZStack {
            Color.guadCream.ignoresSafeArea()

            VStack(spacing: 0) {
                // ── Search Bar ────────────────────────────────────────────────
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.guadMedGray)
                    TextField("Search tacos, burritos...", text: $searchText)
                        .font(.system(size: 15))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 8)

                // ── Category Pills ────────────────────────────────────────────
                CategoryBar(selected: $selectedCategory)
                    .padding(.bottom, 6)

                // ── Menu Grid ─────────────────────────────────────────────────
                ScrollView {
                    if !cartStore.isEmpty {
                        CartBanner(count: cartStore.totalCount, total: cartStore.total) {
                            showCart = true
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }

                    if filteredItems.isEmpty {
                        EmptyMenuView()
                            .padding(.top, 60)
                    } else {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(filteredItems) { item in
                                MenuItemCard(item: item)
                                    .onTapGesture { selectedItem = item }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 32)
                    }
                }
            }
        }
        .sheet(item: $selectedItem) { item in
            MenuItemDetailView(item: item)
                .environmentObject(cartStore)
        }
    }
}

// MARK: - Cart Banner (floating nudge)
struct CartBanner: View {
    let count: Int
    let total: Double
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                ZStack {
                    Circle().fill(Color.white.opacity(0.25))
                        .frame(width: 32, height: 32)
                    Image(systemName: "bag.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .semibold))
                }
                Text("\(count) item\(count > 1 ? "s" : "") in bag")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                Text(String(format: "$%.2f", total))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.guadRed)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: Color.guadRed.opacity(0.35), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Empty State
struct EmptyMenuView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("🌮")
                .font(.system(size: 48))
            Text("No items found")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.guadDark)
            Text("Try a different search or category")
                .font(.system(size: 14))
                .foregroundColor(.guadMedGray)
        }
    }
}
