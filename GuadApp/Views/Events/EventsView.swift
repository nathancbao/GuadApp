import SwiftUI

struct EventsView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // ── Header ────────────────────────────────────────────────
                    ZStack {
                        LinearGradient(
                            colors: [
                                Color(red: 0.42, green: 0.0, blue: 0.60),  // deep purple
                                Color(red: 0.0,  green: 0.0, blue: 0.0),   // black
                            ],
                            startPoint: .top, endPoint: .bottom
                        )
                        .frame(height: 260)

                        VStack(spacing: 6) {
                            Spacer().frame(height: 20)
                            Text("GUAD'S PRESENTS")
                                .font(.system(size: 11, weight: .heavy))
                                .foregroundColor(.white.opacity(0.5))
                                .tracking(4)

                            Text("HAPPY\nHOUR")
                                .font(.system(size: 68, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .lineSpacing(-4)

                            HStack(spacing: 8) {
                                Capsule()
                                    .fill(Color(red: 1.0, green: 0.88, blue: 0.0))
                                    .frame(width: 40, height: 2)
                                Text("FRI & SAT  ·  11 PM – 1 AM")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(Color(red: 1.0, green: 0.88, blue: 0.0))
                                    .tracking(1)
                                Capsule()
                                    .fill(Color(red: 1.0, green: 0.88, blue: 0.0))
                                    .frame(width: 40, height: 2)
                            }
                        }
                    }

                    // ── Bad Bunny Feature Card ─────────────────────────────────
                    ZStack {
                        LinearGradient(
                            colors: [
                                Color(red: 1.0,  green: 0.17, blue: 0.53),  // hot pink
                                Color(red: 0.55, green: 0.0,  blue: 0.75),  // purple
                            ],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )

                        VStack(spacing: 10) {
                            Text("🎵 FEATURING")
                                .font(.system(size: 11, weight: .heavy))
                                .foregroundColor(.white.opacity(0.6))
                                .tracking(3)

                            Text("Bad Bunny")
                                .font(.system(size: 48, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                                .italic()

                            Text("All night long · Latin hits · Reggaeton")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.vertical, 32)
                    }

                    // ── Specials Grid ─────────────────────────────────────────
                    VStack(alignment: .leading, spacing: 14) {
                        Text("HAPPY HOUR SPECIALS")
                            .font(.system(size: 11, weight: .heavy))
                            .foregroundColor(.white.opacity(0.4))
                            .tracking(3)
                            .padding(.horizontal, 20)
                            .padding(.top, 24)

                        HStack(spacing: 12) {
                            SpecialCard(
                                emoji: "🌮",
                                item: "Street Tacos",
                                detail: "2 for $7",
                                color: Color(red: 0.85, green: 0.30, blue: 0.0)
                            )
                            SpecialCard(
                                emoji: "🧀",
                                item: "Nachos",
                                detail: "$8",
                                color: Color(red: 0.70, green: 0.20, blue: 0.0)
                            )
                            SpecialCard(
                                emoji: "🍺",
                                item: "Draft Beer",
                                detail: "$4",
                                color: Color(red: 0.55, green: 0.35, blue: 0.0)
                            )
                        }
                        .padding(.horizontal, 20)
                    }

                    // ── Vibe section ──────────────────────────────────────────
                    VStack(spacing: 16) {
                        Divider()
                            .background(Color.white.opacity(0.1))
                            .padding(.horizontal, 20)
                            .padding(.top, 24)

                        Text("THE VIBE")
                            .font(.system(size: 11, weight: .heavy))
                            .foregroundColor(.white.opacity(0.4))
                            .tracking(3)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            VibeTag(icon: "music.note", label: "Live DJ")
                            VibeTag(icon: "fork.knife", label: "Late Night Eats")
                            VibeTag(icon: "person.3.fill", label: "Good Company")
                            VibeTag(icon: "star.fill", label: "Weekly Theme")
                        }
                        .padding(.horizontal, 20)
                    }

                    // ── Footer ────────────────────────────────────────────────
                    VStack(spacing: 6) {
                        Divider()
                            .background(Color.white.opacity(0.1))
                        Text("231 3rd St, Davis, CA  ·  Every Fri & Sat")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.3))
                        Text("Must be 21+ · Valid ID required")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.2))
                    }
                    .padding(.vertical, 24)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

// MARK: - Special Card
struct SpecialCard: View {
    let emoji: String
    let item: String
    let detail: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Text(emoji)
                .font(.system(size: 32))
            Text(item)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Text(detail)
                .font(.system(size: 18, weight: .black))
                .foregroundColor(Color(red: 1.0, green: 0.88, blue: 0.0))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(color.opacity(0.4))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(color.opacity(0.6), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Vibe Tag
struct VibeTag: View {
    let icon: String
    let label: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundColor(Color(red: 1.0, green: 0.88, blue: 0.0))
            Text(label)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
