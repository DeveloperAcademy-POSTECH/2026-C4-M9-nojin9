import SwiftUI

struct AllReviewView: View {
    let onMoveToWriteReview: () -> Void
    let onMoveToHome: () -> Void

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    @State private var selectedReview: ReviewData? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Navigation Bar[cite: 19]
            HStack {
                BackButton {
                    onMoveToHome()
                }
                Spacer()
                Text("감사 편지").bodyBoldStyle()
                Spacer()
                Color.clear.frame(width: 36, height: 36)
            }
            .padding(.horizontal, 16)
            .padding(.top, 0)
            .padding(.bottom, 18)
            
            ZStack(alignment: .bottom) {
                // MARK: - Scroll Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        
                        VStack(alignment: .leading, spacing: 18) {
                            Text("2026.06").subtitleBoldStyle().padding(.horizontal, 16)
                            
                            LazyVGrid(columns: columns, spacing: 37.82) {
                                
                                Button(action: {
                                    selectedReview = ReviewData(
                                        badgeName: "서은", title: "첫째 언니 (김서은)",
                                        content: "언니 머리 안 감고 쓴거 아니다;; 머리 붕 떠서 쓴거임",
                                        mainImageNames: ["ThanksReview_1_1"],
                                        clothesImageName: "MyAccessories2",
                                        clothesName: "MLB 볼캡", dateRange: "26.06.01 ~ 26.06.05"
                                    )
                                }) { EnvelopeCardView(name: "서은", imageName: "ThanksReview_1_1") }
                                
                                
                                Button(action: {
                                    selectedReview = ReviewData(
                                        badgeName: "현서", title: "둘째 언니 (김현서)",
                                        content: "상하이 여행 갔을 때 입었는데 애들이 다 정보 물어봄~ 근데 이거 브랜드멜빌꺼냐? 좀 끼네;;",
                                        mainImageNames: ["ThanksReview_2_1","ThanksReview_2_2","ThanksReview_2_3"],
                                        clothesImageName: "MyTop1",
                                        clothesName: "브라운 리본 민소매", dateRange: "26.06.12 ~ 26.06.18"
                                    )
                                }) { EnvelopeCardView(name: "현서", imageName: "ThanksReview_2_1") }
                                
                                
                                Button(action: {
                                    selectedReview = ReviewData(
                                        badgeName: "서은", title: "첫째 언니 (김서은)",
                                        content: "낼 해방촌 갈 때 써야징~ 어때? 너보다 내가 더 잘 어울리지 않니?",
                                        mainImageNames: ["ThanksReview_3_1","ThanksReview_3_2"],
                                        clothesImageName: "MyAccessories3",
                                        clothesName: "젤몬 선글라스", dateRange: "26.06.20 ~ 26.06.22"
                                    )
                                }) { EnvelopeCardView(name: "서은", imageName: "ThanksReview_3_1") }
                                
                                Color.clear
                            }
                            .padding(.horizontal, 26)
                        }
                        
                        VStack(alignment: .leading, spacing: 18) {
                            Text("2026.05").subtitleBoldStyle().padding(.horizontal, 16)
                            
                            LazyVGrid(columns: columns, spacing: 37.82) {
                                Button(action: {
                                    selectedReview = ReviewData(
                                        badgeName: "서은", title: "첫째 언니 (김서은)",
                                        content: "스카 왔다가 리뷰 쓰려고 이러고 있다;; 찍다가 소리 나서 사람들이 다 쳐다봄 ㅠㅠ 개쪽팔려",
                                        mainImageNames: ["ThanksReview_4_1","ThanksReview_4_2","ThanksReview_4_3"],
                                        clothesImageName: "MyTop2",
                                        clothesName: "캘리포니아 원숄더티", dateRange: "26.05.03 ~ 26.05.05"
                                    )
                                }) { EnvelopeCardView(name: "서은", imageName: "ThanksReview_4_1") }
                                Color.clear
                            }
                            .padding(.horizontal, 26)
                        }

                        VStack(alignment: .leading, spacing: 18) {
                            Text("2026.04").subtitleBoldStyle().padding(.horizontal, 16)
                            
                            LazyVGrid(columns: columns, spacing: 37.82) {
                                Button(action: {
                                    selectedReview = ReviewData(
                                        badgeName: "현서", title: "둘째 언니 (김현서)",
                                        content: "남친이랑 바다 갔을 때 입음 ㅎㅎ 준서 오빠가 핏 이쁘다고 리뷰 사진 같이 찍어줌",
                                        mainImageNames: ["ThanksReview_5_1","ThanksReview_5_2"],
                                        clothesImageName: "MyBottom3",
                                        clothesName: "데미지 연청 숏팬츠", dateRange: "26.04.10 ~ 26.04.15"
                                    )
                                }) { EnvelopeCardView(name: "현서", imageName: "ThanksReview_5_1") }
                                
                                Button(action: {
                                    selectedReview = ReviewData(
                                        badgeName: "서은", title: "첫째 언니 (김서은)",
                                        content: "이거 아이패드 들어가니?? 들어가면 학교 갈 때도 종종 빌려야겟슨",
                                        mainImageNames: ["ThanksReview_6_1"],
                                        clothesImageName: "MyAccessories1",
                                        clothesName: "가죽 미니 백팩", dateRange: "26.04.20 ~ 26.04.25"
                                    )
                                }) { EnvelopeCardView(name: "서은", imageName: "ThanksReview_6_1") }
                            }
                            .padding(.horizontal, 25)
                        }
                    }
                    .padding(.vertical, 20)
                    .padding(.bottom, 100)
                }
                
                // MARK: - Floating Button[cite: 19]
                PrimaryButton(title: "감사 편지 작성하기") {
                    onMoveToWriteReview()
                }
                .padding(.bottom, 10)
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(
            Image("Background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
        )
        .navigationTitle("감사 편지")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .sheet(item: $selectedReview) { reviewData in
            EachReview01(review: reviewData)
                .presentationDetents([.height(UIScreen.main.bounds.height - 154)])
                .presentationDragIndicator(.hidden)
        }
    }
}

// MARK: - 봉투 카드 컴포넌트[cite: 19]
struct EnvelopeCardView: View {
    let name: String
    let imageName: String
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("NoteBody").resizable().scaledToFit()
            Image(imageName)
                .resizable().aspectRatio(contentMode: .fill)
                .frame(width: 130, height: 130).clipped()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.bottom, 41.18)
            Image("NoteFlap").resizable().scaledToFit()
        }
        .overlay(
            Text(name)
                .font(.appCaptionBold).foregroundStyle(Color(.customWhite))
                .frame(width: 39, height: 39)
                .background(Circle().fill(.gray40))
                .overlay(Circle().stroke(Color(.customWhite), lineWidth: 1))
                .padding(.top, 6).padding(.leading, 24),
            alignment: .topLeading
        )
    }
}

#Preview { AllReviewView( onMoveToWriteReview: { print("감사 편지 작성 화면으로 이동") }, onMoveToHome: { print("홈으로 이동") } ) }
