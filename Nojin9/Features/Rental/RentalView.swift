//
//  RentalView.swift
//  Nojin9
//
//  Created by 김가은 on 7/19/26.
//

import SwiftUI

struct RentalView: View {
    @EnvironmentObject private var store: AppDataStore

    let clothItemId: UUID
    @State private var isShowingForm = false

    private var item: ClothItem? {
        store.clothItem(id: clothItemId)
    }

    var body: some View {
        ZStack {
            if let item {
                content(for: item)
            } else {
                missingItemView
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .ignoresSafeArea(edges: .top)
        .navigationDestination(isPresented: $isShowingForm) {
            RentalFormView(clothItemId: clothItemId)
                .environmentObject(store)
        }
    }

    private func content(for item: ClothItem) -> some View {
        VStack(spacing: 0) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    visualSection(for: item)
                    metaSection(for: item)

                    Rectangle()
                        .fill(Color("gray5"))
                        .frame(height: 8)
                        .padding(.top, 20)

                    noticeSection(for: item)

                    Rectangle()
                        .fill(Color("gray5"))
                        .frame(height: 8)
                        .padding(.top, 20)

                    thankYouLetterSection(for: item)
                }
                .background(Color("customWhite"))
            }
            .background(Color("customWhite"))

            bottomCTA(for: item)
        }
        .background(Color("customWhite").ignoresSafeArea())
    }

    private func visualSection(for item: ClothItem) -> some View {
        ZStack(alignment: .topLeading) {
            Image("RentalViewBackground")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 420)
                .clipped()

            clothImage(for: item)
                .scaledToFit()
                .frame(height: 340)
                .centerView()
                .padding(.top, 70)

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
    }

    private func metaSection(for item: ClothItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 4) {
                Text(ownerDisplayName(for: item))
                    .font(.system(size: 13))
                Image(systemName: "chevron.right")
                    .font(.system(size: 10))
                Text(item.category.displayName)
                    .font(.system(size: 13))
            }
            .foregroundStyle(Color("gray40"))
            .padding(.top, 20)

            HStack(alignment: .firstTextBaseline, spacing: 12) {
                Text(itemTitle(for: item))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color("customBlack"))

                Text(statusText(for: item))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color("brandPrimary"))
            }
            .padding(.top, 8)

            HStack(spacing: 8) {
                Text("색상")
                    .font(.system(size: 15))
                    .foregroundStyle(Color("customBlack"))

                if let swatchColor = swatchColor(for: item) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(swatchColor)
                        .frame(width: 28, height: 18)
                        .overlay {
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(Color("gray20"), lineWidth: 1)
                        }
                        .accessibilityHidden(true)
                }

                Text(colorText(for: item))
                    .font(.system(size: 15))
                    .foregroundStyle(Color("customBlack"))
            }
            .padding(.top, 10)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("색상 \(colorText(for: item))")

            Divider()
                .background(Color("gray10"))
                .padding(.vertical, 16)

            HStack(spacing: 6) {
                Image("Coin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)

                Text(formatNumber(item.pointCost))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color("customBlack"))
            }

            Text("현재 보유 하트 : \(formatNumber(store.currentUser?.point ?? 0))")
                .font(.system(size: 12))
                .foregroundStyle(Color("gray40"))
                .padding(.top, 6)
        }
        .padding(.horizontal, 20)
    }

    private func noticeSection(for item: ClothItem) -> some View {
        let notices = RentalMockData.notices(for: imageName(for: item))

        return VStack(alignment: .leading, spacing: 14) {
            Text("주의 사항")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color("customBlack"))

            if notices.isEmpty {
                Text("등록된 주의 사항이 없습니다.")
                    .font(.system(size: 14))
                    .foregroundStyle(Color("gray40"))
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color("customWhite"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("brandPrimary10"), lineWidth: 1)
                    }
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(notices, id: \.self) { notice in
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
                .background(Color("customWhite"))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("brandPrimary10"), lineWidth: 1)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    private func thankYouLetterSection(for item: ClothItem) -> some View {
        let letters = RentalMockData.thankYouLetters(for: imageName(for: item))

        return VStack(alignment: .leading, spacing: 16) {
            Text("감사 편지 (\(letters.count))")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color("customBlack"))

            if letters.isEmpty {
                Text("아직 작성된 감사 편지가 없습니다.")
                    .font(.system(size: 14))
                    .foregroundStyle(Color("gray40"))
                    .padding(.vertical, 20)
                    .centerView()
                    .background(Color("customWhite"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("gray10"), lineWidth: 1)
                    }
            } else {
                ForEach(letters) { letter in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 10) {
                            profileImage(for: letter)

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

                        if !letter.images.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(letter.images, id: \.self) { imgName in
                                        ClothImageView(imageName: imgName)
                                            .scaledToFill()
                                            .frame(width: 140, height: 140)
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                    }
                                }
                                .padding(.leading, 20)
                                .padding(.trailing, 20)
                            }
                            .padding(.horizontal, -20)
                        }
                    }
                    .padding(16)
                    .background(Color("customWhite"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("gray10"), lineWidth: 1)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 40)
    }

    @ViewBuilder
    private func bottomCTA(for item: ClothItem) -> some View {
        switch ctaState(for: item) {
        case .hidden:
            EmptyView()
        case .enabled(let title):
            ctaContainer {
                Button(action: {
                    isShowingForm = true
                }) {
                    ctaLabel(title: title, backgroundColor: Color("brandPrimary"))
                }
            }
        case .disabled(let title):
            ctaContainer {
                Button(action: {}) {
                    ctaLabel(title: title, backgroundColor: Color("gray40"))
                }
                .disabled(true)
            }
        }
    }

    private func ctaContainer<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color("gray10"))

            content()
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 24)
        }
        .background(Color("customWhite"))
    }

    private func ctaLabel(title: String, backgroundColor: Color) -> some View {
        Text(title)
            .font(.system(size: 16, weight: .bold))
            .foregroundStyle(Color("customWhite"))
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var missingItemView: some View {
        VStack(spacing: 12) {
            Spacer()
            Text("옷 정보를 찾을 수 없습니다.")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color("customBlack"))
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("customWhite"))
    }

    @ViewBuilder
    private func clothImage(for item: ClothItem) -> some View {
        if let imageName = imageName(for: item) {
            ClothImageView(imageName: imageName)
        } else {
            Image(systemName: "tshirt")
                .resizable()
                .foregroundStyle(.gray60)
        }
    }

    @ViewBuilder
    private func profileImage(for letter: ClosetThankYouLetter) -> some View {
        if letter.author == "나" {
            Image("MyProfile")
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
        } else if letter.author.contains("둘째 언니") || letter.author.contains("둘째언니") {
            Image("2ndSisProfile")
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

    private func ctaState(for item: ClothItem) -> RentalCTAState {
        let currentUserId = store.snapshot.userSession.currentUserId
        let borrower = store.borrower(for: item)

        if item.ownerId == currentUserId {
            guard let borrower else {
                return .hidden
            }

            return .disabled("\(borrower.name)이 대여 중")
        }

        guard let borrower else {
            return .enabled("빌려오기")
        }

        if borrower.id == currentUserId {
            return .disabled("내가 대여 중")
        }

        return .disabled("\(borrower.name)이 대여 중")
    }

    private func statusText(for item: ClothItem) -> String {
        let currentUserId = store.snapshot.userSession.currentUserId
        if item.ownerId == currentUserId {
            return item.isBorrowed ? "대여 중" : "내 옷"
        }

        return item.isBorrowed ? "대여 중" : "빌려오기 가능"
    }

    private func ownerDisplayName(for item: ClothItem) -> String {
        guard let owner = store.owner(for: item) else {
            return "소유자 정보 없음"
        }

        if owner.id == store.snapshot.userSession.currentUserId {
            return "나"
        }

        if let relationshipLabel = owner.relationshipLabel, !relationshipLabel.isEmpty {
            return "\(relationshipLabel) 언니"
        }

        return owner.name
    }

    private func itemTitle(for item: ClothItem) -> String {
        let trimmedName = item.name.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedName.isEmpty {
            return trimmedName
        }

        return "\(item.category.displayName) 아이템"
    }

    private func imageName(for item: ClothItem) -> String? {
        item.imageName ?? item.cutoutImageName
    }

    private func swatchColor(for item: ClothItem) -> Color? {
        guard let keyColorHex = item.keyColorHex, !keyColorHex.isEmpty else {
            return nil
        }

        return Color(hex: keyColorHex)
    }

    private func colorText(for item: ClothItem) -> String {
        if let keyColorName = item.keyColorName, !keyColorName.isEmpty {
            return keyColorName
        }

        let colors = ["아이보리", "스카이블루", "크림", "블랙", "연회색", "진회색", "카키색", "검정색", "연갈색", "고동색", "스페이스 그레이"]
        let title = itemTitle(for: item)

        for color in colors where title.contains(color) {
            return color
        }

        return "기본색"
    }

    private func formatNumber(_ num: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: num)) ?? "\(num)"
    }
}

private enum RentalCTAState {
    case hidden
    case enabled(String)
    case disabled(String)
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

private extension Color {
    init?(hex: String) {
        let sanitizedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        guard sanitizedHex.count == 6,
              let int = UInt64(sanitizedHex, radix: 16) else {
            return nil
        }

        let red = Double((int >> 16) & 0xFF) / 255
        let green = Double((int >> 8) & 0xFF) / 255
        let blue = Double(int & 0xFF) / 255

        self.init(red: red, green: green, blue: blue)
    }
}

#Preview {
    RentalView(clothItemId: MockData.returnedRentalClothItemId)
        .environmentObject(AppDataStore())
}
