//
//  OnboardingB1View.swift
//  Nojin9
//
//  Created by RyuHwagodong on 7/17/26.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var navManager: OnboardingNavigationManager
    
    @State private var isShowingB2View = false
    @State private var showingNotImplementedAlert = false
    
    var body: some View {
        ZStack {
            Color.customWhite.ignoresSafeArea()
            Image("OnboardingBG2")
                .resizable()
                .ignoresSafeArea()
            
            // ✅ 1. 최상단 VStack의 좌측 정렬 제거 -> 기본값(중앙 정렬)으로 버튼과 이미지가 가운데로 옴
            VStack(spacing: 0) {
                
                // ✅ 2. 텍스트 영역만 별도의 VStack으로 묶어 좌측 정렬 및 간격(spacing: 8) 설정 (겹침 방지)
                VStack(alignment: .leading, spacing: 8) {
                    (Text("회원가입").foregroundStyle(Color.brandPrimary) +
                     Text("을 진행해 주세요").foregroundStyle(Color.customBlack))
                        .font(.appTitle)
                        .lineSpacing(32 - 26)
                    
                    Text("모든 정보가 아이디로 저장돼요")
                        .font(.appSubtitle)
                        .foregroundStyle(Color.gray60)
                        // 기존에 겹침을 유발했던 .padding(.top, -10) 삭제
                }
                .frame(maxWidth: .infinity, alignment: .leading) // 이 그룹만 화면 좌측으로 밀착
                .padding(.top, 29)
                .padding(.horizontal, 26) // 하단 버튼의 기본 패딩과 동일하게 맞춰 안정감 부여
                
                Spacer()
                
                // 중앙 이미지
                Image("Signup")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 40)
                
                Spacer()
                
                VStack(spacing: 20) {
                    HStack(spacing: 6) {
                        Text("이미 가입했나요?")
                            .font(.appCaption)
                            .foregroundStyle(Color.gray40)
                        
                        Button(action: {
                            showingNotImplementedAlert = true
                        }) {
                            Text("로그인")
                                .font(.appCaption)
                                .foregroundStyle(Color.gray40)
                                .underline()
                        }
                    }
                    
                    VStack(spacing: 8) {
                        
                        Button(action: {
                            isShowingB2View = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "message.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                Text("Kakao로 회원가입")
                            }
                            .font(.appButton)
                            .foregroundStyle(Color(.customBlack))
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color(.yellow))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                        .frame(width: 332, height: 56)
                        
                        Button(action: {
                            showingNotImplementedAlert = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "apple.logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                Text("Apple로 회원가입")
                            }
                            .font(.appButton)
                            .foregroundStyle(Color.customWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.customBlack)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                        .frame(width: 332, height: 56)
                    }
                }
                .padding(.bottom, 24) // 디자인 비율에 맞게 하단 패딩 조정
            }
        }
        .fullScreenCover(isPresented: $isShowingB2View) {
            SignupkakaoView()
                .presentationBackground(.clear)
        }
        .alert("알림", isPresented: $showingNotImplementedAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text("아직 구현 전 입니다")
        }
    }
}

#Preview {
    SignupView()
        .environmentObject(OnboardingNavigationManager())
}
