import SwiftUI

// 🔥 데이터 모델[cite: 18]
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

struct EachReview01: View {
    @Environment(\.dismiss) var dismiss
    let review: ReviewData
    
    @State private var currentIndex = 0
    
    var body: some View {
        // 🌟 화면 가장자리에 딱 붙는 팝업 본체[cite: 18]
        VStack(spacing: 0) {
            
            // 커스텀 드래그 핸들 (회색 막대기)[cite: 18]
            Capsule()
                .fill(Color.gray.opacity(0.4))
                .frame(width: 40, height: 4)
                .padding(.top, 14)
                .padding(.bottom, 14)
            
            // MARK: - 스크롤 가능한 본문 내용
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    // 1. 상단 옷 정보 카드[cite: 18]
                    HStack(spacing: 16) {
                        Image(review.clothesImageName)
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, 13)
                            .padding(.vertical, 8)
                            .frame(width: 60, height: 60)
                            .background(Color(red: 1.0, green: 0.88, blue: 0.92))
                            .cornerRadius(2.79)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(review.clothesName)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                            Text(review.dateRange)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .background(Color(red: 0.97, green: 0.17, blue: 0.54))
                            .clipShape(Circle())
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding(.top, 10)
                    // 🔥 [정확한 상단 패딩] 옷 정보 카드와 메인 사진 사이의 패딩 12 적용[cite: 18]
                    .padding(.bottom, 12)
                    
                    // 2. 메인 편지 사진 및 인디케이터 영역[cite: 18]
                    VStack(spacing: 12) {
                        
                        // 📸 스와이프 캐러셀
                        TabView(selection: $currentIndex) {
                            ForEach(0..<review.mainImageNames.count, id: \.self) { index in
                                Image(review.mainImageNames[index])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity)
                                    // 🔥 사진 높이 350으로 고정[cite: 18]
                                    .frame(height: 350)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        // 🔥 탭뷰 자체의 높이도 350으로 통일하여, 보이지 않던 30픽셀의 잉여 공간을 완벽히 제거했습니다![cite: 18]
                        .frame(height: 350)
                        
                        // 🔴 커스텀 Assets 인디케이터[cite: 18]
                        HStack(spacing: 6) {
                            ForEach(0..<review.mainImageNames.count, id: \.self) { index in
                                if currentIndex == index {
                                    // 🔥 현재 보고 있는 사진 (Active)[cite: 18]
                                    Image("이 곳에 Assest 이미지를 넣어라!!!!!!!!!")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 6, height: 6)
                                        .background(Color.black.opacity(0.8))
                                        .clipShape(Circle())
                                } else {
                                    // 🔥 선택되지 않은 사진 (Inactive)[cite: 18]
                                    Image("이 곳에 Assest 이미지를 넣어라!!!!!!!!!")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 6, height: 6)
                                        .background(Color.gray.opacity(0.4))
                                        .clipShape(Circle())
                                }
                            }
                        }
                    }
                    // 🔥 [정확한 하단 패딩] 사진(인디케이터 포함) 하단과 텍스트 영역 상단 사이의 패딩 18 적용[cite: 18]
                    .padding(.bottom, 18)
                    
                    // 3. 편지 내용[cite: 18]
                    VStack(alignment: .leading, spacing: 12) {
                        Text(review.title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(red: 0.97, green: 0.17, blue: 0.54))
                        
                        Text(review.content)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.black)
                            .lineSpacing(4)
                    }
                    .padding(.bottom, 40)
                }
                // 🔥 사진 및 본문 영역 좌우 패딩 22 유지[cite: 18]
                .padding(.horizontal, 22)
            }
        }
        // 🔥 깔끔한 밝은 단색 배경[cite: 18]
        .background(Color(red: 0.98, green: 0.98, blue: 0.99))
        .ignoresSafeArea(edges: .bottom)
    }
}

// 프리뷰 데이터[cite: 18]
#Preview {
    EachReview01(review: ReviewData(
        badgeName: "현서",
        title: "둘째 언니 (김현서)",
        content: "상하이 여행 갔을 때 입었는데 애들이 다 정보 물어봄~ 근데 이거 브랜드멜빌꺼냐? 좀 끼네;;",
        mainImageNames: ["Review_New_2", "Review_New_1", "Review_Top3_1"],
        clothesImageName: "여기에 옷 Assets 이름 적어줘!!!",
        clothesName: "브라운 리본 민소매",
        dateRange: "26.06.12 ~ 26.06.18"
    ))
}
