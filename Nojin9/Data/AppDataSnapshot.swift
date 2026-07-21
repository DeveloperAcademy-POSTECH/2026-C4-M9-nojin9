import Foundation

struct AppDataSnapshot: Codable, Equatable {
    var users: [User]
    var userSession: UserSession
    var clothItems: [ClothItem]
    var clothItemRequests: [ClothItemRequest]
    var friendships: [Friendship]
    var rentals: [Rental]
    var reviewSamples: [ReviewSample]
    var reviews: [Review]
    var thankYouLetters: [ThankYouLetter]
    var savedAt: Date
}
