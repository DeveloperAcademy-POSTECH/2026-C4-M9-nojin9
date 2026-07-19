//
//  ClosetView.swift
//  Nojin9
//
//  Created by 김가은 on 7/15/26.
//

import SwiftUI

// MARK: - Closet Item Model
/// 옷장 내부에 배치될 개별 옷 스티커 아이템 모델
struct ClosetItem: Identifiable {
    let id = UUID()
    let assetName: String      // 이미지 에셋 이름
    let category: ClosetCategory
}

/// 옷장 카테고리 구분을 위한 열거형
enum ClosetCategory: String, CaseIterable {
    case top = "상의"
    case bottom = "하의"
    case accessories = "기타"
}

// MARK: - Main Closet View
struct ClosetView: View {
    
    // MARK: - Sample Data
    /// 디자인 검증을 위한 더미 스티커 데이터 세트
    private let closetItems: [ClosetItem] = [
        ClosetItem(assetName: "Top1", category: .top),
        ClosetItem(assetName: "Top2", category: .top),
        ClosetItem(assetName: "Top3", category: .top),
        
        ClosetItem(assetName: "Bottom1", category: .bottom),
        ClosetItem(assetName: "Bottom2", category: .bottom),
        ClosetItem(assetName: "Bottom3", category: .bottom),
        
        ClosetItem(assetName: "Accessories1", category: .accessories),
        ClosetItem(assetName: "Accessories2", category: .accessories),
        ClosetItem(assetName: "Accessories3", category: .accessories)
    ]
    
    var body: some View {
        ZStack {
            // [LAYER 1] 메인 배경지 영역
            // 디바이스별 해상도 대응: 고유 비율을 유지하며 가로를 꽉 채우고, 넘치는 상하는 자동 컷팅합니다.
            GeometryReader { geometry in
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }
            .ignoresSafeArea()
            
            // [LAYER 2] 전면 UI 콘텐츠 스택
            VStack(spacing: 0) {
                // 1. 상단 글로벌 헤더 (고정 높이: 182)
                ClosetHeaderView(
                    onAddTap: { print("추가 버튼 클릭됨") },
                    onNotificationTap: { print("알림 버튼 클릭됨") },
                    onProfileTap: { print("프로필 버튼 클릭됨") },
                    onReturnTap: { print("돌려주기 버튼 클릭됨") }
                )
                
                // 2. 메인 옷장 일러스트 및 내부 프레임 (378 x 642)
                ZStack(alignment: .center) {
                    // 기하학적 밑바탕이 되는 옷장 가구 일러스트
                    Image("Closet")
                        .resizable()
                        .frame(width: 378, height: 642)
                    
                    // 옷장 가구 내부에 정확하게 포개어지는 투명 정렬 프레임 (357 x 550)
                    VStack(spacing: 0) {
                        VStack(spacing: 9) { // 각 내부 요소(섹션3개, 하단 버튼) 간격: 9
                            ForEach(ClosetCategory.allCases, id: \.self) { category in
                                closetSectionView(for: category)
                            }
                            
                            // 공통 UI 컴포넌트: 옷장 전체 보기 버튼
                            PrimaryButton(title: "옷장 전체 보기") {
                                print("옷장 전체 보기 클릭됨")
                            }
                        }
                        .padding(.horizontal, 12) // 투명 프레임 내 좌우 패딩: 12
                        .padding(.vertical, 10)   // 투명 프레임 내 상하 패딩: 10
                    }
                    .frame(width: 357, height: 550)
                    .offset(y: -15) // 시각적 밸런스를 맞추기 위해 투명 프레임을 위로 약간 이동
                }
                
                // 3. 하단 페이지 점 인디케이터
                pageIndicator
                    .offset(y: -25) // 옷장 하단 디자인 프레임과 자연스럽게 겹치도록 상향 조정
                    .zIndex(1)      // 배경 뒤로 숨지 않도록 레이어 최상단 고정
                
                Spacer()
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}

// MARK: - Private Extension (Subviews 명세)
private extension ClosetView {
    
    /// 개별 옷장 행거 칸을 구성하는 섹션 카드 컴포넌트
    func closetSectionView(for category: ClosetCategory) -> some View {
        ZStack(alignment: .topLeading) {
            // [섹션 배경]: 고정 수치 대신 컨테이너 부모 프레임에 맞춰 유연하게 확장
            Image("ClosetSection")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // [카테고리 타이틀]: 디자인 시스템 규격 및 요구 명세 오프셋 적용
            Text(category.rawValue)
                .bodyBoldStyle()
                .padding(.leading, 8)
                .padding(.top, 8)
            
            // [콘텐츠 레이어]: 옷 스티커 그리드 및 우측 내비게이션 바
            ZStack(alignment: .trailing) {
                // 옷 스티커 가로 스택 영역
                HStack(spacing: 4) { // 요구사항: 각 스티커 간격 4 고정
                    let items = closetItems.filter { $0.category == category }
                    ForEach(items) { item in
                        Button(action: {
                            print("\(item.assetName) 클릭됨 - 상세 페이지로 이동")
                        }) {
                            Image(item.assetName)
                                .resizable()
                                .frame(width: 89, height: 103) // 요구사항: 가로 89, 세로 103 고정
                        }
                    }
                }
                .padding(.leading, 16)
                .padding(.trailing, 46) // 우측 고정 인그리디언츠 영역(46) 확보를 위한 우측 마진
                .padding(.top, 22)      // 옷걸이 봉 일러스트 라인 아래로 옷을 맞추기 위한 상단 마진
                
                // 우측 고정 인그리디언츠(더보기) 영역
                HStack(spacing: 0) {
                    ZStack(alignment: .trailing) {
                        // 그라디언트 페이드: 좌측 투명(0.0) -> 최고 우측 지정 에셋 customWhite 백그라운드 80%(0.8)
                        LinearGradient(
                            stops: [
                                .init(color: Color("customWhite").opacity(0.0), location: 0.0),
                                .init(color: Color("customWhite").opacity(0.8), location: 1.0)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: 46)
                        
                        // 공통 UI 컴포넌트 재사용: 핑크색 원형 화살표 버튼 (파라미터 타입 에러 반영 완료)
                        PrimaryIconButton(icon: Image(systemName: "chevron.right")) {
                            print("\(category.rawValue) 섹션 더보기 페이지로 이동")
                        }
                        .frame(width: 20, height: 20) // 규격 20x20 제한
                        .padding(.trailing, 8)       // 우측 벽면 여백 8 고정
                    }
                }
                .frame(width: 46)
                .clipShape(RoundedRectangle(cornerRadius: 5)) // 요구사항: 인그리디언츠 구역 모서리 5 라운딩
            }
        }
    }
    
    /// 하단 페이지 제어용 도트 인디케이터
    var pageIndicator: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color("gray20"))
                .frame(width: 8, height: 8)
            Circle()
                .fill(Color("customBlack"))
                .frame(width: 8, height: 8)
            Circle()
                .fill(Color("gray20"))
                .frame(width: 8, height: 8)
        }
    }
}

// MARK: - Header View (상단 영역 컴포넌트)
/// 상단 알림, 프로필, 공유 옷장 텍스트 정보 및 돌려주기 버튼을 포함하는 헤더 뷰
struct ClosetHeaderView: View {
    var onAddTap: () -> Void
    var onNotificationTap: () -> Void
    var onProfileTap: () -> Void
    var onReturnTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 62) // 최상단 노치 영역 마진 확보
            
