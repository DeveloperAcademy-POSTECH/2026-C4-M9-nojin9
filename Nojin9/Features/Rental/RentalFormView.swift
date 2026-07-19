//
//  RentalFormView.swift
//  Nojin9
//
//  Created by Kimseoyeon on 7/19/26.
//

import SwiftUI

// ==========================================
// MARK: - 1. PROPERTIES & LOGIC
// ==========================================

struct RentalFormView: View {
    @Environment(\.dismiss) private var dismiss
    
    let itemID: String
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var isAgreed = false
    
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
    
    // ==========================================
    // MARK: - 2. RENDER BODY
    // ==========================================
    var body: some View {
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
                    print("총 \(totalHeartPrice)하트로 대여 완료")
                }) {
                    Text(isDateInvalid ? "기간을 다시 설정해주세요" : "\(formatNumber(totalHeartPrice))하트로 빌려오기")
                        .font(.appButton)
                        .foregroundStyle(Color("customWhite"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56) // 👈 디자인 시스템 버튼 높이 스펙 56 고정
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
        .navigationBarHidden(true)
    }
    
    // ==========================================
    // MARK: - 3. HELPER METHODS
    // ==========================================
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
    RentalFormView(itemID: "Top2")
}
