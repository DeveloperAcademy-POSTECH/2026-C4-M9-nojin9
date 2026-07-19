//
//  RentalView.swift
//  Nojin9
//
//  Created by 김가은 on 7/19/26.
//

import SwiftUI

struct RentalView: View {
    @Environment(\.dismiss) private var dismiss
    
    // 외부(ClosetView 등)에서 탭한 스티커의 ID를 주입받는 프로퍼티 (예: "Top1", "Bottom2")
    let itemID: String
    
    // 현재 로그인한 유저의 하트(재화) 보유량 (목업 데이터)
    @State private var userHearts: Int = 20000
    
    private var currentDetail: ClosetRentalItemDetail {
        RentalMockData.items[itemID] ?? RentalMockData.items["Top1"]!
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 메인 콘텐츠 스크롤 뷰 (인디케이터 숨김)
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    // ==========================================
                    // [구역 1] 상단 비주얼 영역 (배경지 + 옷 스티커)
                    // ==========================================
                    ZStack(alignment: .topLeading) {
                        
                        // [배경지] 에셋에 추가된 가로 402, 세로 50 규격의 RentalViewBackground 적용
                        Image("RentalViewBackground")
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 420)
                            .clipped()
                        
                        // [옷 스티커 사진] 주입받은 고유 아이템 ID와 동일한 이름의 에셋을 동적 매핑
                        Image(currentDetail.id)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 340)
                            .centerView() // 가로 정중앙 정렬 헬퍼
                            .padding(.top, 70)
                        
