import SwiftUI

struct MainView: View {
    @EnvironmentObject var cartStore: CartStore
    @EnvironmentObject var profileStore: ProfileStore

    @State private var showCart    = false
    @State private var showProfile = false
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // ── Tab 1: Menu ───────────────────────────────────────────────────
            NavigationStack {
                MenuView(showCart: $showCart, showProfile: $showProfile)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
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
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button { showProfile = true } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.guadRed.opacity(0.12))
                                        .frame(width: 36, height: 36)
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.guadRed)
                                }
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button { showCart = true } label: {
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
            .tabItem {
                Label("Menu", systemImage: "fork.knife")
            }
            .tag(0)

            // ── Tab 2: Truck Hunt ─────────────────────────────────────────────
            TruckHuntView()
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem {
                    Label("Find Truck", systemImage: "mappin.and.ellipse")
                }
                .tag(1)

            // ── Tab 3: Events ─────────────────────────────────────────────────
            EventsView()
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem {
                    Label("Events", systemImage: "ticket.fill")
                }
                .tag(2)
        }
        .tint(.guadRed)
        .sheet(isPresented: $showCart) {
            CartView().environmentObject(cartStore)
        }
        .sheet(isPresented: $showProfile) {
            ProfileView().environmentObject(profileStore)
        }
    }
}
