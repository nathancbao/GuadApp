import SwiftUI

struct MainView: View {
    @EnvironmentObject var cartStore: CartStore
    @EnvironmentObject var profileStore: ProfileStore

    @State private var showCart    = false
    @State private var showProfile = false

    var body: some View {
        NavigationStack {
            MenuView(
                showCart: $showCart,
                showProfile: $showProfile
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // ── Center: Branding ─────────────────────────────────────────
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 1) {
                        Text("GUAD'S")
                            .font(.system(size: 22, weight: .black, design: .rounded))
                            .foregroundColor(.guadRed)
                        Text("TACOS & BEER")
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .foregroundColor(.guadGold)
                            .tracking(2)
                    }
                }

                // ── Leading: Profile ─────────────────────────────────────────
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showProfile = true
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.guadRed.opacity(0.12))
                                .frame(width: 36, height: 36)
                            if profileStore.isComplete {
                                Text(profileStore.avatarEmoji)
                                    .font(.system(size: 18))
                            } else {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.guadRed)
                            }
                        }
                    }
                }

                // ── Trailing: Cart ────────────────────────────────────────────
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showCart = true
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "bag.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.guadRed)
                                .frame(width: 36, height: 36)

                            if cartStore.totalCount > 0 {
                                Text("\(cartStore.totalCount)")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .background(Color.guadGold)
                                    .clipShape(Circle())
                                    .offset(x: 6, y: -4)
                            }
                        }
                    }
                }
            }
        }
        .tint(.guadRed)
        .sheet(isPresented: $showCart) {
            CartView()
                .environmentObject(cartStore)
        }
        .sheet(isPresented: $showProfile) {
            ProfileView()
                .environmentObject(profileStore)
        }
    }
}
