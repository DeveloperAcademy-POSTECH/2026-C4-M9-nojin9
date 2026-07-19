//
//  Untitled.swift
//  Nojin9
//
//  Created by Kimseoyeon on 7/19/26.
//


import Foundation

// MARK: - 감사 편지 데이터 모델
/// 프로젝트 내 다른 이름과의 충돌을 방지하기 위해 Closet접두어를 붙였습니다.
struct ClosetThankYouLetter: Identifiable {
    let id = UUID()
    let author: String        // 작성자 (예: "둘째 언니(김현서)", "나")
    let date: String          // 작성일 (예: "2026년 7월 10일")
    let content: String       // 편지 내용 변수
    let images: [String]      // 편지에 첨부된 후기 사진 에셋 이름 배열
}

// MARK: - 스티커별 상세 정보 메인 모델
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

// MARK: - 전역 Mock 데이터 저장소
struct RentalMockData {
    
    /// 스티커 ID를 Key로 가지는 딕셔너리 데이터셋
    static let items: [String: ClosetRentalItemDetail] = [
        "Top1": ClosetRentalItemDetail(
            id: "Top1", owner: "첫째 언니", categoryName: "상의",
            title: "연회색 가디건", isAvailable: true, color: "연회색", price: 2500,
            notices: [
                "밝은 색이라 음식 먹을 때 오염 주의 필요함.",
                "오염 있으면 문지르지 말고 그대로 둬야함. (드라이클리닝 해야함)",
                "올 나가는거 주의 부탁."
            ],
            thankYouLetters: []
        ),
        
        
        "Top2": ClosetRentalItemDetail(
            id: "Top2", owner: "첫째 언니", categoryName: "상의",
            title: "오프숄더 니트", isAvailable: true, color: "진회색", price: 2500,
            notices: ["옷이 잘 늘어나니 주의 필요함.",
                      "오프숄더라 어깨 부분 늘어나는거 주의 필요함.",
                      "올 나가는거 주의 부탁."],
            thankYouLetters: [
                ClosetThankYouLetter(
                    author: "둘째 언니(김현서)", date: "2026년 7월 10일",
                    content: "언니~ 이 셔츠 입고 나 썸남이랑 영화 봤어 ㅎㅎ 땡큐",
                    images: ["Review_Top2_1", "Review_Top2_2", "Review_Top2_3"]
                ),
                ClosetThankYouLetter(
                    author: "나", date: "2026년 7월 5일",
                    content: "언니 이거 그냥 내 퍼컬이잖아; 완내스!!!",
                    images: ["Review_Top2_4", "Review_Top2_5", "Review_Top2_6"]
                )
            ]
        ),
        
        
        "Top3": ClosetRentalItemDetail(
            id: "Top3", owner: "첫째 언니", categoryName: "상의",
            title: "하이넥 숏코트", isAvailable: false, color: "카키색", price: 3000,
            notices: ["하이넥이라 화장품 안 묻게 주의 부탁.", "냄새가 잘 배지만, 향수는 이염되기 때문에 뿌리면 안됨."],
            thankYouLetters: [
                ClosetThankYouLetter(
                    author: "둘째 언니(김현서)", date: "2025년 12월 12일",
                    content: "언니~ 이 코트 입고 수현이랑 성수 놀러왔어 ㅎ 수현이가 코트 이쁘다고 손민수 한대 크크",
                    images: ["Review_Top3_1", "Review_Top3_2", "Review_Top3_3"]
                )
            ]
        ),
        
        
        "Bottom1": ClosetRentalItemDetail(
            id: "Bottom1", owner: "첫째 언니", categoryName: "하의",
            title: "버뮤다 팬츠", isAvailable: true, color: "검정색", price: 1500,
            notices: ["실밥이 약간 튀어나올 수 있음.", "꼭 뒤집어서 세탁해야 함."],
            thankYouLetters: [
                ClosetThankYouLetter(
                    author: "둘째 언니", date: "2026년 6월 28일",
                    content: "바지 통도 넉넉하고 핏 넘 예 만족만족스",
                    images: ["Review_Bottom1_1", "Review_Bottom1_2"]
                ),
                ClosetThankYouLetter(
                    author: "나", date: "2026년 7월 10일",
                    content: "이거 입고 카공 갔다 왔엉 대박 편해서 손민수 할 예정요",
                    images: ["Review_Bottom1_3", "Review_Bottom1_4", "Review_Bottom1_5", "Review_Bottom1_6"]
                )
            ]
        ),
        
        
        "Bottom2": ClosetRentalItemDetail(
            id: "Bottom2", owner: "첫째 언니", categoryName: "하의",
            title: "트레이닝 팬츠", isAvailable: true, color: "블랙", price: 1000,
            notices: ["지퍼가 뻑뻑하니 올릴 때 주의 바람.", "무릎 잘 늘어나니까 격한 동작은 자제 부탁."],
            thankYouLetters: []
        ),
        
        
        "Bottom3": ClosetRentalItemDetail(
            id: "Bottom3", owner: "첫째 언니", categoryName: "하의",
            title: "와이드 팬츠", isAvailable: true, color: "연갈색", price: 2500,
            notices: ["뒷꿈치 부분 잘 쓸리니까 주의.", "허리에 옷핀이 꽂혀있으니 주의."],
            thankYouLetters: [
                ClosetThankYouLetter(
                    author: "나", date: "2026년 4월 1일",
                    content: "이번 꽃놀이 갈 때 입었는데 봄 잡채였긔연!",
                    images: ["Review_Bottom3_1"]
                )
            ]
        ),
        
        
        "Accessories1": ClosetRentalItemDetail(
            id: "Accessories1", owner: "첫째 언니", categoryName: "기타",
            title: "리본 단화", isAvailable: true, color: "고동색", price: 1000,
            notices: ["발꿈치, 복숭아뼈 약간 아픔 주의.", "비 오는 날에는 물빠질 수 있어서 착용 자제 부탁."],
            thankYouLetters: [
                ClosetThankYouLetter(
                    author: "둘째 언니", date: "2025년 11월 1일",
                    content: "낼 소개팅 갈 때 신을거임ㅋㅋ 아 설레서 잠이 안와늉ㅠㅠ (리뷰 찍따가 야밤에 뭔 지랄이냐고 엄마가 머라함)",
                    images: ["Review_Accessories1_1", "Review_Accessories1_2", "Review_Accessories1_3"]
                )
            ]
        ),
        
        
        "Accessories2": ClosetRentalItemDetail(
            id: "Accessories2", owner: "첫째 언니", categoryName: "기타",
            title: "에어팟 맥스", isAvailable: true, color: "스페이스 그레이", price: 4000,
            notices: ["정수리 부분 이염 잘되니까 머리 감고 사용 부탁.", "땀 흘리는 운동 시에 사용 절대 금지."],
            thankYouLetters: [
                ClosetThankYouLetter(
                    author: "둘째 언니", date: "2026년 6월 1일",
                    content: "음질 대박;; 케이스도 느좋이라는 소리 들음ㅎㅎ 아 나도 가지고 싶다 사줘 언닝ㅋㅋ",
                    images: ["Review_Accessories2_1", "Review_Accessories2_2", "Review_Accessories2_3", "Review_Accessories2_4"]
                )
            ]
        ),
        
        
        "Accessories3": ClosetRentalItemDetail(
            id: "Accessories3", owner: "첫째 언니", categoryName: "기타",
            title: "가죽 숄더백", isAvailable: true, color: "고동색", price: 5000,
            notices: ["가방 안에 음식, 음료 넣기 절대 금지.", "스크레치 신경 안 써도 됨."],
            thankYouLetters: []
        )
    ]
}
