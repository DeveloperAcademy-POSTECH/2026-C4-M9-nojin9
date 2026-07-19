import Foundation

// MARK: - 기존 모델 선언부 (에러 방지 유지)
struct ClosetThankYouLetter: Identifiable {
    let id = UUID()
    let author: String        // 작성자 (예: "둘째 언니(김현서)", "나")
    let date: String          // 작성일 (예: "2026년 7월 10일")
    let content: String       // 편지 내용 변수
    let images: [String]      // 편지에 첨부된 후기 사진 에셋 이름 배열
}

struct ClosetRentalItemDetail: Identifiable {
    let id: String                     // ClosetItem의 assetName과 매핑되는 고유 Key (예: "Top1")
    let owner: String                  // 소유자 (예: "첫째 언니")
    let categoryName: String           // 카테고리 텍스트 (예: "상의")
    let title: String                  // 옷 이름
    let isAvailable: Bool              // 빌려오기 가능 여부
    let color: String                  // 색상
    let price: Int                     // 가격 (하트 개수)
    let notices: [String]              // 주의 사항 문구 배열
    let thankYouLetters: [ClosetThankYouLetter] // 각 스티커별 커스텀 감사 편지 데이터 세트
}

// ===================================================
// MARK: - 통합 MockData 엔티티 (팀원 코드 기반)
// ===================================================
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
        User(id: user1Id, name: "김서연", profileImageName: "MyProfile", relationshipLabel: "첫째", point: 20000, status: .active, createdAt: baseDate, withdrawnAt: nil),
        User(id: user2Id, name: "김현서", profileImageName: "2ndSisProfile", relationshipLabel: "둘째", point: 80, status: .active, createdAt: baseDate, withdrawnAt: nil),
        User(id: user3Id, name: "김서은", profileImageName: nil, relationshipLabel: "막내", point: 95, status: .active, createdAt: baseDate, withdrawnAt: nil)
    ]

    static let userSession = UserSession(currentUserId: currentUserId)

    static let clothItems: [ClothItem] = [
        ClothItem(id: secondTopOneId, ownerId: user2Id, name: "연회색 가디건", category: .top, imageName: "Top1", cutoutImageName: nil, pointCost: 2500, description: "가볍게 걸치기 좋은 상의예요.", condition: .good, isBorrowed: false, visibilityStatus: .listed),
        ClothItem(id: secondTopTwoId, ownerId: user2Id, name: "오프숄더 니트", category: .top, imageName: "Top2", cutoutImageName: nil, pointCost: 2500, description: "약속 있는 날 입기 좋은 깔끔한 상의예요.", condition: .good, isBorrowed: false, visibilityStatus: .listed),
        ClothItem(id: secondBottomId, ownerId: user2Id, name: "버뮤다 팬츠", category: .bottom, imageName: "Bottom1", cutoutImageName: nil, pointCost: 1500, description: "어디에나 맞춰 입기 쉬운 하의예요.", condition: .normal, isBorrowed: false, visibilityStatus: .listed),
        ClothItem(id: secondAccessoryId, ownerId: user2Id, name: "리본 단화", category: .accessory, imageName: "Accessories1", cutoutImageName: nil, pointCost: 1000, description: "룩에 포인트를 주기 좋은 액세서리예요.", condition: .good, isBorrowed: false, visibilityStatus: .listed),
        ClothItem(id: youngestTopId, ownerId: user3Id, name: "하이넥 숏코트", category: .top, imageName: "Top3", cutoutImageName: nil, pointCost: 3000, description: "편하게 입기 좋은 데일리 상의예요.", condition: .good, isBorrowed: true, visibilityStatus: .listed),
        ClothItem(id: youngestBottomOneId, ownerId: user3Id, name: "트레이닝 팬츠", category: .bottom, imageName: "Bottom2", cutoutImageName: nil, pointCost: 1000, description: "활동하기 편한 하의예요.", condition: .good, isBorrowed: false, visibilityStatus: .listed),
        ClothItem(id: youngestBottomTwoId, ownerId: user3Id, name: "와이드 팬츠", category: .bottom, imageName: "Bottom3", cutoutImageName: nil, pointCost: 2500, description: "차분한 분위기로 입기 좋은 하의예요.", condition: .normal, isBorrowed: false, visibilityStatus: .listed),
        ClothItem(id: youngestAccessoryOneId, ownerId: user3Id, name: "에어팟 맥스", category: .accessory, imageName: "Accessories2", cutoutImageName: nil, pointCost: 4000, description: "외출 전에 더하기 좋은 액세서리예요.", condition: .good, isBorrowed: false, visibilityStatus: .listed),
        ClothItem(id: youngestAccessoryTwoId, ownerId: user3Id, name: "가죽 숄더백", category: .accessory, imageName: "Accessories3", cutoutImageName: nil, pointCost: 5000, description: "특별한 날 포인트로 쓰기 좋은 액세서리예요.", condition: .good, isBorrowed: false, visibilityStatus: .listed)
    ]

    static let clothItemRequests: [ClothItemRequest] = []
    static let friendships: [Friendship] = [
        makeAcceptedFriendship(id: UUID(uuidString: "dddddddd-dddd-dddd-dddd-dddddddddddd")!, firstUserId: currentUserId, secondUserId: user2Id, requestedByUserId: currentUserId),
        makeAcceptedFriendship(id: UUID(uuidString: "eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee")!, firstUserId: currentUserId, secondUserId: user3Id, requestedByUserId: user3Id)
    ]
    static let rentals: [Rental] = [
        Rental(id: returnedRentalId, clothItemId: secondTopTwoId, ownerId: user2Id, borrowerId: currentUserId, status: .returned, borrowedAt: baseDate, dueAt: nil, returnedAt: baseDate.addingTimeInterval(86_400), createdAt: baseDate),
        Rental(id: borrowedRentalId, clothItemId: youngestTopId, ownerId: user3Id, borrowerId: currentUserId, status: .borrowed, borrowedAt: baseDate.addingTimeInterval(172_800), dueAt: baseDate.addingTimeInterval(432_000), returnedAt: nil, createdAt: baseDate.addingTimeInterval(172_800))
    ]

    static let reviewSamples: [ReviewSample] = []
    static let thankYouLetters: [ThankYouLetter] = []
    
    static let snapshot = AppDataSnapshot(
        users: users, userSession: userSession, clothItems: clothItems, clothItemRequests: clothItemRequests,
        friendships: friendships, rentals: rentals, reviewSamples: reviewSamples, thankYouLetters: thankYouLetters, savedAt: baseDate
    )

    private static func makeAcceptedFriendship(id: UUID, firstUserId: UUID, secondUserId: UUID, requestedByUserId: UUID) -> Friendship {
        let pair = Friendship.normalizedPair(firstUserId, secondUserId)
        return Friendship(id: id, userAId: pair.userAId, userBId: pair.userBId, status: .accepted, requestedByUserId: requestedByUserId, createdAt: baseDate, acceptedAt: baseDate)
    }
}

