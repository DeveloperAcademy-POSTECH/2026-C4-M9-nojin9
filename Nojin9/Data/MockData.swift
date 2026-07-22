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
    let color: String                  // 색상명
    let colorHex: String?              // 표시용 hex 색상값
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

    static let returnedRentalClothItemId = UUID(uuidString: "55555555-5555-5555-5555-555555555555")!
    static let borrowedRentalClothItemId = UUID(uuidString: "88888888-8888-8888-8888-888888888888")!

    static let returnedRentalId = UUID(uuidString: "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa")!
    static let borrowedRentalId = UUID(uuidString: "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb")!

    static let baseDate = Date(timeIntervalSince1970: 1_784_217_600)

    static let users: [User] = [
        User(id: user1Id, name: "김서연", profileImageName: "MyProfile", relationshipLabel: "막내", point: 20000, status: .active, createdAt: baseDate, withdrawnAt: nil),
        User(id: user2Id, name: "김서은", profileImageName: nil, relationshipLabel: "첫째", point: 80, status: .active, createdAt: baseDate, withdrawnAt: nil),
        User(id: user3Id, name: "김현서", profileImageName: "2ndSisProfile", relationshipLabel: "둘째", point: 95, status: .active, createdAt: baseDate, withdrawnAt: nil)
    ]

    static let userSession = UserSession(currentUserId: currentUserId)

    static let clothItems: [ClothItem] = [
        makeClothItem("15111111-1111-1111-1111-111111111111", ownerId: user1Id, name: "빈티지 그래픽 티셔츠", category: .top, imageName: "MyTop1", pointCost: 2500, description: "내 옷장에 등록된 상의예요."),
        makeClothItem("15111111-1111-1111-1111-111111111112", ownerId: user1Id, name: "아이보리 셔링 블라우스", category: .top, imageName: "MyTop2", pointCost: 2500, description: "내 옷장에 등록된 상의예요."),
        makeClothItem("15111111-1111-1111-1111-111111111113", ownerId: user1Id, name: "스카이블루 니트", category: .top, imageName: "MyTop3", pointCost: 3000, description: "내 옷장에 등록된 상의예요."),
        makeClothItem("15111111-1111-1111-1111-111111111114", ownerId: user1Id, name: "데님 미니스커트", category: .bottom, imageName: "MyBottom1", pointCost: 1500, description: "내 옷장에 등록된 하의예요."),
        makeClothItem("15111111-1111-1111-1111-111111111115", ownerId: user1Id, name: "크림 와이드 팬츠", category: .bottom, imageName: "MyBottom2", pointCost: 1000, description: "내 옷장에 등록된 하의예요."),
        makeClothItem("15111111-1111-1111-1111-111111111116", ownerId: user1Id, name: "리조트 밴딩 팬츠", category: .bottom, imageName: "MyBottom3", pointCost: 2500, description: "내 옷장에 등록된 하의예요."),
        makeClothItem("15111111-1111-1111-1111-111111111117", ownerId: user1Id, name: "블랙 숄더백", category: .accessory, imageName: "MyAccessories1", pointCost: 1000, description: "내 옷장에 등록된 기타 아이템이에요."),
        makeClothItem("15111111-1111-1111-1111-111111111118", ownerId: user1Id, name: "니트 비니", category: .accessory, imageName: "MyAccessories2", pointCost: 4000, description: "내 옷장에 등록된 기타 아이템이에요."),
        makeClothItem("15111111-1111-1111-1111-111111111119", ownerId: user1Id, name: "캠프 볼캡", category: .accessory, imageName: "MyAccessories3", pointCost: 5000, description: "내 옷장에 등록된 기타 아이템이에요."),
        makeClothItem("44444444-4444-4444-4444-444444444444", ownerId: user2Id, name: "연회색 가디건", category: .top, imageName: "Top1", pointCost: 2500, description: "가볍게 걸치기 좋은 상의예요."),
        makeClothItem(returnedRentalClothItemId, ownerId: user2Id, name: "오프숄더 니트", category: .top, imageName: "Top2", pointCost: 2500, description: "약속 있는 날 입기 좋은 깔끔한 상의예요."),
        makeClothItem(borrowedRentalClothItemId, ownerId: user2Id, name: "하이넥 숏코트", category: .top, imageName: "Top3", pointCost: 3000, description: "편하게 입기 좋은 데일리 상의예요.", isBorrowed: true),
        makeClothItem("24222222-2222-2222-2222-222222222224", ownerId: user2Id, name: "포인트 셔츠", category: .top, imageName: "Top4", pointCost: 2200, description: "가볍게 빌려 입기 좋은 상의예요."),
        makeClothItem("24222222-2222-2222-2222-222222222225", ownerId: user2Id, name: "러플 슬리브 탑", category: .top, imageName: "Top5", pointCost: 2300, description: "특별한 날 입기 좋은 상의예요."),
        makeClothItem("66666666-6666-6666-6666-666666666666", ownerId: user2Id, name: "버뮤다 팬츠", category: .bottom, imageName: "Bottom1", pointCost: 1500, description: "어디에나 맞춰 입기 쉬운 하의예요.", condition: .normal),
        makeClothItem("99999999-9999-9999-9999-999999999999", ownerId: user2Id, name: "트레이닝 팬츠", category: .bottom, imageName: "Bottom2", pointCost: 1000, description: "활동하기 편한 하의예요."),
        makeClothItem("12121212-1212-1212-1212-121212121212", ownerId: user2Id, name: "와이드 팬츠", category: .bottom, imageName: "Bottom3", pointCost: 2500, description: "차분한 분위기로 입기 좋은 하의예요.", condition: .normal),
        makeClothItem("26222222-2222-2222-2222-222222222224", ownerId: user2Id, name: "워싱 데님 팬츠", category: .bottom, imageName: "Bottom4", pointCost: 1800, description: "데일리로 빌려 입기 좋은 하의예요."),
        makeClothItem("26222222-2222-2222-2222-222222222225", ownerId: user2Id, name: "플리츠 스커트", category: .bottom, imageName: "Bottom5", pointCost: 1700, description: "가볍게 포인트 주기 좋은 하의예요."),
        makeClothItem("26222222-2222-2222-2222-222222222226", ownerId: user2Id, name: "카고 팬츠", category: .bottom, imageName: "Bottom6", pointCost: 1900, description: "활동적인 날 빌려 입기 좋은 하의예요."),
        makeClothItem("26222222-2222-2222-2222-222222222227", ownerId: user2Id, name: "롱 데님 스커트", category: .bottom, imageName: "Bottom7", pointCost: 2000, description: "깔끔한 무드로 입기 좋은 하의예요."),
        makeClothItem("77777777-7777-7777-7777-777777777777", ownerId: user2Id, name: "리본 단화", category: .accessory, imageName: "Accessories1", pointCost: 1000, description: "룩에 포인트를 주기 좋은 액세서리예요."),
        makeClothItem("13131313-1313-1313-1313-131313131313", ownerId: user2Id, name: "에어팟 맥스", category: .accessory, imageName: "Accessories2", pointCost: 4000, description: "외출 전에 더하기 좋은 액세서리예요."),
        makeClothItem("14141414-1414-1414-1414-141414141414", ownerId: user2Id, name: "가죽 숄더백", category: .accessory, imageName: "Accessories3", pointCost: 5000, description: "특별한 날 포인트로 쓰기 좋은 액세서리예요."),
        makeClothItem("27222222-2222-2222-2222-222222222224", ownerId: user2Id, name: "실버 목걸이", category: .accessory, imageName: "Accessories4", pointCost: 1200, description: "룩을 정리해주는 기타 아이템이에요."),
        makeClothItem("27222222-2222-2222-2222-222222222225", ownerId: user2Id, name: "미니 숄더백", category: .accessory, imageName: "Accessories5", pointCost: 2600, description: "외출할 때 들기 좋은 기타 아이템이에요."),
        makeClothItem("27222222-2222-2222-2222-222222222226", ownerId: user2Id, name: "체크 머플러", category: .accessory, imageName: "Accessories6", pointCost: 1500, description: "쌀쌀한 날 더하기 좋은 기타 아이템이에요."),
        makeClothItem("33333333-3333-3333-3333-333333333331", ownerId: user3Id, name: "", category: .top, imageName: "2ndSisTop1", pointCost: 0, description: ""),
        makeClothItem("33333333-3333-3333-3333-333333333332", ownerId: user3Id, name: "", category: .top, imageName: "2ndSisTop2", pointCost: 0, description: ""),
        makeClothItem("33333333-3333-3333-3333-333333333333", ownerId: user3Id, name: "", category: .top, imageName: "2ndSisTop3", pointCost: 0, description: ""),
        makeClothItem("33333333-3333-3333-3333-333333333334", ownerId: user3Id, name: "", category: .bottom, imageName: "2ndSisBottom1", pointCost: 0, description: ""),
        makeClothItem("33333333-3333-3333-3333-333333333335", ownerId: user3Id, name: "", category: .bottom, imageName: "2ndSisBottom2", pointCost: 0, description: ""),
        makeClothItem("33333333-3333-3333-3333-333333333336", ownerId: user3Id, name: "", category: .bottom, imageName: "2ndSisBottom3", pointCost: 0, description: ""),
        makeClothItem("33333333-3333-3333-3333-333333333337", ownerId: user3Id, name: "", category: .accessory, imageName: "2ndSisAccessories1", pointCost: 0, description: ""),
        makeClothItem("33333333-3333-3333-3333-333333333338", ownerId: user3Id, name: "", category: .accessory, imageName: "2ndSisAccessories2", pointCost: 0, description: ""),
        makeClothItem("33333333-3333-3333-3333-333333333339", ownerId: user3Id, name: "", category: .accessory, imageName: "2ndSisAccessories3", pointCost: 0, description: "")
    ]

    static let clothItemRequests: [ClothItemRequest] = []
    static let friendships: [Friendship] = [
        makeAcceptedFriendship(id: UUID(uuidString: "dddddddd-dddd-dddd-dddd-dddddddddddd")!, firstUserId: currentUserId, secondUserId: user2Id, requestedByUserId: currentUserId),
        makeAcceptedFriendship(id: UUID(uuidString: "eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee")!, firstUserId: currentUserId, secondUserId: user3Id, requestedByUserId: user3Id)
    ]
    static let rentals: [Rental] = [
        Rental(id: returnedRentalId, clothItemId: returnedRentalClothItemId, ownerId: user2Id, borrowerId: currentUserId, status: .returned, borrowedAt: baseDate, dueAt: nil, returnedAt: baseDate.addingTimeInterval(86_400), createdAt: baseDate),
        Rental(id: borrowedRentalId, clothItemId: borrowedRentalClothItemId, ownerId: user2Id, borrowerId: currentUserId, status: .borrowed, borrowedAt: baseDate.addingTimeInterval(172_800), dueAt: baseDate.addingTimeInterval(432_000), returnedAt: nil, createdAt: baseDate.addingTimeInterval(172_800))
    ]

    static let reviewSamples: [ReviewSample] = []
    static let thankYouLetters: [ThankYouLetter] = []
    
    static let snapshot = AppDataSnapshot(
        users: users, userSession: userSession, clothItems: clothItems, clothItemRequests: clothItemRequests,
        friendships: friendships, rentals: rentals, reviewSamples: reviewSamples, reviews: [], thankYouLetters: thankYouLetters, savedAt: baseDate
    )

    private static func makeClothItem(
        _ uuidString: String,
        ownerId: UUID,
        name: String,
        category: ClothCategory,
        imageName: String,
        pointCost: Int,
        description: String,
        condition: ClothCondition = .good,
        isBorrowed: Bool = false
    ) -> ClothItem {
        makeClothItem(
            UUID(uuidString: uuidString)!,
            ownerId: ownerId,
            name: name,
            category: category,
            imageName: imageName,
            pointCost: pointCost,
            description: description,
            condition: condition,
            isBorrowed: isBorrowed
        )
    }

    private static func makeClothItem(
        _ id: UUID,
        ownerId: UUID,
        name: String,
        category: ClothCategory,
        imageName: String,
        pointCost: Int,
        description: String,
        condition: ClothCondition = .good,
        isBorrowed: Bool = false
    ) -> ClothItem {
        let keyColor = ClosetStickerColorSeed.color(for: imageName)

        return ClothItem(
            id: id,
            ownerId: ownerId,
            name: name,
            category: category,
            imageName: imageName,
            cutoutImageName: nil,
            keyColorName: keyColor?.name,
            keyColorHex: keyColor?.hex,
            pointCost: pointCost,
            description: description,
            condition: condition,
            isBorrowed: isBorrowed,
            visibilityStatus: .listed
        )
    }

    private static func makeAcceptedFriendship(id: UUID, firstUserId: UUID, secondUserId: UUID, requestedByUserId: UUID) -> Friendship {
        let pair = Friendship.normalizedPair(firstUserId, secondUserId)
        return Friendship(id: id, userAId: pair.userAId, userBId: pair.userBId, status: .accepted, requestedByUserId: requestedByUserId, createdAt: baseDate, acceptedAt: baseDate)
    }
}

