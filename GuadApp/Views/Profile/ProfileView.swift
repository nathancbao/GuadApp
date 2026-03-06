import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var profileStore: ProfileStore
    @Environment(\.dismiss) private var dismiss

    @State private var draftName: String        = ""
    @State private var draftEmail: String       = ""
    @State private var showSavedConfirmation    = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.guadCream.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {

                        // ── Hero Header ───────────────────────────────────────
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.guadRed.opacity(0.15), Color.guadGold.opacity(0.15)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 100, height: 100)

                                if draftName.isEmpty {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 44))
                                        .foregroundColor(.guadRed.opacity(0.7))
                                } else {
                                    Text(String(draftName.prefix(1)).uppercased())
                                        .font(.system(size: 44, weight: .bold, design: .rounded))
                                        .foregroundColor(.guadRed)
                                }
                            }

                            if !draftName.isEmpty {
                                Text("Hi, \(draftName)!")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(.guadDark)
                            } else {
                                Text("Set up your profile")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.guadMedGray)
                            }
                        }
                        .padding(.top, 16)

                        // ── Beer Stamp Card ───────────────────────────────────
                        BeerStampCard()
                            .padding(.horizontal, 20)

                        // ── Form ──────────────────────────────────────────────
                        VStack(spacing: 16) {
                            SectionHeader(title: "Your Info")
                                .padding(.horizontal, 20)

                            VStack(spacing: 12) {
                                ProfileTextField(
                                    icon: "person.fill",
                                    placeholder: "Full Name",
                                    text: $draftName,
                                    keyboard: .namePhonePad
                                )

                                ProfileTextField(
                                    icon: "envelope.fill",
                                    placeholder: "Email Address",
                                    text: $draftEmail,
                                    keyboard: .emailAddress
                                )
                            }
                            .padding(.horizontal, 20)
                        }

                        // ── Perks ─────────────────────────────────────────────
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Member Perks")
                                .padding(.horizontal, 20)

                            VStack(spacing: 10) {
                                PerkRow(icon: "star.fill",   color: .guadGold,   text: "Early access to new menu items")
                                PerkRow(icon: "tag.fill",    color: .guadRed,    text: "Exclusive deals & promo codes")
                                PerkRow(icon: "clock.fill",  color: .guadOrange, text: "Faster reorder with saved history")
                            }
                            .padding(.horizontal, 20)
                        }

                        // ── Save ──────────────────────────────────────────────
                        Button {
                            saveProfile()
                        } label: {
                            HStack {
                                if showSavedConfirmation {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 16, weight: .bold))
                                    Text("Saved!")
                                        .font(.system(size: 17, weight: .bold))
                                } else {
                                    Text("Save Profile")
                                        .font(.system(size: 17, weight: .bold))
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 17)
                            .background(
                                showSavedConfirmation ? Color.guadGreen : Color.guadRed
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(
                                color: (showSavedConfirmation ? Color.guadGreen : Color.guadRed).opacity(0.3),
                                radius: 8, x: 0, y: 4
                            )
                            .animation(.spring(response: 0.3), value: showSavedConfirmation)
                        }
                        .disabled(draftName.trimmingCharacters(in: .whitespaces).isEmpty)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 32)
                    }
                }
            }
            .navigationTitle("Profile")
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
        .onAppear {
            draftName  = profileStore.profile.name
            draftEmail = profileStore.profile.email
        }
    }

    private func saveProfile() {
        profileStore.profile.name  = draftName.trimmingCharacters(in: .whitespaces)
        profileStore.profile.email = draftEmail.trimmingCharacters(in: .whitespaces)

        withAnimation { showSavedConfirmation = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            dismiss()
        }
    }
}

// MARK: - Beer Stamp Card
struct BeerStampCard: View {
    @AppStorage("beerStampCount") private var stampCount: Int = 0
    @State private var showFreeBeer = false