// ===================================================
// MARK: - RentalMockData Bridge (회원님 기존 코드 호환 및 에러 방지 해결 단락)
// ===================================================
struct RentalMockData {
    static var items: [String: ClosetRentalItemDetail] {
        var dict: [String: ClosetRentalItemDetail] = [:]
        
        for item in MockData.clothItems {
            // imageName이 nil일 경우를 대비해 기본값 할당
            let key = item.imageName ?? "Top1"
            
            // 💡 [수정 포인트] 유저를 안전하게 꺼내고, 중첩 옵셔널(String??) 구조를 완벽하게 언랩핑
            let userObj = MockData.users.first(where: { $0.id == item.ownerId })
            let mappedOwner = (userObj?.name ?? "첫째 언니") ?? "첫째 언니"
            
            let mappedCategory = item.category == .top ? "상의" : (item.category == .bottom ? "하의" : "기타")
            
            // item.name이 nil일 경우를 대비해 기본값 처리
            let itemName = item.name ?? "이름 없는 옷"
            let mappedColor = extractColor(from: itemName)
            
            let config = staticConfig[key] ?? (notices: [], letters: [])
            
            dict[key] = ClosetRentalItemDetail(
                id: key,
                owner: mappedOwner,
                categoryName: mappedCategory,
                title: itemName,
                isAvailable: !item.isBorrowed,
                color: mappedColor,
                price: item.pointCost,
                notices: config.notices,
                thankYouLetters: config.letters
            )
        }
        return dict
    }
    
    private static func extractColor(from name: String) -> String {
        let colors = ["연회색", "진회색", "카키색", "검정색", "블랙", "연갈색", "고동색", "스페이스 그레이"]
        for color in colors {
            if name.contains(color) { return color }
        }
        return "기본색"
    }
    
