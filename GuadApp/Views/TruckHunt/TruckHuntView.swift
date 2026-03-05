import SwiftUI
import MapKit

struct TruckHuntView: View {
    @StateObject private var locationService = LocationService()
    @State private var showClue = false
    @State private var mapPosition: MapCameraPosition = .userLocation(
        followsHeading: false,
        fallback: .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 38.5441, longitude: -121.7414),
            span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
        ))
    )
    @State private var isFollowingUser = true

    var body: some View {
        ZStack {
            // ── Map ───────────────────────────────────────────────────────────
            Map(position: $mapPosition) {
                UserAnnotation()
            }
            .mapStyle(.standard(elevation: .realistic))
            .mapControls { } // disable default controls — we use custom ones
            .ignoresSafeArea()
            .onMapCameraChange { _ in
                // If user pans the map manually, stop auto-following
                isFollowingUser = false
            }

            // ── Overlaid UI ───────────────────────────────────────────────────
            VStack(spacing: 0) {

                // Top header card
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.guadRed.opacity(0.12))
                            .frame(width: 44, height: 44)
                        Text("🚚")
                            .font(.system(size: 22))
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Truck Hunt")
                            .font(.system(size: 17, weight: .black, design: .rounded))
                            .foregroundColor(.guadDark)
                        Text(locationService.isNearTruck
                             ? "🔥 You're close — claim your reward!"
                             : "Find the truck using today's clue")
                            .font(.system(size: 12))
                            .foregroundColor(locationService.isNearTruck ? .guadGreen : .guadMedGray)
                            .animation(.easeInOut, value: locationService.isNearTruck)
                    }
                    Spacer()
                    if locationService.isNearTruck {
                        PulsingDot()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                .padding(.horizontal, 16)
                .padding(.top, 16)

                Spacer()

                // ── Right-side recenter button ────────────────────────────────
                HStack {
                    Spacer()
                    Button {
                        recenterOnUser()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 46, height: 46)
                                .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 3)
                            Image(systemName: isFollowingUser ? "location.fill" : "location")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(isFollowingUser ? .guadRed : .guadMedGray)
                        }
                    }
                    .padding(.trailing, 16)
                    .padding(.bottom, 12)
                }

                // ── Promo banner ──────────────────────────────────────────────
                if locationService.isNearTruck {
                    PromoFoundBanner()
                        .padding(.horizontal, 16)
                        .padding(.bottom, 10)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                // ── Location permission warning ───────────────────────────────
                if locationService.authorizationStatus == .denied ||
                   locationService.authorizationStatus == .restricted {
                    LocationPermissionBanner()
                        .padding(.horizontal, 16)
                        .padding(.bottom, 10)
                }

                // ── View Clue button ──────────────────────────────────────────
                Button {
                    showClue = true
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "photo.fill")
                            .font(.system(size: 15))
                        Text("View Today's Clue")
                            .font(.system(size: 17, weight: .bold))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 17)
                    .background(Color.guadRed)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: Color.guadRed.opacity(0.35), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .sheet(isPresented: $showClue) {
            ClueImageView()
        }
        .onAppear {
            locationService.requestPermission()
            NotificationService.shared.requestPermission()
        }
        .onChange(of: locationService.userLocation) { _, newLocation in
            guard let loc = newLocation, isFollowingUser else { return }
            withAnimation(.easeInOut(duration: 0.6)) {
                mapPosition = .camera(MapCamera(
                    centerCoordinate: loc.coordinate,
                    distance: 1200,
                    heading: 0,
                    pitch: 0
                ))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: locationService.isNearTruck)
    }

    private func recenterOnUser() {
        guard let loc = locationService.userLocation else {
            // No location yet — reset to follow mode
            mapPosition = .userLocation(followsHeading: false, fallback: .automatic)
            isFollowingUser = true
            return
        }
        withAnimation(.easeInOut(duration: 0.5)) {
            mapPosition = .camera(MapCamera(
                centerCoordinate: loc.coordinate,
                distance: 1200,
                heading: 0,
                pitch: 0
            ))
        }
        isFollowingUser = true
    }
}

// MARK: - Promo Found Banner
struct PromoFoundBanner: View {
    @State private var showClaim = false

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Text("🎉")
                    .font(.system(size: 32))
                VStack(alignment: .leading, spacing: 3) {
                    Text("You found the truck!")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    Text("Tap below to claim your free taco")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.85))
                }
                Spacer()
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.guadGold)
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 10)

            Button {
                showClaim = true
            } label: {
                Text("🌮  Claim Free Taco")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.guadGreen)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 14)
        }
        .background(Color.guadGreen)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.guadGreen.opacity(0.45), radius: 12, x: 0, y: 6)
        .sheet(isPresented: $showClaim) {
            ClaimRewardView()
        }
    }
}

// MARK: - Location Permission Banner
struct LocationPermissionBanner: View {
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "location.slash.fill")
                .foregroundColor(.guadOrange)
            Text("Enable location in Settings to play")
                .font(.system(size: 13))
                .foregroundColor(.guadDark)
            Spacer()
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(.guadRed)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Pulsing dot
struct PulsingDot: View {
    @State private var pulse = false

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.guadGreen.opacity(0.3))
                .frame(width: 24, height: 24)
                .scaleEffect(pulse ? 1.7 : 1.0)
                .opacity(pulse ? 0 : 1)
            Circle()
                .fill(Color.guadGreen)
                .frame(width: 12, height: 12)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.1).repeatForever(autoreverses: false)) {
                pulse = true
            }
        }
    }
}