                        // [상단 백버튼] 이전 화면(옷장)으로 돌아가는 커스텀 원형 버튼
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color("customBlack"))
                                .frame(width: 44, height: 44)
                                .background(Color("customWhite"))
                                .clipShape(Circle())
                                .shadow(color: Color("customBlack").opacity(0.1), radius: 4, x: 0, y: 2)
                        }
                        .padding(.leading, 20)
                        .padding(.top, 60)
                        
                        // [페이지 인디케이터] 사진 우하단에 위치하는 1/1 뱃지
                        Text("1/1")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(Color("customWhite"))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color("customBlack").opacity(0.4))
                            .clipShape(Capsule())
                            .padding(.trailing, 20)
                            .padding(.top, 380)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    
                    // ==========================================
                    // [구역 2] 옷 메타 정보 영역 (이름, 색상, 가격 등)
                    // ==========================================
                    VStack(alignment: .leading, spacing: 0) {
                        // 계층 경로 표시 (예: 첫째 언니 > 상의)
                        HStack(spacing: 4) {
                            Text(currentDetail.owner)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 10))
                            Text(currentDetail.categoryName)
                        }
                        .font(.system(size: 13))
                        .foregroundStyle(Color("gray40"))
                        .padding(.top, 20)
                        
                        // 옷 이름 및 대여 가능 상태 뱃지
                        HStack(alignment: .firstTextBaseline, spacing: 12) {
                            Text(currentDetail.title)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(Color("customBlack"))
                            
                            Text(currentDetail.isAvailable ? "빌려오기 가능" : "대여 중")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(Color("brandPrimary"))
                        }
                        .padding(.top, 8)
                        
                        // 옷 색상 정보
                        Text("색상  \(currentDetail.color)")
                            .font(.system(size: 15))
                            .foregroundStyle(Color("customBlack"))
                            .padding(.top, 10)
                        
                        Divider()
                            .background(Color("gray10"))
                            .padding(.vertical, 16)
                        
                        // [가격 및 재화 표시]
                        HStack(spacing: 6) {
                            Image("Coin")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)
                            
                            Text(formatNumber(currentDetail.price))
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(Color("customBlack"))
                        }
                        
                        // 유저의 보유 하트 잔액 잔여량
                        Text("현재 보유 하트 : \(formatNumber(userHearts))")
                            .font(.system(size: 12))
                            .foregroundStyle(Color("gray40"))
                            .padding(.top, 6)
                    }
                    .padding(.horizontal, 20)
                    
                    // 디자인 시스템 가이드에 맞춘 회색 섹션 구분 바
                    Rectangle()
                        .fill(Color("gray5"))
                        .frame(height: 8)
                        .padding(.top, 20)
                    
                    // ==========================================
                    // [구역 3] 주의 사항 섹션 (체크박스 리스트 형태)
                    // ==========================================
                    VStack(alignment: .leading, spacing: 14) {
                        Text("주의 사항")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(Color("customBlack"))
                        
                        // 주의 사항을 감싸는 라운드 핑크 박스
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(currentDetail.notices, id: \.self) { notice in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundStyle(Color("brandPrimary"))
                                        .padding(.top, 3)
                                    
                                    Text(notice)
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color("gray80"))
                                        .lineSpacing(4)
                                }
                            }
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color("brandPrimary10").opacity(0.4))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // 섹션 구분 바
                    Rectangle()
                        .fill(Color("gray5"))
                        .frame(height: 8)
                        .padding(.top, 20)
                    
                    // ==========================================
                    // [구역 4] 감사 편지(리뷰) 피드 섹션
                    // ==========================================
                    VStack(alignment: .leading, spacing: 16) {
                        // 데이터셋 내의 편지 개수를 동적으로 카운트하여 상단에 표기
                        Text("감사 편지 (\(currentDetail.thankYouLetters.count))")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(Color("customBlack"))
                        
                        if currentDetail.thankYouLetters.isEmpty {
                            // 감사 편지 배열이 비어있을 때 보여줄 빈 화면 텍스트 처리
                            Text("아직 작성된 감사 편지가 없습니다.")
                                .font(.system(size: 14))
                                .foregroundStyle(Color("gray40"))
                                .padding(.vertical, 20)
                                .centerView()
                        } else {
                            // 존재하는 감사 편지 개수만큼 반복하여 렌더링
                            ForEach(currentDetail.thankYouLetters) { letter in
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack(spacing: 10) {
                                        
                                        // 💡 [프로필 사진 동적 매핑 분기 로직]
                                        // 작성자 텍스트 내용에 맞춰 에셋 이름을 매핑합니다.
                                        if letter.author == "나" {
                                            Image("MyProfile")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                        } else if letter.author.contains("둘째 언니") || letter.author.contains("둘째언니") {
                                            Image("2ndSisProfile")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                        } else {
                                            // 매핑되지 않은 다른 작성자(예: 첫째언니 등)가 나타날 경우를 대비한 안전 장치
                                            Image(systemName: "person.crop.circle.fill")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 40, height: 40)
                                                .foregroundStyle(Color("gray40"))
                                        }
                                        
                                        // 작성자 이름 및 작성 날짜
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(letter.author)
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundStyle(Color("customBlack"))
                                            Text(letter.date)
                                                .font(.system(size: 12))
                                                .foregroundStyle(Color("gray40"))
                                        }
                                    }
                                    
                                    // 리뷰 본문 내용
                                    Text(letter.content)
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color("customBlack"))
                                        .lineSpacing(4)
                                        .padding(.vertical, 2)
                                    
                                    // 💡 [후기 사진 에셋 부재 및 예외 처리 로직]
                                    // 1단계: 에셋 배열 자체가 비어있지 않은지(!images.isEmpty) 먼저 검사합니다.
                                    // 2단계: 에셋 이름 문자열이 실제 프로젝트 Asset에 존재하는 파일인지(UIImage(named:) != nil) 검사하여,
                                    // 이미지 에셋 파일이 프로젝트에 없다면 아예 UI 뷰 영역을 렌더링하지 않고 글 내용만 깔끔하게 보여줍니다.
                                    if !letter.images.isEmpty {
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 8) {
                                                ForEach(letter.images, id: \.self) { imgName in
                                                    if UIImage(named: imgName) != nil {
                                                        Image(imgName)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 140, height: 140)
                                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.bottom, 24)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40) // 하단 스크롤 여유 안전 영역 마진
                }
            }
            
            // ==========================================
            // [구역 5] 하단 바닥 고정 대여(CTA) 버튼 영역
            // ==========================================
            VStack(spacing: 0) {
                Divider()
                    .background(Color("gray10"))
                
                // 빌려오기 가능 상태(isAvailable)에 따라 버튼 탭 활성화/비활성화 및 컬러 변경 처리
                Button(action: {
                    print("\(currentDetail.title) 빌려오기 액션 발동")
                }) {
                    Text("빌려오기")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color("customWhite"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(currentDetail.isAvailable ? Color("brandPrimary") : Color("gray40"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .disabled(!currentDetail.isAvailable)
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 24) // 노치 기기 홈바 영역 대응 패딩
            }
            .background(Color("customWhite"))
        }
        .ignoresSafeArea(edges: .top) // 배경지가 상태바 영역까지 꽉 채우도록 설정
        .navigationBarHidden(true)    // 기본 내비게이션 바 숨김 처리 (커스텀 백버튼 사용)
    }
    
    // 세 자리 단위로 콤마(,) 포맷팅을 도와주는 유틸리티 함수 (예: 2500 -> 2,500)
    private func formatNumber(_ num: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: num)) ?? "\(num)"
    }
}

// 가로 정중앙 배치를 편리하게 도와주는 View 확장 헬퍼
private extension View {
    func centerView() -> some View {
        HStack {
            Spacer()
            self
            Spacer()
        }
    }
}

// MARK: - Preview
#Preview {
    RentalView(itemID: "Top1")
}