            // 상단 우측 기능 버튼 모음 트레이
            HStack(spacing: 0) {
                Spacer()
                
                HStack(spacing: 0) {
                    HStack(spacing: 24) {
                        Button(action: onAddTap) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .regular))
                                .foregroundStyle(Color("customBlack"))
                        }
                        
                        Button(action: onNotificationTap) {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 20, weight: .regular))
                                .foregroundStyle(Color("customBlack"))
                        }
                    }
                    .padding(.horizontal, 20)
                    .frame(height: 44)
                    .background(Color("customWhite").opacity(0.8))
                    .clipShape(Capsule())
                    .shadow(color: Color("customBlack").opacity(0.05), radius: 8, x: 0, y: 4)
                    
                    Spacer()
                        .frame(width: 10)
                    
                    Button(action: onProfileTap) {
                        Image("MyProfile")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                    }
                }
            }
            .frame(height: 44)
            
            Spacer()
                .frame(height: 10)
            
            // 하단 타이틀 정보 및 돌려주기 버튼 섹션
            HStack(alignment: .bottom, spacing: 0) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("공유 옷장")
                        .font(.appTitle)
                        .bold()
                        .foregroundStyle(Color("customBlack"))
                    
                    Text("첫째 언니")
                        .font(.appSubtitle)
                        .foregroundStyle(Color("gray60"))
                }
                
                Spacer()
                
                OutlineButton(title: "↩︎ 돌려주기", action: onReturnTap)
                    .frame(height: 47)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .frame(height: 56)
            
            Spacer()
                .frame(height: 10)
        }
        .frame(height: 182)
        .padding(.horizontal, 20)
    }
}

// MARK: - Preview
#Preview {
    ClosetView()
}
