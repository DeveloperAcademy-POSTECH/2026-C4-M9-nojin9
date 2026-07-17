//
//  invite01View.swift
//  Nojin9
//
//  Created by RyuHwagodong on 7/17/26.
//

import SwiftUI

struct invite01View: View {
    @EnvironmentObject var navManager: OnboardingNavigationManager
    
    // 초대 코드를 입력받을 상태 변수
    @State private var inviteCode: String = ""
    // 확인 버튼을 눌렀는지 체크하는 상태 변수
    @State private var isCodeConfirmed: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 1. 헤더 텍스트 영역
            VStack(alignment: .leading, spacing: 4) {
                Text("함께할 자매를 초대해 보세요")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.black)
                
                Text("최대 4명과 함께 할 수 있어요")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(Color(UIColor.systemGray))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 83)
            .padding(.horizontal, 28)
            
            // 2. 프로필 그래픽 영역
            HStack(spacing: 24) {
                // 채워진 프로필 (왼쪽)
                ZStack {
                    Circle()
                        .stroke(Color(UIColor.systemGray4), lineWidth: 1)
                    
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 41, height: 41)
                        .foregroundColor(Color.brandPrimary) // 핑크 포인트 컬러
                }
                .frame(width: 77, height: 77)
                .clipShape(Circle()) // 하단 영역 깔끔하게 자르기
                
                // 더하기 기호
                Text("+")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(.black)
                
                // 3. 빈 프로필 3개 (점선 및 겹침 효과)
                HStack(spacing: -24) {
                    ForEach(0..<3, id: \.self) { _ in
                        Circle()
                            .fill(Color.gray10) // 연한 회색 배경
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
                    .multilineTextAlignment(.center) // 텍스트 중앙 정렬
                    .font(.system(size: 18))
                    // ✅ 6글자 제한 및 코드 변경 시 확인 상태 초기화
                    .onChange(of: inviteCode) { newValue in
                        if newValue.count > 6 {
                            inviteCode = String(newValue.prefix(6))
                        }
                        if newValue != "NOJIN9" {
                            isCodeConfirmed = false
                        }
                    }
                
                // ✅ NOJIN9 입력 시에만 우측에 '확인' 버튼 표시
                if inviteCode == "NOJIN9" {
                    HStack {
                        Spacer()
                        Button(action: {
                            isCodeConfirmed = true
                        }) {
                            Text("확인")
                                .font(.system(size: 16, weight: .bold))
                                // 확인을 누르면 회색으로 변경 (UX 디테일)
                                .foregroundColor(isCodeConfirmed ? Color.gray40 : Color.brandPrimary)
                        }
                        .padding(.trailing, 20)
                    }
                }
            }
            .padding(.vertical, 11.5)
            .background(
                Capsule() // 양 끝이 완전히 둥근 캡슐 형태
                    .stroke(Color(UIColor.systemGray4), lineWidth: 1)
            )
            .padding(.horizontal, 26)
            .padding(.top, 43)
            
            // 5. 초대 링크 복사 버튼
            Button(action: {
                // ✅ 버튼 터치 시 초대 코드가 자동으로 "NOJIN9"로 채워지도록 설정
                inviteCode = "NOJIN9"
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "doc.on.doc")
                        .font(.system(size: 14))
                    Text("초대 링크 복사하기")
                        .font(.system(size: 14))
                }
                .foregroundColor(Color(UIColor.darkGray))
            }
            .padding(.top, 21)
            
            Spacer()
            
            // 6. 하단 다음 버튼 (상태에 따라 활성화/비활성화 전환)
            // ✅ 코드가 확인되었을 때만 PrimaryButton 노출
            if isCodeConfirmed {
                PrimaryButton(title: "다음") {
                    // 확인이 완료된 상태에서 다음으로 넘어가는 액션
                    // navManager.push(.nextRoute)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
            } else {
                PrimaryDisabledButton(title: "다음")
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
            }
        }
    }
}

// 프리뷰
#Preview {
    invite01View()
        .environmentObject(OnboardingNavigationManager())
}