    private let total = 10

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("BEER STAMP CARD")
                        .font(.system(size: 11, weight: .heavy))
                        .foregroundColor(.guadGold)
                        .tracking(2)
                    Text("Collect 10 stamps, get the next one free")
                        .font(.system(size: 13))
                        .foregroundColor(.guadDark.opacity(0.7))
                }
                Spacer()
                Text("🍺")
                    .font(.system(size: 28))
            }

            // Stamp grid — 5 per row
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    ForEach(0..<5) { i in StampCircle(index: i, filled: i < stampCount) }
                }
                HStack(spacing: 8) {
                    ForEach(5..<10) { i in StampCircle(index: i, filled: i < stampCount) }
                }
            }

            if stampCount >= total {
                Button {
                    showFreeBeer = true
                } label: {
                    Text("🍺  Claim Your Free Beer!")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(Color.guadGold)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            } else {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        if stampCount < total { stampCount += 1 }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "plus.circle.fill")
                        Text("Add a Beer (\(total - stampCount) more to go)")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.guadGold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 11)
                    .background(Color.guadGold.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding(18)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.guadGold.opacity(0.35), lineWidth: 1.5)
        )
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
        .sheet(isPresented: $showFreeBeer) {
            FreeBeerRewardView(stampCount: $stampCount)
        }
    }
}

// MARK: - Stamp Circle
private struct StampCircle: View {
    let index: Int
    let filled: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(filled ? Color.guadGold : Color.guadGold.opacity(0.08))
                .frame(width: 46, height: 46)
                .overlay(
                    Circle()
                        .strokeBorder(Color.guadGold.opacity(filled ? 0 : 0.3), lineWidth: 1.5)
                )
            if filled {
                Text("🍺")
                    .font(.system(size: 22))
            } else {
                Text("\(index + 1)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.guadGold.opacity(0.4))
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Free Beer Reward Sheet
struct FreeBeerRewardView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var stampCount: Int
    @State private var redeemed = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.guadCream.ignoresSafeArea()

                VStack(spacing: 28) {
                    Spacer()

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
                        Text(redeemed ? "✅" : "🍺")
                            .font(.system(size: 70))
                            .scaleEffect(redeemed ? 1.2 : 1.0)
                            .animation(.spring(response: 0.4, dampingFraction: 0.5), value: redeemed)
                    }

                    VStack(spacing: 8) {
                        Text(redeemed ? "Beer Claimed!" : "You Earned a Free Beer!")
                            .font(.system(size: 26, weight: .black, design: .rounded))
                            .foregroundColor(.guadDark)
                            .multilineTextAlignment(.center)

                        Text(redeemed
                             ? "Show this screen to your server\nto receive your free beer 🎉"
                             : "10 stamps collected — enjoy a beer on us!")
                            .font(.system(size: 15))
                            .foregroundColor(.guadMedGray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }

                    VStack(spacing: 6) {
                        HStack {
                            Image(systemName: "seal.fill")
                                .foregroundColor(.guadGold)
                            Text("GUAD'S REWARD")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.guadGold)
                                .tracking(2)
                        }
                        Text("1 FREE Beer")
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
                                redeemed ? Color.guadGreen : Color.guadGold.opacity(0.4),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: Color.black.opacity(0.07), radius: 10, x: 0, y: 4)
                    .padding(.horizontal, 24)

                    if !redeemed {
                        Button {
                            withAnimation { redeemed = true }
                            stampCount = 0   // reset stamps after redeeming
                        } label: {
                            Text("Claim Free Beer")
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
            .navigationTitle("Free Beer 🍺")
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

// MARK: - Section Header
private struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(.guadMedGray)
            .textCase(.uppercase)
            .tracking(1)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Profile Text Field
private struct ProfileTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.guadMedGray)
                .frame(width: 20)
            TextField(placeholder, text: $text)
                .font(.system(size: 16))
                .keyboardType(keyboard)
                .autocorrectionDisabled()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Perk Row
private struct PerkRow: View {
    let icon: String
    let color: Color
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24, height: 24)
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.guadDark)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.04), radius: 3, x: 0, y: 1)
    }
}
