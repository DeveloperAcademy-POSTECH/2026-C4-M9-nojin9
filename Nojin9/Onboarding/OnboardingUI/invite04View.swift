//
//  invite04View.swift
//  Nojin9
//
//  Created by RyuHwagodong on 7/18/26.
//

import SwiftUI

struct invite04View: View {
    @EnvironmentObject var navManager: OnboardingNavigationManager
    @State private var nickname: String = ""
    @FocusState private var isFocused: Bool
    
    // 화면에 보여줄 프로필 이미지 상태 변수
    @State private var profileImage: Image? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            (Text("프로필").foregroundStyle(Color.brandPrimary) +
             Text("을 설정해주세요").foregroundStyle(Color.customBlack))
                .font(.appTitle)
                .lineSpacing(32 - 26)
                .padding(.top, 83)
                .padding(.horizontal, 33)
            
            Spacer()
            
            // 2. 중앙 컨텐츠 영역 (프로필 이미지 + 닉네임 입력)
            VStack(spacing: 44) {
                
                // 프로필 이미지 및 카메라 아이콘
                ZStack(alignment: .bottomTrailing) {
                    
                    // 메인 프로필 원형 영역
                    ZStack {
                        if let profileImage {
                            // ✅ 카메라 아이콘 터치 시 MyProfile 이미지가 빈틈없이 꽉 채워짐
                            profileImage
                                .resizable()
                                .scaledToFill() // 비율을 유지하며 꽉 채움 (공백 방지)
                                .frame(width: 198, height: 198) // 크기 고정
                                .clipShape(Circle()) // 동그라미 모양으로 자르기
                        } else {
                            // ✅ 이미지가 없을 때 기본 프로필 아이콘 노출
                            ZStack {
                                Color.clear
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 105.43, height: 105.43)
                                    .foregroundStyle(Color.brandPrimary)
                                    .offset(y: 0)
                            }
                            .frame(width: 198, height: 198)
                            .clipShape(Circle())
                        }
                    }
                    .frame(width: 198, height: 198)
                    .overlay(
                        // ✅ 이미지가 추가되더라도 테두리가 사라지지 않도록 오버레이 유지
                        Circle().stroke(Color.gray40, lineWidth: 1)
                    )
                    
                    // 카메라 설정 버튼
                    Button(action: {
                        // ✅ 버튼 터치 시 Assets의 "MyProfile" 이미지로 상태 변경
                        withAnimation(.easeInOut(duration: 0.2)) {
                            profileImage = Image("MyProfile")
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.gray40) // 회색 배경
                                .frame(width: 53, height: 53)
                            
                            Image(systemName: "camera.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(Color.customWhite) // 하얀색 아이콘
                        }
                    }
                    .offset(x: 4, y: 4) // 프로필 테두리에 살짝 걸치도록 오프셋 이동
                }
                
                // 닉네임 입력 필드
                TextField("닉네임을 입력해주세요", text: $nickname)
                    .multilineTextAlignment(.center)
                    .font(.appBody)
                    .focused($isFocused)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .stroke(Color.gray10, lineWidth: 1)
                    )
                    .padding(.horizontal, 26)
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
            Spacer()
            
            HStack(spacing: 8) {
                SecondaryButton(title: "이전") {
                    navManager.pop()
                }
                if nickname.isEmpty {
                    PrimaryDisabledButton(title: "다음") { }
                } else {
                    PrimaryButton(title: "다음") {
                        // ✅ 다음 버튼 터치 시 invite05View로 이동합니다.
                        navManager.push(.invite05)
                    }
                }
            }
            .padding(.horizontal, 26)
            .padding(.bottom, 13)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = false
        }
        .navigationBarBackButtonHidden(true)
    }
}

// 프리뷰
#Preview {
    invite04View()
        .environmentObject(OnboardingNavigationManager())
}
