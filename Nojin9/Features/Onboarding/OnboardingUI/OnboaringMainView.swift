//
//  OnboardingView.swift
//  Nojin9
//
//  Created by RyuHwagodong on 7/17/26.
//

import SwiftUI

struct OnboardingMainView: View {
    @EnvironmentObject var navManager: OnboardingNavigationManager
    @State private var showingNotImplementedAlert = false
    
    var body: some View {
        ZStack {
            Color.customWhite.ignoresSafeArea()
            Image("OnboardingBG")
                .resizable()
                .ignoresSafeArea()
            
            // ✅ spacing: 0을 명시하여 패딩값이 126으로 정확하게 떨어지도록 설정
            VStack(spacing: 0) {
                Text("함께 쓰는 우리만의\n공유 옷장을 만들어볼까요?")
                    .titleStyle()
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 83)
                    .padding(.horizontal, 26)
                
                Spacer()
                
                // ✅ Assets에 있는 메인 이미지 추가 및 설정
                Image("OnboardingMain")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 48) // 이미지가 좌우로 너무 꽉 차지 않도록 여백 추가
                    .padding(.bottom, 126) // 🚨 시작하기 버튼과의 정확한 패딩값 126 적용
                
                VStack(spacing: 12) {
                    PrimaryButton(title: "시작하기") {
                        // 정의된 다음 라우트로 이동 요청
                        navManager.push(.Signup)
                    }
                    
                    Button(action: {
                        showingNotImplementedAlert = true
                    }) {
                        Text("로그인")
                            .font(.appButton)
                            .foregroundStyle(Color.customWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.gray60)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                    .frame(width: 332, height: 56)
                }
                .padding(.bottom, 15)
            }
        }
        .alert("알림", isPresented: $showingNotImplementedAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text("아직 구현 전 입니다")
        }
    }
}

#Preview {
    OnboardingMainView()
        .environmentObject(OnboardingNavigationManager())
}