    // 회원님이 기존에 선언해 두었던 감사 편지 및 주의사항 리스트 데이터 결합 테이블
    private static let staticConfig: [String: (notices: [String], letters: [ClosetThankYouLetter])] = [
        "Top1": (
            notices: ["밝은 색이라 음식 먹을 때 오염 주의 필요함.", "오염 있으면 문지르지 말고 그대로 둬야함. (드라이클리닝 해야함)", "올 나가는거 주의 부탁."],
            letters: []
        ),
        "Top2": (
            notices: ["옷이 잘 늘어나니 주의 필요함.", "오프숄더라 어깨 부분 늘어나는거 주의 필요함.", "올 나가는거 주의 부탁."],
            letters: [
                ClosetThankYouLetter(author: "둘째 언니(김현서)", date: "2026년 7월 10일", content: "언니~ 이 셔츠 입고 나 썸남이랑 영화 봤어 ㅎㅎ 땡큐", images: ["Review_Top2_1", "Review_Top2_2", "Review_Top2_3"]),
                ClosetThankYouLetter(author: "나", date: "2026년 7월 5일", content: "언니 이거 그냥 내 퍼컬이잖아; 완내스!!!", images: ["Review_Top2_4", "Review_Top2_5", "Review_Top2_6"])
            ]
        ),
        "Top3": (
            notices: ["하이넥이라 화장품 안 묻게 주의 부탁.", "냄새가 잘 배지만, 향수는 이염되기 때문에 뿌리면 안됨."],
            letters: [
                ClosetThankYouLetter(author: "둘째 언니(김현서)", date: "2025년 12월 12일", content: "언니~ 이 코트 입고 수현이랑 성수 놀러왔어 ㅎ 수현이가 코트 이쁘다고 손민수 한대 크크", images: ["Review_Top3_1", "Review_Top3_2", "Review_Top3_3"])
            ]
        ),
        "Bottom1": (
            notices: ["실밥이 약간 튀어나올 수 있음.", "꼭 뒤집어서 세탁해야 함."],
            letters: [
                ClosetThankYouLetter(author: "둘째 언니", date: "2026년 6월 28일", content: "바지 통도 넉넉하고 핏 넘 예 만족만족스", images: ["Review_Bottom1_1", "Review_Bottom1_2"]),
                ClosetThankYouLetter(author: "나", date: "2026년 7월 10일", content: "이거 입고 카공 갔다 왔엉 대박 편해서 손민수 할 예정요", images: ["Review_Bottom1_3", "Review_Bottom1_4", "Review_Bottom1_5", "Review_Bottom1_6"])
            ]
        ),
        "Bottom2": (
            notices: ["지퍼가 뻑뻑하니 올릴 때 주의 바람.", "무릎 잘 늘어나니까 격한 동작은 자제 부탁."],
            letters: []
        ),
        "Bottom3": (
            notices: ["뒷꿈치 부분 잘 쓸리니까 주의.", "허리에 옷핀이 꽂혀있으니 주의."],
            letters: [
                ClosetThankYouLetter(author: "나", date: "2026년 4월 1일", content: "이번 꽃놀이 갈 때 입었는데 봄 잡채였긔연!", images: ["Review_Bottom3_1"])
            ]
        ),
        "Accessories1": (
            notices: ["발꿈치, 복숭아뼈 약간 아픔 주의.", "비 오는 날에는 물빠질 수 있어서 착용 자제 부탁."],
            letters: [
                ClosetThankYouLetter(author: "둘째 언니", date: "2025년 11월 1일", content: "낼 소개팅 갈 때 신을거임ㅋㅋ 아 설레서 잠이 안와늉ㅠㅠ (리뷰 찍따가 야밤에 뭔 지랄이냐고 엄마가 머라함)", images: ["Review_Accessories1_1", "Review_Accessories1_2", "Review_Accessories1_3"])
            ]
        ),
        "Accessories2": (
            notices: ["정수리 부분 이염 잘되니까 머리 감고 사용 부탁.", "땀 흘리는 운동 시에 사용 절대 금지."],
            letters: [
                ClosetThankYouLetter(author: "둘째 언니", date: "2026년 6월 1일", content: "음질 대박;; 케이스도 느좋이라는 소리 들음ㅎㅎ 아 나도 가지고 싶다 사줘 언닝ㅋㅋ", images: ["Review_Accessories2_1", "Review_Accessories2_2", "Review_Accessories2_3", "Review_Accessories2_4"])
            ]
        ),
        "Accessories3": (
            notices: ["가방 안에 음식, 음료 넣기 절대 금지.", "스크레치 신경 안 써도 됨."],
            letters: []
        )
    ]
}
