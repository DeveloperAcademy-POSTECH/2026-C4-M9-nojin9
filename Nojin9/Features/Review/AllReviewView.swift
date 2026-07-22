import SwiftUI

struct AllReviewView: View {
    let onMoveToWriteReview: () -> Void
    let onMoveToClothItem: (ClothItem) -> Void

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    @State private var selectedReview: ReviewData? = nil
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // MARK: - Scroll Content
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    ForEach(ReceivedReviewSeed.monthSections) { section in
                        VStack(alignment: .leading, spacing: 18) {
                            Text(section.month).subtitleBoldStyle().padding(.horizontal, 16)

                            LazyVGrid(columns: columns, spacing: 37.82) {
                                ForEach(section.previews) { preview in
                                    Button {
                                        selectedReview = preview.review
                                    } label: {
                                        EnvelopeCardView(
                                            name: preview.authorName,
                                            imageName: preview.imageName
                                        )
                                    }
                                }

                                if section.previews.count % 2 == 1 {
                                    Color.clear
                                }
                            }
                            .padding(.horizontal, 26)
                        }
                    }
                }
                .padding(.vertical, 20)
                .padding(.bottom, 100)
            }

            // MARK: - Floating Button
            PrimaryButton(title: "감사 편지 작성하기") {
                onMoveToWriteReview()
            }
            .padding(.bottom, 10)
        }
        .background(
            Image("Background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
        )
        .toolbarBackground(.hidden, for: .navigationBar)
        .sheet(item: $selectedReview) { reviewData in
            EachReview01(
                review: reviewData,
                onMoveToClothItem: onMoveToClothItem
            )
                .presentationDetents([.height(UIScreen.main.bounds.height - 154)])
                .presentationDragIndicator(.hidden)
        }
    }
}

// MARK: - 봉투 카드 컴포넌트
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
    AllReviewView(
        onMoveToWriteReview: { print("감사 편지 작성 화면으로 이동") },
        onMoveToClothItem: { item in print("\(item.name) 상품 화면으로 이동") }
    )
}
