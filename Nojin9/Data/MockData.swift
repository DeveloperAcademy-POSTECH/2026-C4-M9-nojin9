import Foundation

enum MockData {
    static let user1Id = UUID(uuidString: "11111111-1111-1111-1111-111111111111")!
    static let user2Id = UUID(uuidString: "22222222-2222-2222-2222-222222222222")!
    static let user3Id = UUID(uuidString: "33333333-3333-3333-3333-333333333333")!

    static let currentUserId = user1Id

    static let secondTopOneId = UUID(uuidString: "44444444-4444-4444-4444-444444444444")!
    static let secondTopTwoId = UUID(uuidString: "55555555-5555-5555-5555-555555555555")!
    static let secondBottomId = UUID(uuidString: "66666666-6666-6666-6666-666666666666")!
    static let secondAccessoryId = UUID(uuidString: "77777777-7777-7777-7777-777777777777")!
    static let youngestTopId = UUID(uuidString: "88888888-8888-8888-8888-888888888888")!
    static let youngestBottomOneId = UUID(uuidString: "99999999-9999-9999-9999-999999999999")!
    static let youngestBottomTwoId = UUID(uuidString: "12121212-1212-1212-1212-121212121212")!
    static let youngestAccessoryOneId = UUID(uuidString: "13131313-1313-1313-1313-131313131313")!
    static let youngestAccessoryTwoId = UUID(uuidString: "14141414-1414-1414-1414-141414141414")!

    static let returnedRentalId = UUID(uuidString: "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa")!
    static let borrowedRentalId = UUID(uuidString: "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb")!

    static let baseDate = Date(timeIntervalSince1970: 1_784_217_600)

    static let users: [User] = [
        User(
            id: user1Id,
            name: "김서연",
            profileImageName: "MyProfile",
            relationshipLabel: "첫째",
            point: 100,
            status: .active,
            createdAt: baseDate,
            withdrawnAt: nil
        ),
        User(
            id: user2Id,
            name: "김현서",
            profileImageName: "2ndSisProfile",
            relationshipLabel: "둘째",
            point: 80,
            status: .active,
            createdAt: baseDate,
            withdrawnAt: nil
        ),
        User(
            id: user3Id,
            name: "김서은",
            profileImageName: nil,
            relationshipLabel: "막내",
            point: 95,
            status: .active,
            createdAt: baseDate,
            withdrawnAt: nil
        )
    ]

    static let userSession = UserSession(currentUserId: currentUserId)

    static let clothItems: [ClothItem] = [
        ClothItem(
            id: secondTopOneId,
            ownerId: user2Id,
            name: "Top1",
            category: .top,
            imageName: "Top1",
            cutoutImageName: nil,
            pointCost: 20,
            description: "가볍게 걸치기 좋은 상의예요.",
            condition: .good,
            isBorrowed: false,
            visibilityStatus: .listed
        ),
        ClothItem(
            id: secondTopTwoId,
            ownerId: user2Id,
            name: "Top2",
            category: .top,
            imageName: "Top2",
            cutoutImageName: nil,
            pointCost: 25,
            description: "약속 있는 날 입기 좋은 깔끔한 상의예요.",
            condition: .good,
            isBorrowed: true,
            visibilityStatus: .listed
        ),
        ClothItem(
            id: secondBottomId,
            ownerId: user2Id,
            name: "Bottom1",
            category: .bottom,
            imageName: "Bottom1",
            cutoutImageName: nil,
            pointCost: 20,
            description: "어디에나 맞춰 입기 쉬운 하의예요.",
            condition: .normal,
            isBorrowed: false,
            visibilityStatus: .listed
        ),
        ClothItem(
            id: secondAccessoryId,
            ownerId: user2Id,
            name: "Accessories1",
            category: .accessory,
            imageName: "Accessories1",
            cutoutImageName: nil,
            pointCost: 15,
            description: "룩에 포인트를 주기 좋은 액세서리예요.",
            condition: .good,
            isBorrowed: false,
            visibilityStatus: .listed
        ),
        ClothItem(
            id: youngestTopId,
            ownerId: user3Id,
            name: "Top3",
            category: .top,
            imageName: "Top3",
            cutoutImageName: nil,
            pointCost: 20,
            description: "편하게 입기 좋은 데일리 상의예요.",
            condition: .good,
            isBorrowed: false,
            visibilityStatus: .listed
        ),
        ClothItem(
            id: youngestBottomOneId,
            ownerId: user3Id,
            name: "bottom2",
            category: .bottom,
            imageName: "bottom2",
            cutoutImageName: nil,
            pointCost: 20,
            description: "활동하기 편한 하의예요.",
            condition: .good,
            isBorrowed: false,
            visibilityStatus: .listed
        ),
        ClothItem(
            id: youngestBottomTwoId,
            ownerId: user3Id,
            name: "bottom3",
            category: .bottom,
            imageName: "bottom3",
            cutoutImageName: nil,
            pointCost: 20,
            description: "차분한 분위기로 입기 좋은 하의예요.",
            condition: .normal,
            isBorrowed: false,
            visibilityStatus: .listed
        ),
        ClothItem(
            id: youngestAccessoryOneId,
            ownerId: user3Id,
            name: "Accessories2",
            category: .accessory,
            imageName: "Accessories2",
            cutoutImageName: nil,
            pointCost: 15,
            description: "외출 전에 더하기 좋은 액세서리예요.",
            condition: .good,
            isBorrowed: false,
            visibilityStatus: .listed
        ),
        ClothItem(
            id: youngestAccessoryTwoId,
            ownerId: user3Id,
            name: "Accessories3",
            category: .accessory,
            imageName: "Accessories3",
            cutoutImageName: nil,
            pointCost: 15,
            description: "특별한 날 포인트로 쓰기 좋은 액세서리예요.",
            condition: .good,
            isBorrowed: false,
            visibilityStatus: .stored
        )
    ]

