//
//  OnboardingB1View.swift
//  Nojin9
//
//  Created by RyuHwagodong on 7/17/26.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var navManager: OnboardingNavigationManager
    
    // 약관 동의 팝업(B2) 표시 여부를 관리하는 상태 변수
    @State private var isShowingB2View = false
    
    var body: some View {
        ZStack {
            Color.customWhite.ignoresSafeArea()
            Image("OnboardingBG2")
                .resizable()
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                (Text("회원가입").foregroundStyle(Color.brandPrimary) +
                 Text("을 진행해 주세요").foregroundStyle(Color.customBlack))
                    .font(.appTitle)
                    .lineSpacing(32 - 26)
                    .padding(.top, 83)
                    .padding(.horizontal, 33)
                
                Text("모든 정보가 아이디로 저장돼요")
                    .font(.appSubtitle)
                    .lineSpacing(24 - 20)
                    .foregroundStyle(Color.gray60)
                    .padding(.top, -10)
                    .padding(.horizontal, 33)
                
                Spacer()
                
                VStack(spacing: 20) {
                    HStack(spacing: 6) {
                        Text("이미 가입했나요?")
                            .font(.appCaption)
                            .foregroundStyle(Color.gray40)
                        
                        Button(action: {
                            // 로그인 화면 이동 등 액션
                        }) {
                            Text("로그인")
                                .font(.appCaption)
                                .foregroundStyle(Color.gray40)
                                .underline()
                        }
                    }
                    .padding(.bottom, -4)
                    
                    VStack(spacing: 10) {
                        // 카카오 회원가입 버튼 누르면 팝업 띄우기
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
                        
                        Button(action: {
                            // 애플 회원가입 액션
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
                    }
                }
                .padding(.horizontal, 26)
                .padding(.bottom, 14)
            }
        }
        .navigationBarBackButtonHidden(true)
        
        // 팝업 형식(전체 화면)으로 OnboardingB2View를 띄움
        .fullScreenCover(isPresented: $isShowingB2View) {
            SignupkakaoView()
                // iOS 시스템 기본 시트 배경을 투명하게 만들어
                // B2 디자인 내부의 어두운 배경(opacity(0.65))이 온전히 표현되도록 합니다.
                .presentationBackground(.clear)
        }
    }
}

#Preview {
    SignupView()
        .environmentObject(OnboardingNavigationManager())
}
