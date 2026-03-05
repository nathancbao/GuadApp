import SwiftUI

struct MenuItemDetailView: View {
    @EnvironmentObject var cartStore: CartStore
    @Environment(\.dismiss) private var dismiss

    let item: MenuItem

    @State private var selectedMeat: String = ""
    @State private var quantity: Int = 1
    @State private var addedToCart = false

    private var accentColor: Color {
        Color(hex: item.cardColorHex) ?? Color.guadGold.opacity(0.4)
    }

    private var canAdd: Bool {
        !item.hasMeatChoice || !selectedMeat.isEmpty
    }

    private var lineTotal: Double {
        item.price * Double(quantity)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    // ── Hero ──────────────────────────────────────────────────
                    ZStack {
                        Rectangle()
                            .fill(accentColor.opacity(0.5))
                            .frame(height: 200)
                        VStack(spacing: 8) {
                            Text(item.category.emoji)
                                .font(.system(size: 72))
                            if item.isPopular {
                                Label("Popular Item", systemImage: "star.fill")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.guadOrange)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.white.opacity(0.8))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .ignoresSafeArea(edges: .top)

                    // ── Info ──────────────────────────────────────────────────
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.name)
                                    .font(.system(size: 24, weight: .black, design: .rounded))
                                    .foregroundColor(.guadDark)

                                if item.isVegetarian {
                                    Label("Vegetarian", systemImage: "leaf.fill")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.guadGreen)
                                }
                            }
                            Spacer()
                            Text(String(format: "$%.2f", item.price))
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.guadRed)
                        }

                        Text(item.description)
                            .font(.system(size: 15))
                            .foregroundColor(.guadMedGray)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(20)

                    Divider().padding(.horizontal, 20)

                    // ── Meat Picker ───────────────────────────────────────────
                    if item.hasMeatChoice {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Choose Your Meat")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(.guadDark)
                                Spacer()
                                Text("Required")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(selectedMeat.isEmpty ? .guadOrange : .guadGreen)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(
                                        (selectedMeat.isEmpty ? Color.guadOrange : Color.guadGreen).opacity(0.12)
                                    )
                                    .clipShape(Capsule())
                            }

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(item.meatOptions, id: \.self) { meat in
                                        MeatChip(
                                            label: meat,
                                            isSelected: selectedMeat == meat
                                        ) {
                                            withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                                                selectedMeat = meat
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.top, 20)

                        Divider().padding(.horizontal, 20).padding(.top, 16)
                    }

                    // ── Quantity ──────────────────────────────────────────────
                    HStack {
                        Text("Quantity")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.guadDark)
                        Spacer()
                        HStack(spacing: 20) {
                            Button {
                                if quantity > 1 { quantity -= 1 }
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(quantity > 1 ? .guadRed : Color.guadMedGray.opacity(0.4))
                            }
                            .disabled(quantity <= 1)

                            Text("\(quantity)")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.guadDark)
                                .frame(minWidth: 24)

                            Button {
                                quantity += 1
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(.guadRed)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)

                    // ── Special note ──────────────────────────────────────────
                    if item.category == .drinks {
                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.guadGold)
                            Text("Must be 21+ to order alcoholic beverages")
                                .font(.system(size: 12))
                                .foregroundColor(.guadMedGray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 8)
                    }

                    // ── Add to Cart ───────────────────────────────────────────
                    Button {
                        guard canAdd else { return }
                        cartStore.add(item, meat: selectedMeat.isEmpty ? nil : selectedMeat)
                        withAnimation {
                            addedToCart = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            dismiss()
                        }
                    } label: {
                        HStack {
                            if addedToCart {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .bold))
                                Text("Added!")
                                    .font(.system(size: 17, weight: .bold))
                            } else {
                                Text("Add to Bag")
                                    .font(.system(size: 17, weight: .bold))
                                Spacer()
                                Text(String(format: "$%.2f", lineTotal))
                                    .font(.system(size: 17, weight: .bold))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .padding(.horizontal, 24)
                        .background(
                            canAdd
                                ? (addedToCart ? Color.guadGreen : Color.guadRed)
                                : Color.guadMedGray.opacity(0.4)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .animation(.spring(response: 0.3), value: addedToCart)
                    }
                    .disabled(!canAdd || addedToCart)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)

                    if !canAdd {
                        Text("Please select a meat option to continue")
                            .font(.system(size: 12))
                            .foregroundColor(.guadOrange)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 8)
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
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

// MARK: - Meat Selection Chip
struct MeatChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                .foregroundColor(isSelected ? .white : .guadDark)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.guadRed : Color.white)
                        .shadow(
                            color: isSelected ? Color.guadRed.opacity(0.3) : Color.black.opacity(0.06),
                            radius: isSelected ? 5 : 2, x: 0, y: 2
                        )
                )
        }
        .buttonStyle(.plain)
    }
}
