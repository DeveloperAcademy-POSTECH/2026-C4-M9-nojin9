//
//  OnboardingFlowView.swift
//  Nojin9
//
//  Created by RyuHwagodong on 7/17/26.
//

import SwiftUI

struct OnboardingFlowView: View {
    @StateObject private var navigationManager = OnboardingNavigationManager()
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            // 온보딩의 가장 첫 번째 시작 페이지
            OnboardingMainView()
                .environmentObject(navigationManager)
                .navigationDestination(for: OnboardingRoute.self) { route in
                    switch route {
                    case .OnboardingMain:
                        OnboardingMainView()
                            .environmentObject(navigationManager)
                            
                    case .Signup:
                        SignupView()
                            .environmentObject(navigationManager)

                    case .Signupkakao:
                        SignupkakaoView()
                            .environmentObject(navigationManager)
                        
                    case .invite01:
                        invite01View()
                            .environmentObject(navigationManager)
                    // 새로운 템플릿이 추가되면 이곳에 case만 추가하여 연결합니다.
                    }
                }
        }
    }
}

#Preview {
    OnboardingFlowView()
}
