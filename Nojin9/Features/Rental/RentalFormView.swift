import SwiftUI

struct RentalFormView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: AppDataStore

    let clothItemId: UUID

    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var isAgreed = false

    @State private var isShowingReceipt = false

    private var currentItem: ClothItem {
        store.clothItem(id: clothItemId) ?? MockData.clothItems[0]
    }

    private var isDateInvalid: Bool {
        startDate > endDate
    }

    private var rentalDays: Int {
        if isDateInvalid { return 0 }
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: startDate)
        let end = calendar.startOfDay(for: endDate)
        let components = calendar.dateComponents([.day], from: start, to: end)
        return (components.day ?? 0) + 1
    }

    private var totalHeartPrice: Int {
        currentItem.pointCost * rentalDays
    }

    private var currentUserPoint: Int {
        store.currentUser?.point ?? 0
    }

    private var isPointInsufficient: Bool {
        !isDateInvalid && totalHeartPrice > currentUserPoint
    }

    private var canSubmitRental: Bool {
        isAgreed && !isDateInvalid && !isPointInsufficient
    }

    private var ctaTitle: String {
        if isDateInvalid {
            return "기간을 다시 설정해주세요"
        }

        if isPointInsufficient {
            return "포인트가 부족합니다"
        }

        return "\(formatNumber(totalHeartPrice))하트로 빌려오기"
    }

    private func formatDateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: date)
    }

    var body: some View {
        ZStack { // 💡 영수증을 최상단에 전체 오버레이로 덮기 위해 ZStack 감싸기
            VStack(spacing: 0) {

                // MARK: - Navigation Bar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color("customBlack"))
                    }
                    Spacer()
                    Text("빌려오기")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color("customBlack"))
                    Spacer()
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .opacity(0)
                }
                .padding(.horizontal, 20)
                .frame(height: 56)
                .background(Color("customWhite"))

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {

                        // MARK: - Item Info Section
                        VStack(alignment: .leading, spacing: 14) {
                            Text("빌려오는 물품")
                                .subtitleBoldStyle()
                                .foregroundStyle(Color("customBlack"))

                            HStack(spacing: 16) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color("brandPrimary10"))
                                        .frame(width: 120, height: 120)

                                    clothImage(for: currentItem)
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                }

                                VStack(alignment: .leading, spacing: 0) {
                                    Text(itemTitle(for: currentItem))
                                        .bodyBoldStyle()
                                        .foregroundStyle(Color("customBlack"))

                                    Spacer()

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("소유자 : \(ownerDisplayName(for: currentItem))")
                                            .font(.appCaptionBold)
                                            .lineSpacing(18 - 14)
                                            .foregroundStyle(Color("gray40"))

                                        HStack(spacing: 4) {
                                            Image("Coin")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)

                                            Text(formatNumber(currentItem.pointCost))
                                                .subtitleBoldStyle()
                                                .foregroundStyle(Color("customBlack"))
                                        }
                                    }
                                }
                                .frame(height: 120)

                                Spacer()
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                        Rectangle()
                            .fill(Color("gray5"))
                            .frame(height: 8)
                            .padding(.top, 24)

                        // MARK: - Rental Period Section (DatePicker)
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .center, spacing: 0) {
                                Text("빌리는 기간")
                                    .subtitleBoldStyle()
                                    .foregroundStyle(Color("customBlack"))

                                Spacer()

                                HStack(spacing: 4) {
                                    DatePicker("", selection: $startDate, displayedComponents: .date)
                                        .labelsHidden()
                                        .environment(\.locale, Locale(identifier: "ko_KR"))
                                        .frame(width: 110, alignment: .trailing)

                                    Text("~")
                                        .font(.system(size: 15))
                                        .foregroundStyle(Color("customBlack"))
                                        .frame(width: 15, alignment: .center)

                                    DatePicker("", selection: $endDate, displayedComponents: .date)
                                        .labelsHidden()
                                        .environment(\.locale, Locale(identifier: "ko_KR"))
                                        .frame(width: 110, alignment: .trailing)
                                }
                            }
                            .frame(height: 44)

                            if isDateInvalid {
                                HStack(spacing: 4) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .font(.system(size: 13))
                                    Text("종료일이 시작일보다 빠릅니다. 기간을 다시 선택해주세요.")
                                        .font(.system(size: 13, weight: .medium))
                                }
                                .foregroundStyle(.red)
                                .padding(.top, 4)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                        Rectangle()
                            .fill(Color("gray5"))
                            .frame(height: 8)
                            .padding(.top, 24)

                        // MARK: - Payment & Agreement Section
                        VStack(alignment: .leading, spacing: 20) {
                            Text("결제 정보")
                                .subtitleBoldStyle()
                                .foregroundStyle(Color("customBlack"))

                            VStack(spacing: 12) {
                                HStack {
                                    Text("빌려오는 가격 (하루 기준)")
                                        .bodyStyle()
                                        .foregroundStyle(Color("customBlack"))
                                    Spacer()
                                    Text(formatNumber(currentItem.pointCost))
                                        .bodyBoldStyle()
                                }

                                HStack {
                                    Text("빌리는 일수")
                                        .bodyStyle()
                                        .foregroundStyle(Color("customBlack"))
                                    Spacer()
                                    Text("\(rentalDays) 일")
                                        .bodyBoldStyle()
                                        .foregroundStyle(isDateInvalid ? .red : Color("customBlack"))
                                }
                            }

                            Divider()
                                .background(Color("gray10"))

                            HStack {
                                Text("총 빌리기 하트")
                                    .bodyStyle()
                                    .foregroundStyle(Color("customBlack"))
                                Spacer()
                                HStack(spacing: 4) {
                                    Image("Coin")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 22, height: 22)

                                    Text(formatNumber(totalHeartPrice))
                                        .subtitleBoldStyle()
                                        .foregroundStyle(isDateInvalid ? .red : Color("customBlack"))
                                }
                            }

                            Button(action: { isAgreed.toggle() }) {
                                HStack(spacing: 10) {
                                    Image(systemName: isAgreed ? "checkmark.square.fill" : "square")
                                        .font(.system(size: 20))
                                        .foregroundStyle(isAgreed ? Color("brandPrimary") : Color.gray)

                                    Text("위 내용에 전체 동의합니다.")
                                        .buttonStyle()
                                        .foregroundStyle(Color("customBlack"))
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                .frame(height: 50)
                                .background(Color("brandPrimary10"))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }

                // MARK: - Bottom Fixed CTA Button Section
                VStack(spacing: 0) {
                    Divider()
                        .background(Color("gray10"))

                    Button(action: {
                        guard canSubmitRental else { return }

                        guard store.borrow(
                            clothItemId: currentItem.id,
                            borrowedAt: startDate,
                            dueAt: endDate
                        ) else {
                            return
                        }

                        isShowingReceipt = true
                    }) {
                        Text(ctaTitle)
                            .font(.appButton)
                            .foregroundStyle(Color("customWhite"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(canSubmitRental ? Color("brandPrimary") : Color("gray20"))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                    .disabled(!canSubmitRental)
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                }
                .background(Color("customWhite"))
            }

            // --------------------------------------------------
            // MARK: - [연동 오버레이] 대여 성공 영수증 모달 출력
            // --------------------------------------------------
            if isShowingReceipt {
                ReceiptSuccessView(
                    isPresented: $isShowingReceipt,
                    onHomeButtonTapped: {
                        dismiss()
                    },
                    itemImageName: imageName(for: currentItem) ?? "",  // 현재 아이템 이미지 키값
                    rentDate: formatDateToString(startDate),           // 계산된 대여 시작 날짜 문자열
                    returnDate: formatDateToString(endDate),           // 계산된 대여 반납 날짜 문자열
                    rentDays: rentalDays,                              // 연산 프로퍼티의 대여 일수
                    totalPrice: totalHeartPrice,                       // 연산 프로퍼티의 최종 하트 개수
                    borrowerName: store.currentUser?.name ?? "나",      // 대여인
                    ownerName: ownerName(for: currentItem)             // 해당 아이템 소유자 이름
                )
            }
        }
        .navigationBarHidden(true)
    }

    private func formatNumber(_ num: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: num)) ?? "\(num)"
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

    private func itemTitle(for item: ClothItem) -> String {
        let trimmedName = item.name.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedName.isEmpty {
            return trimmedName
        }

        return "\(item.category.displayName) 아이템"
    }

    private func ownerName(for item: ClothItem) -> String {
        store.owner(for: item)?.name ?? "소유자 정보 없음"
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

    private func imageName(for item: ClothItem) -> String? {
        item.imageName ?? item.cutoutImageName
    }
}

// ==========================================
// MARK: - 4. PREVIEW
// ==========================================
#Preview {
    NavigationStack {
        RentalFormView(clothItemId: MockData.returnedRentalClothItemId)
    }
    .environmentObject(AppDataStore())
}
