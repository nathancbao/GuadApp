import Foundation
import Combine

class CartStore: ObservableObject {
    @Published var items: [CartItem] = []

    // MARK: - Computed
    var totalCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    var subtotal: Double {
        items.reduce(0) { $0 + $1.lineTotal }
    }

    var tax: Double { subtotal * 0.0875 }
    var total: Double { subtotal + tax }

    var isEmpty: Bool { items.isEmpty }

    // MARK: - Actions
    func add(_ item: MenuItem, meat: String? = nil) {
        if let idx = items.firstIndex(where: {
            $0.menuItem.id == item.id && $0.selectedMeat == meat
        }) {
            items[idx].quantity += 1
        } else {
            items.append(CartItem(menuItem: item, quantity: 1, selectedMeat: meat))
        }
    }

    func remove(_ cartItem: CartItem) {
        items.removeAll { $0.id == cartItem.id }
    }

    func setQuantity(_ cartItem: CartItem, to quantity: Int) {
        guard let idx = items.firstIndex(where: { $0.id == cartItem.id }) else { return }
        if quantity <= 0 {
            items.remove(at: idx)
        } else {
            items[idx].quantity = quantity
        }
    }

    func clear() { items = [] }
}
