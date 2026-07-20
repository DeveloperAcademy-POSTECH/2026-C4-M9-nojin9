//
//  OnboardingNavigationManager.swift
//  Nojin9
//
//  Created by RyuHwagodong on 7/17/26.
//

import SwiftUI

final class OnboardingNavigationManager: ObservableObject {
    /// 네비게이션 경로 경로 배열
    @Published var path: [OnboardingRoute] = []
    
    /// 다음 화면으로 이동
    func push(_ route: OnboardingRoute) {
        path.append(route)
    }
    
    /// 이전 화면으로 복귀
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    /// 온보딩 처음 화면으로 초기화
    func popToRoot() {
        path.removeAll()
    }
}
