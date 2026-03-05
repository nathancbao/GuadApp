import Foundation

// MARK: - Menu Category
enum MenuCategory: String, CaseIterable, Hashable {
    case all           = "All"
    case tacos         = "Tacos"
    case burritos      = "Burritos"
    case quesadillas   = "Quesadillas"
    case nachos        = "Nachos"
    case plates        = "Plates"
    case breakfast     = "Breakfast"
    case drinks        = "Drinks"

    var emoji: String {
        switch self {
        case .all:         return "🍴"
        case .tacos:       return "🌮"
        case .burritos:    return "🌯"
        case .quesadillas: return "🫓"
        case .nachos:      return "🧀"
        case .plates:      return "🍽️"
        case .breakfast:   return "🍳"
        case .drinks:      return "🍺"
        }
    }
}

// MARK: - Menu Item
struct MenuItem: Identifiable, Hashable {
    let id: UUID = UUID()
    let name: String
    let description: String
    let price: Double
    let category: MenuCategory
    let hasMeatChoice: Bool
    let meatOptions: [String]
    let isVegetarian: Bool
    let isPopular: Bool
    let cardColorHex: String   // accent color for the card graphic

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: MenuItem, rhs: MenuItem) -> Bool { lhs.id == rhs.id }
}

// MARK: - Cart Item
struct CartItem: Identifiable {
    let id: UUID = UUID()
    var menuItem: MenuItem
    var quantity: Int
    var selectedMeat: String?

    var lineTotal: Double { menuItem.price * Double(quantity) }
    var displayMeat: String? { selectedMeat }
}

// MARK: - User Profile
struct UserProfile {
    var name: String        = ""
    var email: String       = ""
    var avatarIndex: Int    = 0
    var isComplete: Bool    { !name.trimmingCharacters(in: .whitespaces).isEmpty }

    static let avatarEmojis = ["🤠", "😎", "🌮", "🍺", "🦅", "🔥"]
}