    static let clothItemRequests: [ClothItemRequest] = []

    static let friendships: [Friendship] = [
        makeAcceptedFriendship(
            id: UUID(uuidString: "dddddddd-dddd-dddd-dddd-dddddddddddd")!,
            firstUserId: currentUserId,
            secondUserId: user2Id,
            requestedByUserId: currentUserId
        ),
        makeAcceptedFriendship(
            id: UUID(uuidString: "eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee")!,
            firstUserId: currentUserId,
            secondUserId: user3Id,
            requestedByUserId: user3Id
        )
    ]

    static let rentals: [Rental] = [
        Rental(
            id: returnedRentalId,
            clothItemId: secondTopOneId,
            ownerId: user2Id,
            borrowerId: currentUserId,
            status: .returned,
            borrowedAt: baseDate,
            dueAt: nil,
            returnedAt: baseDate.addingTimeInterval(86_400),
            createdAt: baseDate
        ),
        Rental(
            id: borrowedRentalId,
            clothItemId: secondTopTwoId,
            ownerId: user2Id,
            borrowerId: currentUserId,
            status: .borrowed,
            borrowedAt: baseDate.addingTimeInterval(172_800),
            dueAt: baseDate.addingTimeInterval(432_000),
            returnedAt: nil,
            createdAt: baseDate.addingTimeInterval(172_800)
        )
    ]

    static let reviewSamples: [ReviewSample] = [
        ReviewSample(
            id: UUID(uuidString: "ffffffff-ffff-ffff-ffff-ffffffffffff")!,
            clothItemId: secondTopOneId,
            imageName: "Review101",
            message: "약속 날에 잘 입었어요. 핏도 좋고 사진도 예쁘게 나왔어요.",
            createdAt: baseDate.addingTimeInterval(86_400)
        )
    ]

    static let thankYouLetters: [ThankYouLetter] = [
        ThankYouLetter(
            id: UUID(uuidString: "abababab-abab-abab-abab-abababababab")!,
            rentalId: returnedRentalId,
            toSisterId: user2Id,
            clothItemId: secondTopOneId,
            message: "덕분에 약속에 잘 다녀왔어. 다음에 나도 필요한 옷 있으면 꼭 빌려줄게!",
            createdAt: baseDate.addingTimeInterval(86_400)
        )
    ]

    static let snapshot = AppDataSnapshot(
        users: users,
        userSession: userSession,
        clothItems: clothItems,
        clothItemRequests: clothItemRequests,
        friendships: friendships,
        rentals: rentals,
        reviewSamples: reviewSamples,
        thankYouLetters: thankYouLetters,
        savedAt: baseDate
    )

    private static func makeAcceptedFriendship(
        id: UUID,
        firstUserId: UUID,
        secondUserId: UUID,
        requestedByUserId: UUID
    ) -> Friendship {
        let pair = Friendship.normalizedPair(firstUserId, secondUserId)

        return Friendship(
            id: id,
            userAId: pair.userAId,
            userBId: pair.userBId,
            status: .accepted,
            requestedByUserId: requestedByUserId,
            createdAt: baseDate,
            acceptedAt: baseDate
        )
    }
}
