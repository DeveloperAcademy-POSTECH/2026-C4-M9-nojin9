import SwiftUI

struct ReviewData: Identifiable {
    let id = UUID()
    let badgeName: String
    let title: String
    let content: String
    let mainImageNames: [String]
    let clothesImageName: String
    let clothesName: String
    let dateRange: String
}

struct ReceivedReviewPreview: Identifiable {
    let month: String
    let review: ReviewData

    var id: String {
        imageName
    }

    var authorName: String {
        review.badgeName
    }

    var imageName: String {
        review.mainImageNames.first ?? review.clothesImageName
    }
}

struct ReceivedReviewMonthSection: Identifiable {
    var id: String {
        month
    }

    let month: String
    let previews: [ReceivedReviewPreview]
}

enum ReceivedReviewSeed {
    static let previews: [ReceivedReviewPreview] = [
        ReceivedReviewPreview(
            month: "2026.06",
            review: ReviewData(
                badgeName: "서은",
                title: "첫째 언니 (김서은)",
                content: "언니 머리 안 감고 쓴거 아니다;; 머리 붕 떠서 쓴거임",
                mainImageNames: ["ThanksReview_1_1"],
                clothesImageName: "MyAccessories2",
                clothesName: "MLB 볼캡",
                dateRange: "26.06.01 ~ 26.06.05"
            )
        ),
        ReceivedReviewPreview(
            month: "2026.06",
            review: ReviewData(
                badgeName: "현서",
                title: "둘째 언니 (김현서)",
                content: "상하이 여행 갔을 때 입었는데 애들이 다 정보 물어봄~ 근데 이거 브랜드멜빌꺼냐? 좀 끼네;;",
                mainImageNames: ["ThanksReview_2_1", "ThanksReview_2_2", "ThanksReview_2_3"],
                clothesImageName: "MyTop1",
                clothesName: "브라운 리본 민소매",
                dateRange: "26.06.12 ~ 26.06.18"
            )
        ),
        ReceivedReviewPreview(
            month: "2026.06",
            review: ReviewData(
                badgeName: "서은",
                title: "첫째 언니 (김서은)",
                content: "낼 해방촌 갈 때 써야징~ 어때? 너보다 내가 더 잘 어울리지 않니?",
                mainImageNames: ["ThanksReview_3_1", "ThanksReview_3_2"],
                clothesImageName: "MyAccessories3",
                clothesName: "젤몬 선글라스",
                dateRange: "26.06.20 ~ 26.06.22"
            )
        ),
        ReceivedReviewPreview(
            month: "2026.05",
            review: ReviewData(
                badgeName: "서은",
                title: "첫째 언니 (김서은)",
                content: "스카 왔다가 리뷰 쓰려고 이러고 있다;; 찍다가 소리 나서 사람들이 다 쳐다봄 ㅠㅠ 개쪽팔려",
                mainImageNames: ["ThanksReview_4_1", "ThanksReview_4_2", "ThanksReview_4_3"],
                clothesImageName: "MyTop2",
                clothesName: "캘리포니아 원숄더티",
                dateRange: "26.05.03 ~ 26.05.05"
            )
        ),
        ReceivedReviewPreview(
            month: "2026.04",
            review: ReviewData(
                badgeName: "현서",
                title: "둘째 언니 (김현서)",
                content: "남친이랑 바다 갔을 때 입음 ㅎㅎ 준서 오빠가 핏 이쁘다고 리뷰 사진 같이 찍어줌",
                mainImageNames: ["ThanksReview_5_1", "ThanksReview_5_2"],
                clothesImageName: "MyBottom3",
                clothesName: "데미지 연청 숏팬츠",
                dateRange: "26.04.10 ~ 26.04.15"
            )
        ),
        ReceivedReviewPreview(
            month: "2026.04",
            review: ReviewData(
                badgeName: "서은",
                title: "첫째 언니 (김서은)",
                content: "이거 아이패드 들어가니?? 들어가면 학교 갈 때도 종종 빌려야겟슨",
                mainImageNames: ["ThanksReview_6_1"],
                clothesImageName: "MyAccessories1",
                clothesName: "가죽 미니 백팩",
                dateRange: "26.04.20 ~ 26.04.25"
            )
        )
    ]

