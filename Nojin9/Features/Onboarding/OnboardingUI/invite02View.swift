//
//  invite02View.swift
//  Nojin9
//
//  Created by RyuHwagodong on 7/18/26.
//

import SwiftUI

struct invite02View: View {
    @EnvironmentObject var navManager: OnboardingNavigationManager
    
    // 초대자 이름 (추후 서버 데이터나 이전 화면에서 넘겨받을 수 있도록 처리)
    let inviterName: String = "김서연"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            (Text("\(inviterName) 님").foregroundStyle(Color.brandPrimary) +
             Text("이 당신을\n공유 옷장으로 초대했어요").foregroundStyle(Color.customBlack))
                .font(.appTitle)
                .lineSpacing(32 - 26)
                .multilineTextAlignment(.leading) // 추가: 여러 줄 텍스트가 예쁘게 좌측 정렬되도록 보장
                .padding(.top, 83)
                .padding(.horizontal, 26)
            
            Spacer()
            
            // 2. 하단 버튼 영역 (거절하기 / 수락하기)
            HStack(spacing: 8) {
                SecondaryButton(title: "거절하기") {
                    // 거절하기 액션 (이전 화면으로 돌아가기)
                    navManager.pop()
                }
                
                // CommonUI를 건드리지 않기 위해, 고정폭(332)을 가진 PrimaryButton 대신
                // 디자인은 동일하되 남은 공간(.infinity)을 꽉 채우는 버튼을 직접 구현합니다.
                Button(action: {
                    // ✅ 수락하기 버튼 터치 시 invite03View로 이동합니다.
                    navManager.push(.invite03)
                }) {
                    Text("수락하기")
                        .font(.appButton)
                        .foregroundStyle(Color(.customWhite))
                        .frame(maxWidth: .infinity) // 고정 너비 없이 남은 빈 공간을 모두 차지함
                        .frame(height: 56)
                        .background(Color.brandPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
        // 네비게이션 기본 뒤로가기 버튼 숨김
        .navigationBarBackButtonHidden(true)
    }
}

// 프리뷰
#Preview {
    invite02View()
        .environmentObject(OnboardingNavigationManager())
}
