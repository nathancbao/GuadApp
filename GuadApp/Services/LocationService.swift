import Foundation
import CoreLocation
import Combine

// 🔒 Secret truck coordinate — update this when the truck moves to a new spot
private let truckLatitude:  CLLocationDegrees = 38.5441   // ← update me
private let truckLongitude: CLLocationDegrees = -121.7414  // ← update me
private let proximityThreshold: CLLocationDistance = 16093.4  // ~10 miles

class LocationService: NSObject, ObservableObject {
    @Published var userLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var isNearTruck = false

    private let manager = CLLocationManager()
    private var hasTriggeredPromo = false

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 5
        authorizationStatus = manager.authorizationStatus
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func startTracking() {
        manager.startUpdatingLocation()
    }

    func resetPromo() {
        hasTriggeredPromo = false
    }

    private func checkProximity(to location: CLLocation) {
        let truck = CLLocation(latitude: truckLatitude, longitude: truckLongitude)
        let distance = location.distance(from: truck)
        let wasNear = isNearTruck
        isNearTruck = distance <= proximityThreshold

        if isNearTruck && !wasNear && !hasTriggeredPromo {
            hasTriggeredPromo = true
            NotificationService.shared.sendPromoNotification()
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
        checkProximity(to: location)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.authorizationStatus = manager.authorizationStatus
        }
        if manager.authorizationStatus == .authorizedWhenInUse ||
           manager.authorizationStatus == .authorizedAlways {
            startTracking()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}
