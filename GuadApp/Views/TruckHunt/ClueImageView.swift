import SwiftUI

struct ClueImageView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.guadDark.ignoresSafeArea()

                VStack(spacing: 0) {
                    // ── Mystery Header ────────────────────────────────────────
                    VStack(spacing: 6) {
                        Text("📍 Today's Clue")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.guadGold)
                            .tracking(2)
                            .textCase(.uppercase)

                        Text("Find the Truck")
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .foregroundColor(.white)

                        Text("Get within 100 feet to claim your free taco")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 24)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)

                    // ── Clue Image ────────────────────────────────────────────
                    ZStack {
                        // Use "truck_clue" from Assets — replace with real photo
                        if let _ = UIImage(named: "truck_clue") {
                            Image("truck_clue")
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                                .padding(.horizontal, 20)
                        } else {
                            // Placeholder when no image is set
                            PlaceholderClue()
                                .padding(.horizontal, 20)
                        }
                    }

                    Spacer()

                    // ── Bottom hint ───────────────────────────────────────────
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: "bell.badge.fill")
                                .foregroundColor(.guadGold)
                            Text("We'll notify you when you're close enough")
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.horizontal, 24)

                        Button {
                            dismiss()
                        } label: {
                            Text("Start Hunting")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.guadDark)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 17)
                                .background(Color.guadGold)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 26))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Placeholder shown until a real clue photo is added
struct PlaceholderClue: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.07))
                .frame(height: 320)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(Color.guadGold.opacity(0.3), style: StrokeStyle(lineWidth: 1.5, dash: [8]))
                )

            VStack(spacing: 14) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 42))
                    .foregroundColor(.guadGold.opacity(0.6))
                Text("Clue dropping soon...")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
    }
}
