//
//  OnboardingFlowView.swift
//  Nojin9
//
//  Created by RyuHwagodong on 7/17/26.
//

import SwiftUI

struct OnboardingFlowView: View {
    @StateObject private var navigationManager = OnboardingNavigationManager()
    let onComplete: () -> Void

    init(onComplete: @escaping () -> Void = { }) {
        self.onComplete = onComplete
    }
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
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
                        
                    case .invite02:
                        invite02View()
                            .environmentObject(navigationManager)
                        
                    case .invite03:
                        invite03View()
                            .environmentObject(navigationManager)
                        
                    case .invite04:
                        invite04View()
                            .environmentObject(navigationManager)
                        
                    case .invite05:
                        invite05View(onComplete: onComplete)
                            .environmentObject(navigationManager)
                            
                    }
                }
        }
        .background(Color.customWhite.ignoresSafeArea())
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

#Preview {
    OnboardingFlowView()
}
