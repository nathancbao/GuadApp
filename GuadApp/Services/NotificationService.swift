import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    private init() {}

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            if let error { print("Notification permission error: \(error)") }
        }
    }

    func sendPromoNotification() {
        let content = UNMutableNotificationContent()
        content.title = "🌮 You Found the Truck!"
        content.body = "You're within range of the Guad's food truck! Show this to your server for a FREE taco. 🎉"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: "guads.truckPromo.\(Date().timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request)
    }
}
