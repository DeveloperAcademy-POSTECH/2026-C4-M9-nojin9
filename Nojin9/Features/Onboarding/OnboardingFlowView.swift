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
                        invite05View()
                            .environmentObject(navigationManager)
                    }
                }
        }
    }
}

#Preview {
    OnboardingFlowView()
}
