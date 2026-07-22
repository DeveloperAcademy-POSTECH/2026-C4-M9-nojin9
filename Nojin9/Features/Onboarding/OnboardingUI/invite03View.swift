//
//  invite03View.swift
//  Nojin9
//
//  Created by RyuHwagodong on 7/18/26.
//

import SwiftUI

struct invite03View: View {
    @EnvironmentObject var navManager: OnboardingNavigationManager
    
    // 더미용 초대 코드 (이 화면에서는 비활성화 처리)
    @State private var inviteCode: String = ""
    
    // 수정 가능한 유저 이름 상태
    @State private var userName: String = "user01"
    
    // 키보드 노출/숨김 상태를 관리하는 FocusState
    @FocusState private var isNameFocused: Bool
    
    var body: some View {
        ZStack {
            Color.customWhite.ignoresSafeArea()
            VStack(spacing: 0) {
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
                
                // 초대 코드 필드 (이전 화면의 형태만 유지하고 비활성화)
                ZStack {
                    TextField(
                        "",
                        text: $inviteCode,
                        prompt: Text("초대 코드를 입력해 주세요")
                            .foregroundStyle(Color.gray60)
                    )
                        .multilineTextAlignment(.center)
                        .font(.appBody)
                        .foregroundStyle(Color.customBlack)
                        .tint(Color.brandPrimary)
                        .disabled(true) // 입력 불가 처리
                }
                .padding(.vertical, 11.5)
                .background(
                    Capsule()
                        .stroke(Color.gray40, lineWidth: 1)
                )
                .padding(.horizontal, 26)
                .padding(.top, 43)
                
                // 초대 링크 복사 버튼
                Button(action: { }) {
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
            }
            .ignoresSafeArea(.keyboard) // ✅ 핵심: 상단 영역은 키보드에 밀리지 않도록 고정
            
            // --- 2. 하단 이동 영역 (키보드가 올라오면 함께 위로 이동) ---
            VStack(spacing: 0) {
                Spacer() // 하단으로 요소들을 밀어냅니다.
                
                // 유저 수정 카드
                HStack {
                    // 이름 텍스트필드 & 수정(연필) 아이콘
                    HStack(spacing: 6) {
                        TextField(
                            "",
                            text: $userName,
                            prompt: Text("이름")
                                .foregroundStyle(Color.gray60)
                        )
                            .font(.appBody)
                            .foregroundStyle(Color.customBlack)
                            .tint(Color.brandPrimary)
                            .focused($isNameFocused) // ✅ 터치 시 키보드 활성화 연결
                            .fixedSize(horizontal: true, vertical: false) // 이름 길이에 맞춰 TextField 크기 조절
                        
                        Button(action: {
                            isNameFocused = true // 연필 아이콘 터치해도 키보드 열림
                        }) {
                            Image(systemName: "pencil")
                                .font(.system(size: 16))
                                .foregroundStyle(Color.customBlack)
                        }
                    }
                    
                    Spacer()
                    
                    // 수락 완료 & 취소 버튼
                    HStack(spacing: 12) {
                        Text("수락 완료")
                            .font(.appCaption)
                            .foregroundStyle(Color.gray60)
                        
                        Button(action: {
                            // 취소 로직 추가
                        }) {
                            Text("취소")
                                .font(.appCaption)
                                .foregroundStyle(Color.brandPrimary)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
                .background(
                    // ✅ 카드 위로 올라갈 때 뒷배경이 비치지 않게 솔리드 컬러(customWhite) 채움
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.customWhite)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray40, lineWidth: 1)
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                
                // 다음 버튼
                PrimaryButton(title: "다음") {
                    // ✅ 다음 버튼 터치 시 invite04View로 이동합니다.
                    navManager.push(.invite04)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
            }
        }
        // ✅ 빈 배경 터치 시 키보드를 자연스럽게 내리는 로직
        .contentShape(Rectangle())
        .onTapGesture {
            isNameFocused = false
        }
    }
}

// 프리뷰
#Preview {
    invite03View()
        .environmentObject(OnboardingNavigationManager())
}
