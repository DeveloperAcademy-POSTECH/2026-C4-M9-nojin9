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

struct EachReview01: View {
    @Environment(\.dismiss) var dismiss
    let review: ReviewData
    
    @State private var currentIndex = 0
    
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
                    .padding(.top, 10)
                    .padding(.bottom, 12)
                    
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
    ))
}
