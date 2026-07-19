//
//  RentalView.swift
//  Nojin9
//
//  Created by 김가은 on 7/19/26.
//

import SwiftUI
import UIKit

struct RentalView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: AppDataStore

    let clothItemId: UUID

    init(clothItemId: UUID) {
        self.clothItemId = clothItemId
    }

    init(itemID: String) {
        let item = MockData.clothItems.first {
            $0.imageName == itemID || $0.name == itemID
        }
        self.clothItemId = item?.id ?? MockData.secondTopOneId
    }

    private var clothItem: ClothItem {
        store.clothItem(id: clothItemId) ?? MockData.clothItems[0]
    }

    private var detailSupplement: RentalItemDetailSupplement {
        RentalDetailMockData.supplement(for: clothItem)
    }

    private var itemImageName: String {
        clothItem.imageName ?? clothItem.name
    }

    private var ownerDisplayName: String {
        guard let owner = store.owner(for: clothItem) else { return "언니" }
        return sisterDisplayName(for: owner)
    }

    private var userHearts: Int {
        store.currentUser?.point ?? 0
    }

    private var isAvailable: Bool {
        !clothItem.isBorrowed
    }

    private var thankYouLetters: [RentalThankYouLetterDisplay] {
        let letters = store.thankYouLetters(for: clothItem.id)
        let reviewSamples = store.reviewSamples(for: clothItem.id)
        let reviewImages = reviewSamples.map(\.imageName)

        if letters.isEmpty {
            return reviewSamples.map { review in
                RentalThankYouLetterDisplay(
                    id: review.id,
                    author: "나",
                    profileImageName: store.currentUser?.profileImageName,
                    date: formatDate(review.createdAt),
                    content: review.message,
                    images: [review.imageName]
                )
            }
        }

        return letters.map { letter in
            let rental = store.rentals(for: clothItem.id).first { $0.id == letter.rentalId }
            let author = rental.flatMap { store.user(id: $0.borrowerId) }
            let isCurrentUser = author?.id == store.snapshot.userSession.currentUserId
            let authorName = isCurrentUser ? "나" : author.map { sisterDisplayName(for: $0) } ?? "언니"
            let matchingReviewImages = reviewSamples
                .filter { $0.message == letter.message && Calendar.current.isDate($0.createdAt, inSameDayAs: letter.createdAt) }
                .map(\.imageName)

            return RentalThankYouLetterDisplay(
                id: letter.id,
                author: authorName,
                profileImageName: author?.profileImageName,
                date: formatDate(letter.createdAt),
                content: letter.message,
                images: matchingReviewImages.isEmpty ? reviewImages : matchingReviewImages
            )
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    ZStack(alignment: .topLeading) {
                        Image("RentalViewBackground")
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 420)
                            .clipped()

                        Image(itemImageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 340)
                            .centerView()
                            .padding(.top, 70)

                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color("customBlack"))
                                .frame(width: 44, height: 44)
                                .background(Color("customWhite"))
                                .clipShape(Circle())
                                .shadow(color: Color("customBlack").opacity(0.1), radius: 4, x: 0, y: 2)
                        }
                        .padding(.leading, 20)
                        .padding(.top, 60)

                        Text("1/1")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(Color("customWhite"))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color("customBlack").opacity(0.4))
                            .clipShape(Capsule())
                            .padding(.trailing, 20)
                            .padding(.top, 380)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }

                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 4) {
                            Text(ownerDisplayName)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 10))
                            Text(clothItem.category.displayName)
                        }
                        .font(.system(size: 13))
                        .foregroundStyle(Color("gray40"))
                        .padding(.top, 20)

                        HStack(alignment: .firstTextBaseline, spacing: 12) {
                            Text(clothItem.name)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(Color("customBlack"))

                            Text(isAvailable ? "빌려오기 가능" : "대여 중")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(Color("brandPrimary"))
                        }
                        .padding(.top, 8)

                        Text("색상  \(detailSupplement.color)")
                            .font(.system(size: 15))
                            .foregroundStyle(Color("customBlack"))
                            .padding(.top, 10)

                        Divider()
                            .background(Color("gray10"))
                            .padding(.vertical, 16)

                        HStack(spacing: 6) {
                            Image("Coin")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)

                            Text(formatNumber(clothItem.pointCost))
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(Color("customBlack"))
                        }

                        Text("현재 보유 하트 : \(formatNumber(userHearts))")
                            .font(.system(size: 12))
                            .foregroundStyle(Color("gray40"))
                            .padding(.top, 6)
                    }
                    .padding(.horizontal, 20)

                    Rectangle()
                        .fill(Color("gray5"))
                        .frame(height: 8)
                        .padding(.top, 20)

                    VStack(alignment: .leading, spacing: 14) {
                        Text("주의 사항")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(Color("customBlack"))

                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(detailSupplement.notices, id: \.self) { notice in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundStyle(Color("brandPrimary"))
                                        .padding(.top, 3)

                                    Text(notice)
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color("gray80"))
                                        .lineSpacing(4)
                                }
                            }
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color("brandPrimary10").opacity(0.4))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                    Rectangle()
                        .fill(Color("gray5"))
                        .frame(height: 8)
                        .padding(.top, 20)

                    VStack(alignment: .leading, spacing: 16) {
                        Text("감사 편지 (\(thankYouLetters.count))")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(Color("customBlack"))

                        if thankYouLetters.isEmpty {
                            Text("아직 작성된 감사 편지가 없습니다.")
                                .font(.system(size: 14))
                                .foregroundStyle(Color("gray40"))
                                .padding(.vertical, 20)
                                .centerView()
                        } else {
                            ForEach(thankYouLetters) { letter in
                                letterView(letter)
                                    .padding(.bottom, 24)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }

            VStack(spacing: 0) {
                Divider()
                    .background(Color("gray10"))

                Button(action: {
                    store.borrow(clothItemId: clothItem.id)
                }) {
                    Text("빌려오기")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color("customWhite"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(isAvailable ? Color("brandPrimary") : Color("gray40"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .disabled(!isAvailable)
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
            .background(Color("customWhite"))
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarHidden(true)
    }

    private func letterView(_ letter: RentalThankYouLetterDisplay) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                profileImage(name: letter.profileImageName)

                VStack(alignment: .leading, spacing: 2) {
                    Text(letter.author)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color("customBlack"))
                    Text(letter.date)
                        .font(.system(size: 12))
                        .foregroundStyle(Color("gray40"))
                }
            }

            Text(letter.content)
                .font(.system(size: 14))
                .foregroundStyle(Color("customBlack"))
                .lineSpacing(4)
                .padding(.vertical, 2)

            if !availableImages(for: letter).isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(availableImages(for: letter), id: \.self) { imageName in
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 140, height: 140)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                }
            }
        }
    }

    private func availableImages(for letter: RentalThankYouLetterDisplay) -> [String] {
        letter.images.filter { UIImage(named: $0) != nil }
    }

    @ViewBuilder
    private func profileImage(name: String?) -> some View {
        if let name, UIImage(named: name) != nil {
            Image(name)
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
        } else {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .foregroundStyle(Color("gray40"))
        }
    }

    private func sisterDisplayName(for user: User) -> String {
        guard let relationshipLabel = user.relationshipLabel else {
            return user.name
        }

        if relationshipLabel.contains("언니") {
            return relationshipLabel
        }

        return "\(relationshipLabel) 언니"
    }

    private func formatNumber(_ num: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: num)) ?? "\(num)"
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: date)
    }
}

private extension View {
    func centerView() -> some View {
        HStack {
            Spacer()
            self
            Spacer()
        }
    }
}

#Preview {
    RentalView(clothItemId: MockData.secondTopTwoId)
        .environmentObject(AppDataStore())
}