// ===================================================
// MARK: - RentalMockData Bridge (회원님 기존 코드 호환 및 에러 방지 해결 단락)
// ===================================================
struct RentalMockData {
    static func notices(for imageName: String?) -> [String] {
        guard let imageName else {
            return []
        }

        return staticConfig[imageName]?.notices ?? []
    }

    static func thankYouLetters(for imageName: String?) -> [ClosetThankYouLetter] {
        guard let imageName else {
            return []
        }

        return staticConfig[imageName]?.letters ?? []
    }

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
            let seededColor = ClosetStickerColorSeed.color(for: item.imageName)
            let mappedColor = item.keyColorName ?? seededColor?.name ?? "기본색"
            let mappedColorHex = item.keyColorHex ?? seededColor?.hex
            
            let config = staticConfig[key] ?? (notices: [], letters: [])
            
            dict[key] = ClosetRentalItemDetail(
                id: key,
                owner: mappedOwner,
                categoryName: mappedCategory,
                title: itemName,
                isAvailable: !item.isBorrowed,
                color: mappedColor,
                colorHex: mappedColorHex,
                price: item.pointCost,
                notices: config.notices,
                thankYouLetters: config.letters
            )
        }
        return dict
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
        ),
        "MyTop1": (
            notices: [],
            letters: [
                ClosetThankYouLetter(author: "첫째 언니", date: "2026년 7월 21일", content: "상하이 여행 갔을 때 입었는데 애들이 다 정보 물어봄~ 근데 이거 브랜드맬빌꺼냐? 좀 끼네;;", images: ["ThanksReview_2_1", "ThanksReview_2_2", "ThanksReview_2_3"])
            ]
        ),
        "MyTop2": (
            notices: [],
            letters: [
                ClosetThankYouLetter(author: "첫째 언니", date: "2026년 7월 21일", content: "스카 왔다가 리뷰 쓰려고 이러고 있다;; 찍다가 소리 나서 사람들이 다 쳐다봄 ㅠㅠ 개쪽팔려", images: ["ThanksReview_4_1", "ThanksReview_4_2", "ThanksReview_4_3"])
            ]
        ),
        "MyAccessories1": (
            notices: [],
            letters: [
                ClosetThankYouLetter(author: "첫째 언니", date: "2026년 7월 21일", content: "이거 아이패드 들어가니?? 들어가면 학교 갈 때도 종종 빌려야겟슨", images: ["ThanksReview_6_1"])
            ]
        ),
        "MyAccessories2": (
            notices: [],
            letters: [
                ClosetThankYouLetter(author: "첫째 언니", date: "2026년 7월 21일", content: "언니 머리 안 감고 쓴거 아니다;; 머리 붕 떠서 쓴거임", images: ["ThanksReview_1_1"])
            ]
        ),
        "MyAccessories3": (
            notices: [],
            letters: [
                ClosetThankYouLetter(author: "첫째 언니", date: "2026년 7월 21일", content: "낼 해방촌 갈 때 써야징~ 어때? 너보다 내가 더 잘 어울리지 않냐?", images: ["ThanksReview_3_1", "ThanksReview_3_2"])
            ]
        ),
        "MyBottom3": (
            notices: [],
            letters: [
                ClosetThankYouLetter(author: "첫째 언니", date: "2026년 7월 21일", content: "남친이랑 바다 갔을 때 입음 ㅎㅎ 준서 오빠가 핏 이쁘다고 리뷰 사진 같이 찍어줌", images: ["ThanksReview_5_1", "ThanksReview_5_2"])
            ]
        )
    ]
}
