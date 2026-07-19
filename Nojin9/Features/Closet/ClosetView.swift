//
//  ClosetView.swift
//  Nojin9
//
//  Created by 김가은 on 7/15/26.
//

import SwiftUI

// ==========================================
// MARK: - 1. DATA MODELS & ENUMS
// ==========================================

/// 옷장 내부에 배치될 개별 옷 스티커 아이템 모델
struct ClosetItem: Identifiable {
    var id: String { assetName } // RentalMockData의 Key값과 1:1 매핑
    let assetName: String        // 이미지 에셋 이름
    let category: ClosetCategory
}

/// 옷장 카테고리 구분을 위한 열거형
enum ClosetCategory: String, CaseIterable {
    case top = "상의"
    case bottom = "하의"
    case accessories = "기타"
}

// ==========================================
// MARK: - 2. MAIN VIEW
// ==========================================

struct ClosetView: View {
    
    // [Navigation] 상세 화면(RentalView)으로 전환할 때 클릭된 아이템의 ID를 라우팅 경로에 보관합니다.
    @State private var navigationPath: [String] = []
    
    // [Mock Data] 옷장 메인 화면을 구성하는 기본 더미 스티커 데이터 세트
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
        // 내비게이션 스택을 사용하여 하위 뷰(RentalView)로의 전환을 제어합니다.
        NavigationStack(path: $navigationPath) {
            ZStack {
                // [LAYER 1] 메인 배경지 영역
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
                    // [파트 A] 상단 글로벌 헤더 (알림, 프로필, 타이틀 및 돌려주기)
                    ClosetHeaderView(
                        onAddTap: { print("추가 버튼 클릭됨") },
                        onNotificationTap: { print("알림 버튼 클릭됨") },
                        onProfileTap: { print("프로필 버튼 클릭됨") },
                        onReturnTap: { print("돌려주기 버튼 클릭됨") }
                    )
                    
                    // [파트 B] 메인 옷장 가구 & 옷 행거 섹션 프레임
                    ZStack(alignment: .center) {
                        Image("Closet")
                            .resizable()
                            .frame(width: 378, height: 642)
                        
                        VStack(spacing: 0) {
                            VStack(spacing: 9) {
                                // 상의/하의/기타 섹션을 반복문으로 생성
                                ForEach(ClosetCategory.allCases, id: \.self) { category in
                                    closetSectionView(for: category)
                                }
                                
                                PrimaryButton(title: "옷장 전체 보기") {
                                    print("옷장 전체 보기 클릭됨")
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                        }
                        .frame(width: 357, height: 550)
                        .offset(y: -15)
                    }
                    
                    // [파트 C] 하단 페이지 도트 인디케이터
                    pageIndicator
                        .offset(y: -25)
                        .zIndex(1)
                    
                    Spacer()
                }
            }
            .ignoresSafeArea(edges: .top)
            
            .navigationDestination(for: String.self) { itemID in
                RentalView(itemID: itemID)
            }
        }
    }
}

// ==========================================
// MARK: - 3. SUBVIEWS (COMPONENTS)
// ==========================================

private extension ClosetView {
    
    /// 개별 옷장 행거 칸을 구성하는 섹션 카드 컴포넌트 (상의/하의/기타)
    func closetSectionView(for category: ClosetCategory) -> some View {
        ZStack(alignment: .topLeading) {
            // 섹션 배경 그래픽
            Image("ClosetSection")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // 카테고리 타이틀 (상의, 하의, 기타)
            Text(category.rawValue)
                .bodyBoldStyle()
                .padding(.leading, 8)
                .padding(.top, 8)
            
            ZStack(alignment: .trailing) {
                // [스티커 리스트] 해당 카테고리에 속한 옷 스티커들을 가로로 나열
                HStack(spacing: 4) {
                    let items = closetItems.filter { $0.category == category }
                    ForEach(items) { item in
                        Button(action: {
                            // 💡 스티커를 터치하면 대여 상세 페이지(RentalView)로 화면을 전환합니다.
                            navigationPath.append(item.assetName)
                        }) {
                            Image(item.assetName)
                                .resizable()
                                .frame(width: 89, height: 103)
                        }
                    }
                }
                .padding(.leading, 16)
                .padding(.trailing, 46) // 우측 더보기 영역 공간 확보
                .padding(.top, 22)
                
                // [우측 더보기 바] 우측 그라디언트 페이드 및 이동 버튼
                HStack(spacing: 0) {
                    ZStack(alignment: .trailing) {
                        LinearGradient(
                            stops: [
                                .init(color: Color("customWhite").opacity(0.0), location: 0.0),
                                .init(color: Color("customWhite").opacity(0.8), location: 1.0)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: 46)
                        
                        PrimaryIconButton(icon: Image(systemName: "chevron.right")) {
                            print("\(category.rawValue) 섹션 더보기 페이지로 이동")
                        }
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 8)
                    }
                }
                .frame(width: 46)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            }
        }
    }
    
    /// 하단 페이지 제어용 도트 인디케이터
    var pageIndicator: some View {
        HStack(spacing: 8) {
            Circle().fill(Color("gray20")).frame(width: 8, height: 8)
            Circle().fill(Color("customBlack")).frame(width: 8, height: 8)
            Circle().fill(Color("gray20")).frame(width: 8, height: 8)
        }
    }
}

// ==========================================
// MARK: - 4. GLOBAL HEADER VIEW
// ==========================================

/// 상단 알림, 프로필, 공유 옷장 정보 및 돌려주기 버튼을 포함하는 독립 헤더 컴포넌트
struct ClosetHeaderView: View {
    var onAddTap: () -> Void
    var onNotificationTap: () -> Void
    var onProfileTap: () -> Void
    var onReturnTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 62) // 상단 상태바/노치 안전 영역 확보
            
            // 상단 우측 퀵 버튼 트레이 (추가, 알림, 프로필)
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
                    
                    Spacer().frame(width: 10)
                    
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
            
            Spacer().frame(height: 10)
            
            // 하단 타이틀 텍스트 & 돌려주기 버튼
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
            Spacer().frame(height: 10)
        }
        .frame(height: 182)
        .padding(.horizontal, 20)
    }
}

// ==========================================
// MARK: - 5. PREVIEW
// ==========================================

#Preview {
    ClosetView()
}
