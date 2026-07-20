//
//  invite05View.swift
//  Nojin9
//
//  Created by RyuHwagodong on 7/18/26.
//

import SwiftUI

struct invite05View: View {
    @EnvironmentObject var navManager: OnboardingNavigationManager
    
    // 프로그래스 바 애니메이션을 위한 상태 변수
    @State private var progress: CGFloat = 0.2
    
    // ✅ 텍스트와 버튼을 자연스럽게 변환하기 위한 상태 변수 추가
    @State private var isLastPage: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // 1. 공통 영역: 상단 진행 상태 (Progress) 바
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray10) // 덜 채워진 기본 배경
                        .frame(width: geometry.size.width, height: 3)
                    
                    Capsule()
                        .fill(Color.brandPrimary)
                        .frame(width: geometry.size.width * progress, height: 3) // 상태 변수에 따라 늘어남
                }
            }
            .frame(height: 4)
            .padding(.top, 19)
            .padding(.horizontal, 26)
            .onAppear {
                // 최초 화면 진입 시 0.35까지 차오름
                withAnimation(.easeInOut(duration: 0.5)) {
                    progress = 0.35
                }
            }
            
            // 2. 본문 영역: 상태에 따라 내용이 교체됨
            if !isLastPage {
                // ---------------- 기존 invite05View 콘텐츠 ----------------
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("서로 믿고 기분 좋게 공유해요")
                            .titleStyle()
                        
                        Text("쇼핑하듯 쉽게 빌려요")
                            .font(.appSubtitle)
                            .foregroundStyle(Color.gray80)
                    }
                    .padding(.top, 51)
                    .padding(.horizontal, 33)

                    VStack(spacing: 16) {
                        StepCardView(step: 1) {
                            (Text("자매의 공유 옷장에서\n").font(.appBody) +
                             Text("마음에 드는 물품").font(.appBodyBold) +
                             Text("을 골라요").font(.appBody))
                        }
                        
                        StepCardView(step: 2) {
                            (Text("하트 포인트").font(.appBodyBold) +
                             Text("를 지불하며\n물품을 ").font(.appBody) +
                             Text("빌려와요").font(.appBodyBold))
                        }
                        
                        StepCardView(step: 3) {
                            (Text("정해진 기간 동안 사용하고\n돌려주며 ").font(.appBody) +
                             Text("감사 편지").font(.appBodyBold) +
                             Text("를 남겨요").font(.appBody))
                        }
                    }
                    .padding(.top, 103)
                    .padding(.horizontal, 26)
                }
                .transition(.opacity) // ✅ 페이드 아웃/인 효과
                
            } else {
                // ---------------- 기존 invite06View 콘텐츠 ----------------
                VStack(alignment: .leading, spacing: 0) {
                    (Text("이제,\n우리 만의 ")
                        .foregroundStyle(Color.customBlack) +
                     Text("공유 옷장")
                        .foregroundStyle(Color.brandPrimary) +
                     Text("을\n시작해볼까요?")
                        .foregroundStyle(Color.customBlack))
                    .font(.appTitle)
                    .lineSpacing(32 - 26)
                    .padding(.top, 51)
                    .padding(.horizontal, 27)
                }
                .transition(.opacity) // ✅ 페이드 아웃/인 효과
            }
            
            Spacer()
            
            // 3. 하단 버튼 영역: 상태에 따라 교체됨
            if !isLastPage {
                HStack(spacing: 8) {
                    SecondaryButton(title: "이전") {
                        navManager.pop() //
                    }
                    
                    PrimaryButton(title: "다음") {
                        // ✅ 터치 시 다음 화면으로 넘어가지 않고, 상태만 변경하여 애니메이션 실행
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isLastPage = true
                            progress = 1.0 // 게이지 100%로 변경
                        }
                    }
                }
                .padding(.horizontal, 26)
                .padding(.bottom, 13)
                .transition(.opacity)
            } else {
                PrimaryButton(title: "시작하기") {
                    // 시작하기 버튼 액션 (예: 메인 화면 진입)
                }
                .padding(.horizontal, 26)
                .padding(.bottom, 13)
                .transition(.opacity)
            }
        }
        .navigationBarBackButtonHidden(true) //
    }
}

// MARK: - 재사용 가능한 스텝 카드 컴포넌트
struct StepCardView: View {
    let step: Int
    let content: () -> Text
    
    var body: some View {
        HStack(spacing: 16) {
            
            ZStack {
                Circle()
                    .fill(Color.brandPrimary)
                    .frame(width: 40, height: 40)
                
                Text("\(step)")
                    .font(.appSubtitleBold)
                    .foregroundStyle(Color.customWhite)
            }
            content()
                .foregroundStyle(Color.customBlack)
                .lineSpacing(24 - 18)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 22)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.customWhite)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray5, lineWidth: 1)
        )
    }
}

// 프리뷰
#Preview {
    invite05View()
        .environmentObject(OnboardingNavigationManager())
}
