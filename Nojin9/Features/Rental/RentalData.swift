//
//  RentalData.swift
//  Nojin9
//
//  Created by 김가은 on 7/19/26.
//

import Foundation

struct RentalItemDetailSupplement {
    let color: String
    let notices: [String]

    static let fallback = RentalItemDetailSupplement(
        color: "정보 없음",
        notices: ["대여 전 옷 상태와 세탁 방법을 언니와 확인해 주세요."]
    )
}

struct RentalThankYouLetterDisplay: Identifiable {
    let id: UUID
    let author: String
    let profileImageName: String?
    let date: String
    let content: String
    let images: [String]
}

enum RentalDetailMockData {
    static let supplements: [String: RentalItemDetailSupplement] = [
        "Top1": RentalItemDetailSupplement(
            color: "연회색",
            notices: [
                "밝은 색이라 음식 먹을 때 오염 주의 필요함.",
                "오염 있으면 문지르지 말고 그대로 둬야함. (드라이클리닝 해야함)",
                "올 나가는거 주의 부탁."
            ]
        ),
        "Top2": RentalItemDetailSupplement(
            color: "진회색",
            notices: [
                "옷이 잘 늘어나니 주의 필요함.",
                "오프숄더라 어깨 부분 늘어나는거 주의 필요함.",
                "올 나가는거 주의 부탁."
            ]
        ),
        "Top3": RentalItemDetailSupplement(
            color: "카키색",
            notices: [
                "하이넥이라 화장품 안 묻게 주의 부탁.",
                "냄새가 잘 배지만, 향수는 이염되기 때문에 뿌리면 안됨."
            ]
        ),
        "Bottom1": RentalItemDetailSupplement(
            color: "검정색",
            notices: [
                "실밥이 약간 튀어나올 수 있음.",
                "꼭 뒤집어서 세탁해야 함."
            ]
        ),
        "Bottom2": RentalItemDetailSupplement(
            color: "블랙",
            notices: [
                "지퍼가 뻑뻑하니 올릴 때 주의 바람.",
                "무릎 잘 늘어나니까 격한 동작은 자제 부탁."
            ]
        ),
        "Bottom3": RentalItemDetailSupplement(
            color: "연갈색",
            notices: [
                "뒷꿈치 부분 잘 쓸리니까 주의.",
                "허리에 옷핀이 꽂혀있으니 주의."
            ]
        ),
        "Accessories1": RentalItemDetailSupplement(
            color: "고동색",
            notices: [
                "발꿈치, 복숭아뼈 약간 아픔 주의.",
                "비 오는 날에는 물빠질 수 있어서 착용 자제 부탁."
            ]
        ),
        "Accessories2": RentalItemDetailSupplement(
            color: "스페이스 그레이",
            notices: [
                "정수리 부분 이염 잘되니까 머리 감고 사용 부탁.",
                "땀 흘리는 운동 시에 사용 절대 금지."
            ]
        ),
        "Accessories3": RentalItemDetailSupplement(
            color: "고동색",
            notices: [
                "가방 안에 음식, 음료 넣기 절대 금지.",
                "스크레치 신경 안 써도 됨."
            ]
        )
    ]

    static func supplement(for item: ClothItem) -> RentalItemDetailSupplement {
        let key = item.imageName ?? item.name
        return supplements[key] ?? .fallback
    }
}
