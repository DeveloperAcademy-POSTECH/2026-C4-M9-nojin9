import Foundation

struct User: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var profileImageName: String?
    var relationshipLabel: String?
    var point: Int
    var status: UserStatus
    let createdAt: Date
    var withdrawnAt: Date?
}

enum UserStatus: String, Codable, Equatable {
    case active
    case withdrawn
}

struct UserSession: Codable, Equatable {
    var currentUserId: UUID
}

struct ClothItem: Identifiable, Codable, Equatable {
    let id: UUID
    var ownerId: UUID
    var name: String
    var category: ClothCategory
    var imageName: String?
    var cutoutImageName: String?
    var pointCost: Int
    var description: String
    var condition: ClothCondition
    var isBorrowed: Bool
    var visibilityStatus: ItemVisibilityStatus
}

enum ClothCategory: String, Codable, Equatable {
    case top
    case bottom
    case accessory
}

extension ClothCategory {
    var displayName: String {
        switch self {
        case .top:
            return "상의"
        case .bottom:
            return "하의"
        case .accessory:
            return "기타"
        }
    }
}

enum ClothCondition: String, Codable, Equatable {
    case good
    case normal
    case damaged
}

enum ItemVisibilityStatus: String, Codable, Equatable {
    case listed
    case stored
}

struct ClothItemRequest: Identifiable, Codable, Equatable {
    let id: UUID
    var requesterId: UUID
    var ownerId: UUID
    var title: String?
    var imageName: String?
    var message: String?
    var status: ClothItemRequestStatus
    let createdAt: Date
}

enum ClothItemRequestStatus: String, Codable, Equatable {
    case pending
    case accepted
    case rejected
}

struct Friendship: Identifiable, Codable, Equatable {
    let id: UUID
    var userAId: UUID
    var userBId: UUID
    var status: FriendshipStatus
    var requestedByUserId: UUID
    let createdAt: Date
    var acceptedAt: Date?

    func friendId(for currentUserId: UUID) -> UUID? {
        if userAId == currentUserId { return userBId }
        if userBId == currentUserId { return userAId }
        return nil
    }

    static func normalizedPair(_ firstUserId: UUID, _ secondUserId: UUID) -> (userAId: UUID, userBId: UUID) {
        if firstUserId.uuidString < secondUserId.uuidString {
            return (firstUserId, secondUserId)
        }

        return (secondUserId, firstUserId)
    }
}

enum FriendshipStatus: String, Codable, Equatable {
    case requested
    case accepted
}

struct Rental: Identifiable, Codable, Equatable {
    let id: UUID
    var clothItemId: UUID
    var ownerId: UUID
    var borrowerId: UUID
    var status: RentalStatus
    let borrowedAt: Date
    var dueAt: Date?
    var returnedAt: Date?
    let createdAt: Date
}

enum RentalStatus: String, Codable, Equatable {
    case borrowed
    case returned
}

struct ReviewSample: Identifiable, Codable, Equatable {
    let id: UUID
    var clothItemId: UUID
    var imageName: String
    var message: String
    let createdAt: Date
}

struct Review: Identifiable, Codable, Equatable {
    let id: UUID
    let rentalId: UUID
    let clothItemId: UUID

    /// 감사 편지를 작성한 사람
    let writerId: UUID

    /// 옷의 주인
    let receiverId: UUID

    let message: String
    let photoDataList: [Data]
    let createdAt: Date
}

struct ThankYouLetter: Identifiable, Codable, Equatable {
    let id: UUID
    var rentalId: UUID
    var toSisterId: UUID
    var clothItemId: UUID
    var message: String
    let createdAt: Date
}
