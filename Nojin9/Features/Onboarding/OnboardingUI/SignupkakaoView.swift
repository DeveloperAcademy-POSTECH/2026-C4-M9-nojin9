//
//  SignupkakaoView.swift
//  Nojin9
//
//  Created by RyuHwagodong on 7/17/26.
//

import SwiftUI

struct SignupkakaoView: View {
    @Environment(\.dismiss) private var dismiss
    
    // 네비게이션 이동을 위한 EnvironmentObject 추가
    @EnvironmentObject var navManager: OnboardingNavigationManager
    
    // 개별 동의 항목들의 상태 (기본값: false = 회색 비활성화 상태)
    @State private var isTermsAgreed = false
    @State private var isPrivacyAgreed = false
    @State private var isEventAgreed = false
    @State private var isMarketingAgreed = false
    @State private var isAgeAgreed = false
    @State private var isKakaoAgreed = false
    
    // 전체 동의 여부를 확인하는 연산 프로퍼티
    var isAllAgreed: Bool {
        isTermsAgreed && isPrivacyAgreed && isEventAgreed && isMarketingAgreed && isAgeAgreed && isKakaoAgreed
    }
    
    let themeYellow = Color(red: 1.0, green: 0.89, blue: 0.3)
    
    var body: some View {
        ZStack {
            Color.customBlack.opacity(0.65)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                VStack(spacing: 0) {
                    
                    // 1. 헤더 영역 (서비스 명)
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 11)
                            .fill(Color.gray10)
                            .frame(width: 48, height: 48)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("자매 공유 옷장")
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("Sister Share Cloth")
                                .font(.subheadline)
                                .foregroundColor(Color.gray60)
                        }
                        Spacer()
                    }
                    .padding(20)
                    
                    Divider()
                    
                    // 2. 전체 동의하기 영역
                    Button(action: toggleAll) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    // 모두 동의되었을 때만 노란색, 아니면 회색 배경
                                    .fill(isAllAgreed ? themeYellow : Color.gray10)
                                    .frame(width: 24, height: 24)
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .bold))
                                    // 모두 동의되었을 때만 검은색, 아니면 회색 체크
                                    .foregroundColor(isAllAgreed ? Color.customBlack : Color.gray60.opacity(0.5))
                            }
                            
                            Text("전체 동의하기")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.customBlack)
                            Spacer()
                        }
                        .padding(20)
                    }
                    
                    Divider()
                    
                    // 3. 서비스 동의 리스트 영역
                    VStack(alignment: .leading, spacing: 18) {
                        Text("서비스 동의")
                            .font(.subheadline)
                            .foregroundColor(Color.gray60)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 4)
                        
                        AgreementRow(title: "[필수] 이용약관", hasAction: true, isAgreed: $isTermsAgreed)
                        AgreementRow(title: "[필수] 개인정보취급방침", hasAction: true, isAgreed: $isPrivacyAgreed)
                        AgreementRow(title: "[선택] 특가, 쿠폰 등 이벤트 알림 이메일, 문자, 앱 푸시", hasAction: false, isAgreed: $isEventAgreed)
                        AgreementRow(title: "[선택] 개인정보 마케팅 활용 동의", hasAction: true, isAgreed: $isMarketingAgreed)
                        AgreementRow(title: "[필수] 만 14세 이상입니다.", hasAction: false, isAgreed: $isAgeAgreed)
                        
                        Divider()
                            .padding(.vertical, 4)
                        
                        // 카카오톡 알림 동의
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(isKakaoAgreed ? Color.customBlack : Color.gray20)
                                .padding(.top, 2)
                                .onTapGesture {
                                    isKakaoAgreed.toggle()
                                }
                            
                            HStack(alignment: .top, spacing: 16) {
                                Text("[선택]")
                                Text("광고와 마케팅 메시지를 \n카카오톡으로 받습니다.")
                                    .lineSpacing(4)
                            }
                            .font(.subheadline)
                            .foregroundColor(Color.gray60)
                            .onTapGesture {
                                isKakaoAgreed.toggle()
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(20)
                    
                    // 4. 하단 버튼 (동의하고 계속하기)
                    Button(action: {
                        if isAllAgreed {
                            // ✅ 이미 모두 체크되어 활성화된 상태라면 다음 화면으로 이동
                            dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                navManager.push(.invite01)
                            }
                        } else {
                            // ✅ 아직 체크되지 않은 상태라면 체크만 수행 (버튼 활성화)
                            withAnimation(.easeInOut(duration: 0.2)) {
                                agreeAll()
                            }
                        }
                    }) {
                        Text("동의하고 계속하기")
                            .font(.headline)
                            .foregroundColor(isAllAgreed ? Color.customBlack : Color.gray60)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(isAllAgreed ? themeYellow : Color.gray10)
                    }
                }
                .background(Color.customWhite)
                .cornerRadius(16)
                .padding(.horizontal, 24)
                
                // 5. 취소 버튼
                Button(action: {
                    dismiss()
                }) {
                    Text("취소")
                        .font(.subheadline)
                        .foregroundColor(Color.customWhite)
                        .underline()
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    /// '전체 동의하기' 토글 액션
    private func toggleAll() {
        let newState = !isAllAgreed
        isTermsAgreed = newState
        isPrivacyAgreed = newState
        isEventAgreed = newState
        isMarketingAgreed = newState
        isAgeAgreed = newState
        isKakaoAgreed = newState
    }
    
    /// '동의하고 계속하기' 눌렀을 때 모두 true로 강제 변경
    private func agreeAll() {
        isTermsAgreed = true
        isPrivacyAgreed = true
        isEventAgreed = true
        isMarketingAgreed = true
        isAgeAgreed = true
        isKakaoAgreed = true
    }
}

// MARK: - 재사용 가능한 개별 동의 항목 Row 뷰
struct AgreementRow: View {
    var title: String
    var hasAction: Bool
    
    @Binding var isAgreed: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "checkmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(isAgreed ? Color.customBlack : Color.gray20)
                .padding(.top, 2)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(Color.gray60)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
            if hasAction {
                Button(action: {
                    // 보기 액션
                }) {
                    Text("보기")
                        .font(.subheadline)
                        .foregroundColor(Color.gray60)
                        .underline()
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                isAgreed.toggle()
            }
        }
    }
}

#Preview {
    SignupkakaoView()
        .environmentObject(OnboardingNavigationManager())
}
