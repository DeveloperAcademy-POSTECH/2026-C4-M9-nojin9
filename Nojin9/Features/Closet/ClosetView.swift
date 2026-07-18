//
//  ClosetView.swift
//  Nojin9
//
//  Created by 김가은 on 7/15/26.
//

import SwiftUI

struct ClosetView: View {
    private let topItems = [
        "Top1",
        "Top2",
        "Top3"
    ]
    
    private let bottomItems = [
        "Bottom1",
        "Bottom2",
        "Bottom3"
    ]
    
    private let otherItems = [
        "Accessories1",
        "Accessories2",
        "Accessories3"
    ]
    
    var body: some View {
        ZStack {
            backgroundView
            VStack{
                topMenuView
                
                titleView
                
                closetView
                
            }
            
        }
    }
    
    // MARK: - 배경
    
    private var backgroundView: some View {
        ZStack{
            Image("Background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
        }
    }
    
    
    
    // MARK: - 상단 메뉴
    
    private var topMenuView: some View {
        ZStack {
            HStack(spacing: 20) {
                ToolbarUI(
                    mode: .home,
                    onAdd: {
                        print("옷 추가")
                    },
                    onNotification: {
                        print("알림")
                    },
                    onProfile: {
                        print("프로필")
                    }
                )
            }
        }
    }
    
    // MARK: - 제목
    
    private var titleView: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 0) {
                Text("공유 옷장")
                    .font(.appTitle)
                
                
                Text("첫째 언니")
                    .font(.system(size: 24))
                    .foregroundStyle(.secondary)
            }
            .padding(.leading, 24)
            
            Spacer()
            
            OutlineButton(title: "􀱍 돌려주기") {
            }
            .padding(.trailing, 24)
        }
    }
    
    
    // MARK: - 옷장 전체
    
    private var closetView: some View {
        ZStack() {
            
            Image("Closet")
                .resizable()
                .scaledToFill()
                .frame(width: 378,height: 642)
                .clipped()
            VStack(spacing: 9) {
                ClosetSectionView(
                    title: "상의",
                    imageNames: topItems
                ) {
                    print("상의 더보기")
                }
                
                ClosetSectionView(
                    title: "하의",
                    imageNames: bottomItems
                ) {
                    print("하의 더보기")
                }
                
                ClosetSectionView(
                    title: "기타",
                    imageNames: otherItems
                ) {
                    print("기타 더보기")
                }
                
                PrimaryButton(title: "옷장 전체 보기") {
                }
            }
            
        }
        
    }
    
}
    // TODO: - 페이지 표시
    
   

#Preview {
    ClosetView()
}