    static var monthSections: [ReceivedReviewMonthSection] {
        [
            ReceivedReviewMonthSection(
                month: "2026.06",
                previews: previews.filter { $0.month == "2026.06" }
            ),
            ReceivedReviewMonthSection(
                month: "2026.05",
                previews: previews.filter { $0.month == "2026.05" }
            ),
            ReceivedReviewMonthSection(
                month: "2026.04",
                previews: previews.filter { $0.month == "2026.04" }
            )
        ]
    }
}

struct EachReview01: View {
    @EnvironmentObject private var store: AppDataStore
    @Environment(\.dismiss) var dismiss
    let review: ReviewData
    let onMoveToClothItem: (ClothItem) -> Void
    
    @State private var currentIndex = 0

    private var reviewedClothItem: ClothItem? {
        store.clothItem(imageName: review.clothesImageName)
    }

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color(.gray40))
                .frame(width: 40, height: 4)
                .padding(.top, 14)
                .padding(.bottom, 14)

            // MARK: - 스크롤 가능한 본문 내용
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    productInfoSection

                    VStack(spacing: 12) {
                        TabView(selection: $currentIndex) {
                            ForEach(0..<review.mainImageNames.count, id: \.self) { index in
                                Image(review.mainImageNames[index])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 350)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .frame(height: 350)
                        
                        HStack(spacing: 6) {
                            ForEach(0..<review.mainImageNames.count, id: \.self) { index in
                                if currentIndex == index {
                                    Image("이 곳에 Assest 이미지를 넣어라!!!!!!!!!")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 6, height: 6)
                                        .background(Color.customBlack)
                                        .clipShape(Circle())
                                } else {
                                    Image("이 곳에 Assest 이미지를 넣어라!!!!!!!!!")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 6, height: 6)
                                        .background(Color.gray20)
                                        .clipShape(Circle())
                                }
                            }
                        }
                    }
                    .padding(.bottom, 18)

                    VStack(alignment: .leading, spacing: 12) {
                        Text(review.title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(.brandPrimary))
                        
                        Text(review.content)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.customBlack)
                            .lineSpacing(4)
                    }
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 22)
            }
        }
        .background(Color(.gray5))
        .ignoresSafeArea(edges: .bottom)
    }

    private var productInfoSection: some View {
        Group {
            if let reviewedClothItem {
                Button {
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        onMoveToClothItem(reviewedClothItem)
                    }
                } label: {
                    productInfoCard
                }
                .buttonStyle(.plain)
            } else {
                productInfoCard
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 12)
    }

    private var productInfoCard: some View {
        HStack(spacing: 16) {
            Image(review.clothesImageName)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 13)
                .padding(.vertical, 8)
                .frame(width: 60, height: 60)
                .background(Color(.brandPrimary10))
                .cornerRadius(2.79)

            VStack(alignment: .leading, spacing: 4) {
                Text(review.clothesName)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.customBlack)
                Text(review.dateRange)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray60)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.customWhite)
                .frame(width: 24, height: 24)
                .background(Color(.brandPrimary))
                .clipShape(Circle())
        }
        .padding()
        .background(Color.customWhite)
        .cornerRadius(5)
        .shadow(color: Color.customBlack.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
#Preview {
    EachReview01(review: ReviewData(
        badgeName: "현서",
        title: "둘째 언니 (김현서)",
        content: "상하이 여행 갔을 때 입었는데 애들이 다 정보 물어봄~ 근데 이거 브랜드멜빌꺼냐? 좀 끼네;;",
        mainImageNames: ["Review_New_2", "Review_New_1", "Review_Top3_1"],
        clothesImageName: "여기에 옷 Assets 이름 적어줘!!!",
        clothesName: "브라운 리본 민소매",
        dateRange: "26.06.12 ~ 26.06.18"
    ), onMoveToClothItem: { item in
        print("\(item.name) 상품 화면으로 이동")
    })
    .environmentObject(AppDataStore())
}
