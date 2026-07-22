//
//  ReceiptSuccessView.swift
//  Nojin9
//
//  Created by Kimseoyeon on 7/20/26.
//
import SwiftUI

// ===================================================
// MARK: - View: 영수증 완료 화면 (ReceiptSuccessView)
// ===================================================
struct ReceiptSuccessView: View {
    
    // MARK: - [Properties] 상태 및 바인딩 변수
    @Binding var isPresented: Bool
    var onHomeButtonTapped: () -> Void
    
    let itemImageName: String
    let rentDate: String
    let returnDate: String
    let rentDays: Int
    let totalPrice: Int
    let borrowerName: String
    let ownerName: String
    
    // MARK: - [Animation States] 애니메이션 및 인터랙션 제어
    @State private var animateReceipt: Bool = false
    @State private var showCompleteOverlay: Bool = false
    @State private var stickerScale: CGFloat = 0.5

    // MARK: - [Main Body] 뷰 레이아웃 심장부
    var body: some View {
        ZStack(alignment: .bottom) {
            
            // -----------------------------------------------
            // MARK: 1. 배경 딤(Dim) 레이어
            // -----------------------------------------------
            if isPresented {
                Color.customBlack.opacity(showCompleteOverlay ? 0.8 : 0.6)
                    .ignoresSafeArea()
            }
            
            // -----------------------------------------------
            // MARK: 2. 영수증 본체 및 실시간 텍스트 매핑 레이어 (기존 배치 유지)
            // -----------------------------------------------
            if isPresented {
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        
                        Image("Receipt")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                        
                        VStack(spacing: 0) {
                            
                            ClothImageView(imageName: itemImageName)
                                .scaledToFit()
                                .frame(height: 280)
                                .padding(.top, 10)
                            
                            Spacer().frame(height: 145)
                            
                            VStack(spacing: 6) {
                                receiptRow(title: "빌려온 일자", value: rentDate)
                                receiptRow(title: "돌려줄 일자", value: returnDate)
                                receiptRow(title: "빌리는 일수", value: "\(rentDays)일")
                                
                                HStack {
                                    Text("총 빌리기 하트")
                                        .font(.system(size: 13, weight: .bold))
                                    Spacer()
                                    Text(formatNumber(totalPrice))
                                        .font(.system(size: 16, weight: .bold))
                                }
                                .padding(.top, 4)
                            }
                            .padding(.horizontal, 60)
                            
                            Spacer().frame(height: 50)
                            
                            VStack(spacing: 6) {
                                receiptRow(title: "빌리는 분", value: borrowerName)
                                receiptRow(title: "빌려주는 분", value: ownerName)
                            }
                            .padding(.horizontal, 60)
                        }
                        .foregroundStyle(Color.customBlack.opacity(0.8))
                        .offset(y: 40) // 기존 오프셋 완벽히 유지
                    }
                }
                .background(Color.customWhite.opacity(0.01))
                .offset(y: animateReceipt ? 0 : UIScreen.main.bounds.height)
                .onTapGesture {
                    if !showCompleteOverlay {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showCompleteOverlay = true
                        }
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                            stickerScale = 1.0
                        }
                    }
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        animateReceipt = true
                    }
                }
            }
            
            // -----------------------------------------------
            // MARK: 3. 최종 완료 스티커 및 홈 이동 버튼 오버레이
            // -----------------------------------------------
            if showCompleteOverlay {
                VStack(spacing: 0) {
                    Spacer()
                    
                    Image("ShareCompleteSticker")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280, height: 280)
                        .scaleEffect(stickerScale)
                    
                    Spacer()
                    
                    PrimaryButton(title: "홈으로 이동하기") {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            animateReceipt = false
                            showCompleteOverlay = false
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isPresented = false
                            onHomeButtonTapped()
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 34)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.customBlack.opacity(0.4))
                .ignoresSafeArea()
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    // ===================================================
    // MARK: - Helper Methods & Subviews (지원 함수)
    // ===================================================
    @ViewBuilder
    private func receiptRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.gray60.opacity(0.9))
            Spacer()
            Text(value)
                .font(.system(size: 12, weight: .semibold))
        }
    }
    
    private func formatNumber(_ num: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: num)) ?? "\(num)"
    }
}

// ===================================================
// MARK: - Canvas Preview (미리보기)
// ===================================================
#Preview {
    // 프리뷰 환경에서 더미 데이터를 주입하여 정상적으로 렌더링되도록 설정합니다.
    ReceiptSuccessView(
        isPresented: .constant(true),
        onHomeButtonTapped: {
            print("프리뷰: 홈으로 이동하기 버튼이 클릭되었습니다.")
        },
        itemImageName: "Top2",             // 시안에 맞춰 렌더링할 더미 이미지 명
        rentDate: "2026년 7월 15일",
        returnDate: "2026년 7월 19일",
        rentDays: 5,
        totalPrice: 12500,
        borrowerName: "김서연",
        ownerName: "김서은"
    )
}
