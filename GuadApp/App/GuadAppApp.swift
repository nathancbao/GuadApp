import SwiftUI

@main
struct GuadAppApp: App {
    @StateObject private var cartStore = CartStore()
    @StateObject private var profileStore = ProfileStore()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(cartStore)
                .environmentObject(profileStore)
        }
    }
}
