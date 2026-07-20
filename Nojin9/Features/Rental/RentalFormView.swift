import SwiftUI

struct RentalFormView: View {
    @Environment(\.dismiss) private var dismiss
    
    let itemID: String
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var isAgreed = false
    
    @State private var isShowingReceipt = false
    
    private var currentItem: ClosetRentalItemDetail {
        RentalMockData.items[itemID] ?? RentalMockData.items["Top1"]!
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
        currentItem.price * rentalDays
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
                                    
                                    Image(currentItem.id)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                }
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(currentItem.title)
                                        .bodyBoldStyle()
                                        .foregroundStyle(Color("customBlack"))
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("소유자 : \(currentItem.owner)")
                                            .font(.appCaptionBold)
                                            .lineSpacing(18 - 14)
                                            .foregroundStyle(Color("gray40"))
                                        
                                        HStack(spacing: 4) {
                                            Image("Coin")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                            
                                            Text(formatNumber(currentItem.price))
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
                                    Text(formatNumber(currentItem.price))
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
                        isShowingReceipt = true
                    }) {
                        Text(isDateInvalid ? "기간을 다시 설정해주세요" : "\(formatNumber(totalHeartPrice))하트로 빌려오기")
                            .font(.appButton)
                            .foregroundStyle(Color("customWhite"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(isAgreed && !isDateInvalid ? Color("brandPrimary") : Color("gray20"))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                .disabled(!isAgreed || isDateInvalid)
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
                        // 예: 메인 탭바 스위칭 로직 변수 주입 등
                        print("부모 뷰: 옷장 화면(ClosetView)으로 전환 신호를 받았습니다.")
                    },
                    itemImageName: currentItem.id,                     // "Top1", "Top2" 등의 아이템 에셋 키값
                    rentDate: formatDateToString(startDate),           // 계산된 대여 시작 날짜 문자열
                    returnDate: formatDateToString(endDate),           // 계산된 대여 반납 날짜 문자열
                    rentDays: rentalDays,                              // 연산 프로퍼티의 대여 일수
                    totalPrice: totalHeartPrice,                       // 연산 프로퍼티의 최종 하트 개수
                    borrowerName: "김서연",                             // 대여인 (현재 유저 이름 고정 혹은 세션 데이터 연동)
                    ownerName: currentItem.owner                       // 해당 아이템 소유자 이름 연동
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
}

// ==========================================
// MARK: - 4. PREVIEW
// ==========================================
#Preview {
    // 네비게이션 바 레이아웃이나 뒤로가기 동작이 정상적으로 깨지지 않도록
    // NavigationStack으로 감싸서 프리뷰를 렌더링합니다.
    NavigationStack {
        RentalFormView(itemID: "Top2")
    }
}
