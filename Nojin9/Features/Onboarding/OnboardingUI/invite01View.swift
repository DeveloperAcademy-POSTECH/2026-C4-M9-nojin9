//
//  invite01View.swift
//  Nojin9
//
//  Created by RyuHwagodong on 7/17/26.
//
// 초대코드는 '노진구'

import SwiftUI

struct invite01View: View {
    @EnvironmentObject var navManager: OnboardingNavigationManager
    
    // 초대 코드를 입력받을 상태 변수
    @State private var inviteCode: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 1. 헤더 텍스트 영역
            VStack(alignment: .leading, spacing: 4) {
                Text("함께할 자매를 초대해 보세요")
                    .titleStyle()
                
                Text("최대 4명과 함께 할 수 있어요")
                    .font(.appSubtitle)
                    .foregroundStyle(Color.gray60)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 83)
            .padding(.horizontal, 28)
            
            // 2. 프로필 그래픽 영역
            HStack(spacing: 24) {
                ZStack {
                    Circle()
                        .stroke(Color.gray40, lineWidth: 1)
                    
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 41, height: 41)
                        .foregroundStyle(Color.brandPrimary)
                }
                .frame(width: 77, height: 77)
                .clipShape(Circle())
                
                Text("+")
                    .font(.appTitle)
                    .foregroundStyle(Color.customBlack)
                
                // 3. 빈 프로필 3개
                HStack(spacing: -24) {
                    ForEach(0..<3, id: \.self) { _ in
                        Circle()
                            .fill(Color.gray10)
                            .frame(width: 77, height: 77)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray40, style: StrokeStyle(lineWidth: 1.5, dash: [4, 4]))
                            )
                    }
                }
            }
            .padding(.top, 60)
            
            // 4. 초대 코드 입력 필드 영역
            ZStack {
                TextField("초대 코드를 입력해 주세요", text: $inviteCode)
                    .multilineTextAlignment(.center)
                    .font(.appBody)
                    .onChange(of: inviteCode) { newValue in
                        if newValue.count > 6 {
                            inviteCode = String(newValue.prefix(6))
                        }
                    }
                
                // 코드가 일치하면 나타나는 '확인' 버튼
                if inviteCode == "노진구" {
                    HStack {
                        Spacer()
                        Button(action: {
                            // ✅ 확인 버튼 누르면 즉시 invite02로 이동
                            navManager.push(.invite02)
                        }) {
                            Text("확인")
                                .font(.appButton)
                                .foregroundStyle(Color.brandPrimary)
                        }
                        .padding(.trailing, 20)
                    }
                }
            }
            .padding(.vertical, 11.5)
            .background(
                Capsule()
                    .stroke(Color.gray40, lineWidth: 1)
            )
            .padding(.horizontal, 26)
            .padding(.top, 43)
            
            // 5. 초대 링크 복사 버튼
            Button(action: {
                // 추후 실제 기기 클립보 복사 기능 구현
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "doc.on.doc")
                        .font(.appCaption)
                    Text("초대 링크 복사하기")
                        .font(.appCaption)
                }
                .foregroundStyle(Color.gray60)
            }
            .padding(.top, 21)
            
            Spacer()
            
            // 6. 하단 다음 버튼 (항상 활성화 상태)
            PrimaryButton(title: "다음") {
                // ✅ 누르면 즉시 invite04로 이동
                navManager.push(.invite04)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
    }
}

// 프리뷰
#Preview {
    invite01View()
        .environmentObject(OnboardingNavigationManager())
}
