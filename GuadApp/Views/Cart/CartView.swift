import SwiftUI
import UIKit

struct CartView: View {
    @EnvironmentObject var cartStore: CartStore
    @Environment(\.dismiss) private var dismiss

    @State private var showDelivery = false
    @State private var showClearConfirm = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.guadCream.ignoresSafeArea()

                if cartStore.isEmpty {
                    EmptyCartView { dismiss() }
                } else {
                    VStack(spacing: 0) {
                        // ── Item List ─────────────────────────────────────────
                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(cartStore.items) { cartItem in
                                    CartItemRow(cartItem: cartItem)
                                        .environmentObject(cartStore)
                                }
                            }
                            .padding(16)
                        }

                        // ── Summary + Order ───────────────────────────────────
                        VStack(spacing: 0) {
                            Divider()

                            VStack(spacing: 10) {
                                OrderSummaryRow(label: "Subtotal",
                                               value: String(format: "$%.2f", cartStore.subtotal),
                                               bold: false)
                                OrderSummaryRow(label: "Tax (8.75%)",
                                               value: String(format: "$%.2f", cartStore.tax),
                                               bold: false)
                                Divider()
                                OrderSummaryRow(label: "Total",
                                               value: String(format: "$%.2f", cartStore.total),
                                               bold: true)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)

                            // Order via delivery button
                            Button {
                                showDelivery = true
                            } label: {
                                HStack {
                                    Image(systemName: "bag.fill")
                                    Text("Order via Delivery")
                                        .font(.system(size: 17, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 17)
                                .background(Color.guadRed)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(color: Color.guadRed.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 6)

                            Button {
                                showClearConfirm = true
                            } label: {
                                Text("Clear Order")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.guadMedGray)
                            }
                            .padding(.bottom, 20)
                        }
                        .background(Color.white)
                    }
                }
            }
            .navigationTitle("Your Order")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 26))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.guadDark.opacity(0.5))
                    }
                }
            }
        }
        .sheet(isPresented: $showDelivery) {
            DeliveryView(total: cartStore.total)
        }
        .confirmationDialog("Clear your order?",
                            isPresented: $showClearConfirm,
                            titleVisibility: .visible) {
            Button("Clear Order", role: .destructive) {
                cartStore.clear()
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

// MARK: - Cart Item Row
struct CartItemRow: View {
    @EnvironmentObject var cartStore: CartStore
    let cartItem: CartItem

    private var accentColor: Color {
        Color(hex: cartItem.menuItem.cardColorHex) ?? .guadGold
    }

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(accentColor.opacity(0.45))
                    .frame(width: 52, height: 52)
                Text(cartItem.menuItem.category.emoji)
                    .font(.system(size: 26))
            }

            // Details
            VStack(alignment: .leading, spacing: 2) {
                Text(cartItem.menuItem.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.guadDark)
                if let meat = cartItem.displayMeat {
                    Text(meat)
                        .font(.system(size: 12))
                        .foregroundColor(.guadMedGray)
                }
            }

            Spacer()

            // Quantity + Price
            VStack(alignment: .trailing, spacing: 6) {
                Text(String(format: "$%.2f", cartItem.lineTotal))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.guadRed)

                HStack(spacing: 10) {
                    Button {
                        cartStore.setQuantity(cartItem, to: cartItem.quantity - 1)
                    } label: {
                        Image(systemName: cartItem.quantity == 1 ? "trash.fill" : "minus.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(cartItem.quantity == 1 ? .guadMedGray : .guadRed)
                    }

                    Text("\(cartItem.quantity)")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.guadDark)
                        .frame(minWidth: 18)

                    Button {
                        cartStore.setQuantity(cartItem, to: cartItem.quantity + 1)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.guadRed)
                    }
                }
            }
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
    }
}

// MARK: - Order Summary Row
struct OrderSummaryRow: View {
    let label: String
    let value: String
    let bold: Bool

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: bold ? 17 : 15, weight: bold ? .bold : .regular))
                .foregroundColor(bold ? .guadDark : .guadMedGray)
            Spacer()
            Text(value)
                .font(.system(size: bold ? 17 : 15, weight: bold ? .bold : .medium))
                .foregroundColor(bold ? .guadRed : .guadDark)
        }
    }
}

