import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var profileStore: ProfileStore
    @Environment(\.dismiss) private var dismiss

    @State private var draftName: String        = ""
    @State private var draftEmail: String       = ""
    @State private var draftAvatar: Int         = 0
    @State private var showSavedConfirmation    = false

    private let avatars = UserProfile.avatarEmojis

    var body: some View {
        NavigationStack {
            ZStack {
                Color.guadCream.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {

                        // ── Hero Header ───────────────────────────────────────
                        VStack(spacing: 4) {
                            // Avatar display
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
                                Text(avatars[draftAvatar])
                                    .font(.system(size: 52))
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

                        // ── Avatar Picker ─────────────────────────────────────
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Pick Your Vibe")

                            HStack(spacing: 12) {
                                ForEach(avatars.indices, id: \.self) { idx in
                                    Button {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                            draftAvatar = idx
                                        }
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .fill(draftAvatar == idx ? Color.guadRed.opacity(0.15) : Color.white)
                                                .frame(width: 52, height: 52)
                                                .overlay(
                                                    Circle()
                                                        .strokeBorder(
                                                            draftAvatar == idx ? Color.guadRed : Color.clear,
                                                            lineWidth: 2.5
                                                        )
                                                )
                                                .shadow(color: Color.black.opacity(0.07), radius: 4, x: 0, y: 2)
                                            Text(avatars[idx])
                                                .font(.system(size: 26))
                                        }
                                    }
                                    .buttonStyle(.plain)
                                    .scaleEffect(draftAvatar == idx ? 1.1 : 1.0)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
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
            draftName   = profileStore.profile.name
            draftEmail  = profileStore.profile.email
            draftAvatar = profileStore.profile.avatarIndex
        }
    }

    private func saveProfile() {
        profileStore.profile.name        = draftName.trimmingCharacters(in: .whitespaces)
        profileStore.profile.email       = draftEmail.trimmingCharacters(in: .whitespaces)
        profileStore.profile.avatarIndex = draftAvatar

        withAnimation { showSavedConfirmation = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            dismiss()
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
