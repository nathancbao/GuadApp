import SwiftUI

struct ClaimRewardView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var claimed = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.guadCream.ignoresSafeArea()

                VStack(spacing: 28) {
                    Spacer()

                    // ── Trophy graphic ────────────────────────────────────────
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.guadGold.opacity(0.25), Color.guadRed.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 140, height: 140)
                        Text(claimed ? "✅" : "🌮")
                            .font(.system(size: 70))
                            .scaleEffect(claimed ? 1.2 : 1.0)
                            .animation(.spring(response: 0.4, dampingFraction: 0.5), value: claimed)
                    }

                    // ── Text ──────────────────────────────────────────────────
                    VStack(spacing: 8) {
                        Text(claimed ? "Reward Claimed!" : "You Found the Truck!")
                            .font(.system(size: 26, weight: .black, design: .rounded))
                            .foregroundColor(.guadDark)
                            .multilineTextAlignment(.center)

                        Text(claimed
                             ? "Show this screen to your server\nto receive your free taco 🎉"
                             : "You're close enough to claim\na FREE taco from the Guad's food truck!")
                            .font(.system(size: 15))
                            .foregroundColor(.guadMedGray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }

                    // ── Reward card ───────────────────────────────────────────
                    VStack(spacing: 6) {
                        HStack {
                            Image(systemName: "seal.fill")
                                .foregroundColor(.guadGold)
                            Text("GUAD'S REWARD")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.guadGold)
                                .tracking(2)
                        }
                        Text("1 FREE Taco")
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundColor(.guadRed)
                        Text("Valid today only · One per customer")
                            .font(.system(size: 12))
                            .foregroundColor(.guadMedGray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .strokeBorder(
                                claimed ? Color.guadGreen : Color.guadGold.opacity(0.4),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: Color.black.opacity(0.07), radius: 10, x: 0, y: 4)
                    .padding(.horizontal, 24)

                    // ── Claim button ──────────────────────────────────────────
                    if !claimed {
                        Button {
                            withAnimation { claimed = true }
                        } label: {
                            Text("Claim Reward")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 17)
                                .background(Color.guadRed)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(color: Color.guadRed.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 24)
                    } else {
                        Text("Show this to your server 👆")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.guadGreen)
                    }

                    Spacer()
                }
            }
            .navigationTitle("Free Taco 🌮")
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
