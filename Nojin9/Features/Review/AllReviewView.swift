import SwiftUI

struct AllReviewView: View {
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    @State private var selectedReview: ReviewData? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Navigation Bar[cite: 17]
            HStack {
                BackButton {
                    // 뒤로가기 액션
                }
                Spacer()
                Text("감사 편지").bodyBoldStyle()
                Spacer()
                Color.clear.frame(width: 36, height: 36)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 10)
            
            ZStack(alignment: .bottom) {
                // MARK: - Scroll Content[cite: 17]
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        
                        // --- 2026.06 Section ---
                        VStack(alignment: .leading, spacing: 16) {
                            Text("2026.06").subtitleBoldStyle().padding(.horizontal, 16)
                            
                            LazyVGrid(columns: columns, spacing: 37.82) {
                                Button(action: {
                                    selectedReview = ReviewData(
                                        badgeName: "서은", title: "첫째 언니 (김서은)",
                                        content: "서연아 바지 너무 편하고 예쁘더라! 덕분에 친구들이랑 잘 놀다 왔어~ 고마워!",
                                        mainImageNames: ["Review_New_1", "Review_Bottom3_1"],
                                        clothesImageName: "여기에 옷 Assets 이름 적어줘!!!",
                                        clothesName: "와이드 데님 팬츠", dateRange: "26.06.01 ~ 26.06.05"
                                    )
                                }) { EnvelopeCardView(name: "서은", imageName: "Review_New_1") }
                                
                                Button(action: {
                                    selectedReview = ReviewData(
                                        badgeName: "서은", title: "첫째 언니 (김서은)",
                                        content: "이번에 빌려준 니트도 찰떡이었어! 다음에도 부탁해 ㅎㅎ",
                                        mainImageNames: ["Review_Bottom3_1"],
                                        clothesImageName: "Top1",
                                        clothesName: "라운드넥 니트", dateRange: "26.06.07 ~ 26.06.09"
                                    )
                                }) { EnvelopeCardView(name: "서은", imageName: "Review_Bottom3_1") }
                                
                                Button(action: {
                                    selectedReview = ReviewData(
                                        badgeName: "현서", title: "둘째 언니 (김현서)",
                                        content: "상하이 여행 갔을 때 입었는데 애들이 다 정보 물어봄~ 근데 이거 브랜드멜빌꺼냐? 좀 끼네;;",
                                        mainImageNames: ["Review_New_2", "Review_Top3_1", "Review_New_3"],
                                        clothesImageName: "여기에 옷 Assets 이름 적어줘!!!",
                                        clothesName: "브라운 리본 민소매", dateRange: "26.06.12 ~ 26.06.18"
                                    )
                                }) { EnvelopeCardView(name: "현서", imageName: "Review_New_2") }
                                
                                Button(action: {
                                    selectedReview = ReviewData(
                                        badgeName: "현서", title: "둘째 언니 (김현서)",
                                        content: "자켓 핏 너무 예뻐!! 사진 백만 장 찍었당 ㅎㅎ",
                                        mainImageNames: ["Review_Top3_1"],
                                        clothesImageName: "Top3",
                                        clothesName: "오버핏 자켓", dateRange: "26.06.20 ~ 26.06.22"
                                    )
                                }) { EnvelopeCardView(name: "현서", imageName: "Review_Top3_1") }
                            }
                            .padding(.horizontal, 25)
                        }
                        
                        // --- 2026.05 Section ---
                        VStack(alignment: .leading, spacing: 16) {
                            Text("2026.05").subtitleBoldStyle().padding(.horizontal, 16)
                            
                            LazyVGrid(columns: columns, spacing: 37.82) {
                                Button(action: {
                                    selectedReview = ReviewData(
                                        badgeName: "현서", title: "둘째 언니 (김현서)",
                                        content: "이때 입었던 핑크 가디건 어디서 샀어? 나도 하나 사야겠어 ㅠㅠ 너무 맘에 듦!",
                                        mainImageNames: ["Review_New_3"],
                                        clothesImageName: "여기에 옷 Assets 이름 적어줘!!!",
                                        clothesName: "크롭 가디건", dateRange: "26.05.03 ~ 26.05.05"
                                    )
                                }) { EnvelopeCardView(name: "현서", imageName: "Review_New_3") }
                                
                                Color.clear
                            }
                            .padding(.horizontal, 25)
                        }
                    }
                    .padding(.vertical, 20)
                    .padding(.bottom, 100)
                }
                
                // MARK: - Floating Button[cite: 17]
                PrimaryButton(title: "감사 편지 작성하기") {
                    // 작성하기 액션
                }
                .padding(.bottom, 10)
                
                // MARK: - White Blur Effect[cite: 17]
                Rectangle()
                    .fill(Color.white.opacity(0.4))
                    .background(.regularMaterial)
                    .frame(height: 34)
                    .offset(y: 34)
            }
        }
        .background(
            Image("Background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
        )
        // 🔥 팝업 설정 영역
        .sheet(item: $selectedReview) { reviewData in
            EachReview01(review: reviewData)
                // 상단 패딩 154 고정
                .presentationDetents([.height(UIScreen.main.bounds.height - 154)])
                // 커스텀 핸들을 사용하기 위해 기본 핸들은 숨김
                .presentationDragIndicator(.hidden)
        }
    }
}

// MARK: - 봉투 카드 컴포넌트[cite: 17]
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

#Preview {
    AllReviewView()
}
