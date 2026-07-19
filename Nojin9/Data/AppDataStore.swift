import Combine
import Foundation

final class AppDataStore: ObservableObject {
    @Published private(set) var snapshot: AppDataSnapshot

    init(snapshot: AppDataSnapshot = MockData.snapshot) {
        self.snapshot = snapshot
    }

    var currentUser: User? {
        snapshot.users.first { $0.id == snapshot.userSession.currentUserId }
    }

    var sisters: [User] {
        let currentUserId = snapshot.userSession.currentUserId
        let sisterIds = snapshot.friendships.compactMap { friendship -> UUID? in
            guard friendship.status == .accepted else { return nil }
            return friendship.friendId(for: currentUserId)
        }

        return sisterIds.compactMap { sisterId in
            snapshot.users.first { $0.id == sisterId }
        }
    }

    func user(id: UUID) -> User? {
        snapshot.users.first { $0.id == id }
    }

    func clothItem(id: UUID) -> ClothItem? {
        snapshot.clothItems.first { $0.id == id }
    }

    func clothItems(category: ClothCategory? = nil, ownerId: UUID? = nil) -> [ClothItem] {
        snapshot.clothItems.filter { item in
            let matchesCategory = category.map { item.category == $0 } ?? true
            let matchesOwner = ownerId.map { item.ownerId == $0 } ?? true
            return matchesCategory && matchesOwner
        }
    }

    func owner(for item: ClothItem) -> User? {
        user(id: item.ownerId)
    }

    func rentals(for clothItemId: UUID) -> [Rental] {
        snapshot.rentals.filter { $0.clothItemId == clothItemId }
    }

    func reviewSamples(for clothItemId: UUID) -> [ReviewSample] {
        snapshot.reviewSamples.filter { $0.clothItemId == clothItemId }
    }

    func thankYouLetters(for clothItemId: UUID) -> [ThankYouLetter] {
        snapshot.thankYouLetters.filter { $0.clothItemId == clothItemId }
    }

    @discardableResult
    func borrow(clothItemId: UUID, borrowedAt: Date = Date()) -> Bool {
        let currentUserId = snapshot.userSession.currentUserId

        guard
            let userIndex = snapshot.users.firstIndex(where: { $0.id == currentUserId }),
            let itemIndex = snapshot.clothItems.firstIndex(where: { $0.id == clothItemId })
        else {
            return false
        }

        let item = snapshot.clothItems[itemIndex]
        guard item.ownerId != currentUserId else { return false }
        guard !item.isBorrowed else { return false }
        guard snapshot.users[userIndex].point >= item.pointCost else { return false }

        snapshot.users[userIndex].point -= item.pointCost
        snapshot.clothItems[itemIndex].isBorrowed = true
        snapshot.rentals.append(
            Rental(
                id: UUID(),
                clothItemId: item.id,
                ownerId: item.ownerId,
                borrowerId: currentUserId,
                status: .borrowed,
                borrowedAt: borrowedAt,
                dueAt: nil,
                returnedAt: nil,
                createdAt: borrowedAt
            )
        )

        return true
    }

    @discardableResult
    func returnRental(id rentalId: UUID, returnedAt: Date = Date()) -> Bool {
        guard let rentalIndex = snapshot.rentals.firstIndex(where: { $0.id == rentalId }) else {
            return false
        }

        let rental = snapshot.rentals[rentalIndex]
        guard rental.borrowerId == snapshot.userSession.currentUserId else { return false }
        guard rental.status == .borrowed else { return false }

        snapshot.rentals[rentalIndex].status = .returned
        snapshot.rentals[rentalIndex].returnedAt = returnedAt

        if let itemIndex = snapshot.clothItems.firstIndex(where: { $0.id == rental.clothItemId }) {
            snapshot.clothItems[itemIndex].isBorrowed = false
        }

        return true
    }
}
