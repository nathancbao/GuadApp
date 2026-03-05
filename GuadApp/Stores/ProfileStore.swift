import Foundation
import Combine

class ProfileStore: ObservableObject {
    @Published var profile = UserProfile()

    var isComplete: Bool { profile.isComplete }
    var displayName: String { profile.isComplete ? profile.name : "Guest" }
    var avatarEmoji: String { UserProfile.avatarEmojis[profile.avatarIndex] }
}
