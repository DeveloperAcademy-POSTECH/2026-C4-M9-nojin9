//
//  OnboardingView.swift
//  Nojin9
//
//  Created by RyuHwagodong on 7/17/26.
//

import SwiftUI

struct OnboardingMainView: View {
    @EnvironmentObject var navManager: OnboardingNavigationManager
    
    var body: some View {
        ZStack {
            Color.customWhite.ignoresSafeArea()
            Image("OnboardingBG")
                .resizable()
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("함께 쓰는 우리만의\n공유 옷장을 만들어볼까요?")
                    .titleStyle()
                    .padding(.top, 83)
                    .padding(.horizontal, 26)
                
                Spacer()
                
                VStack(spacing: 12) {
                    PrimaryButton(title: "시작하기") {
                        // 정의된 다음 라우트로 이동 요청
                        navManager.push(.Signup)
                    }
                    
                    Button(action: {
                        // 로그인 화면 라우트 추가 시 처리 가능
                    }) {
                        Text("로그인")
                            .font(.appButton)
                            .foregroundStyle(Color.customWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.gray60)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
            }
        }
        .navigationBarBackButtonHidden(true) // 커스텀 뒤로가기나 스와이프 처리를 위해 숨김
    }
}

#Preview {
    OnboardingMainView()
        .environmentObject(OnboardingNavigationManager())
}