// MARK: - Empty Cart
struct EmptyCartView: View {
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("🛍️")
                .font(.system(size: 64))
            Text("Your bag is empty")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.guadDark)
            Text("Add some tacos and we'll get rolling!")
                .font(.system(size: 15))
                .foregroundColor(.guadMedGray)
                .multilineTextAlignment(.center)
            Button("Browse Menu") { onDismiss() }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 14)
                .background(Color.guadRed)
                .clipShape(Capsule())
        }
        .padding(30)
    }
}

// MARK: - Delivery App Model (file-scoped so DeliveryAppButton can share it)
struct DeliveryApp: Identifiable {
    let id = UUID()
    let name: String
    let assetName: String
    let color: Color
    let urlScheme: String
    let appStoreURL: String
}

private let deliveryApps: [DeliveryApp] = [
    DeliveryApp(name: "DoorDash",
                assetName: "doordash",
                color: Color(red: 0.92, green: 0.18, blue: 0.12),
                urlScheme: "doordash://",
                appStoreURL: "https://apps.apple.com/us/app/doordash-food-delivery/id719972451"),
    DeliveryApp(name: "Uber Eats",
                assetName: "ubereats",
                color: Color(red: 0.1, green: 0.1, blue: 0.1),
                urlScheme: "ubereats://",
                appStoreURL: "https://apps.apple.com/us/app/uber-eats-food-delivery/id1058959277"),
    DeliveryApp(name: "Grubhub",
                assetName: "grubhub",
                color: Color(red: 0.95, green: 0.35, blue: 0.0),
                urlScheme: "grubhub://",
                appStoreURL: "https://apps.apple.com/us/app/grubhub-food-delivery/id302920553"),
]

// MARK: - Delivery Options Sheet
struct DeliveryView: View {
    @Environment(\.dismiss) private var dismiss
    let total: Double

    private let apps = deliveryApps

    var body: some View {
        NavigationStack {
            ZStack {
                Color.guadCream.ignoresSafeArea()

                VStack(spacing: 24) {
                    // Header card
                    VStack(spacing: 6) {
                        Text("🌮")
                            .font(.system(size: 44))
                        Text("Ready to Order?")
                            .font(.system(size: 22, weight: .black, design: .rounded))
                            .foregroundColor(.guadDark)
                        Text("Order total: " + String(format: "$%.2f", total))
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.guadRed)
                        Text("Choose a delivery service:")
                            .font(.system(size: 14))
                            .foregroundColor(.guadMedGray)
                    }
                    .padding(.top, 20)

                    // Delivery app buttons
                    VStack(spacing: 12) {
                        ForEach(apps, id: \.name) { app in
                            DeliveryAppButton(app: app)
                        }
                    }
                    .padding(.horizontal, 24)

                    // Pickup option
                    VStack(spacing: 6) {
                        Divider()
                            .padding(.horizontal, 24)
                        HStack(spacing: 6) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.guadGold)
                            Text("Or pick up at 231 3rd St, Davis, CA")
                                .font(.system(size: 13))
                                .foregroundColor(.guadMedGray)
                        }
                    }

                    Spacer()
                }
            }
            .navigationTitle("Order Delivery")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 26))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.guadDark.opacity(0.5))
                    }
                }
            }
        }
    }
}

// MARK: - Delivery App Button
struct DeliveryAppButton: View {
    let app: DeliveryApp

    var body: some View {
        Button {
            openApp()
        } label: {
            HStack(spacing: 14) {
                // Bundled brand logo
                Image(app.assetName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                Text(app.name)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "arrow.up.right.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(app.color)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: app.color.opacity(0.35), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }

    private func openApp() {
        guard let schemeURL = URL(string: app.urlScheme),
              UIApplication.shared.canOpenURL(schemeURL) else {
            if let storeURL = URL(string: app.appStoreURL) {
                UIApplication.shared.open(storeURL)
            }
            return
        }
        UIApplication.shared.open(schemeURL)
    }
}
