//
//  ClosetView.swift
//  Nojin9
//
//  Created by 김가은 on 7/15/26.
//

import SwiftUI

struct MyClosetView: View {
    @State private var isUploadViewPresented = false
    @State private var currentReviewIndex = 0
    
    private let topItems = [
        "Top1",
        "Top2",
        "Top3",
        "Top1","Top1","Top1","Top1","Top1"
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
        NavigationStack{
            ZStack {
                backgroundView
                VStack{
                    topMenuView
                    
                    reviewView
                    
                    closetView
                    
                }
                
                
            }
            .navigationDestination(
                isPresented: $isUploadViewPresented
            ){
                UploadView()
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
            HStack{
                Text("내 옷장")
                    .font(.appTitle)
                    .padding(.leading, 16)
                
                
                
                HStack(spacing: 200) {
                    ToolbarUI(
                        mode: .home,
                        onAdd: {
                            isUploadViewPresented = true
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
    }
    
    // MARK: - 리뷰
    private let reviewCount = 5
    
    private var reviewView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("내가 받은 리뷰")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
                .padding(.leading, 18)
            
            reviewScrollView
                .padding(.top, 12.28)
                .padding(.bottom, 10.88)
        }
    }
    
    // MARK: - 리뷰 가로 스크롤
    
    private var reviewScrollView: some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .trailing) {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(0..<reviewCount, id: \.self) { index in
                            NoteButton {
                                // index 번째 리뷰를 눌렀을 때 실행
                            }
                            .frame(width: 99.83)
                            .id(index)
                            .padding(.horizontal, 3)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                
                ZStack {
                    LinearGradient(
                        colors: [
                            Color.customWhite.opacity(0),
                            Color.customWhite
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: 40, height: 100)
                    
                    PrimaryIconButton(
                        icon: Image(systemName: "chevron.right")
                    ) {
                        moveToNextReview(using: proxy)
                    }
                }
            }
            .frame(height: 100)
            .clipped()
        }
        .padding(.leading, 23)
        .padding(.trailing, 58.83)
    }
    
    // MARK: - 다음 리뷰로 이동
    
    private func moveToNextReview(
        using proxy: ScrollViewProxy
    ) {
        guard reviewCount > 0 else {
            return
        }
        
        if currentReviewIndex < reviewCount - 1 {
            currentReviewIndex += 1
        } else {
            currentReviewIndex = 0
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            proxy.scrollTo(
                currentReviewIndex,
                anchor: .center
            )
        }
    }
    
    
    // MARK: - 옷장 전체
    
    private var closetView: some View {
        ZStack {
            Image("MyCloset")
                .resizable()
                .scaledToFit()
                .frame(width: 356.4,height: 542.14)
            
            
            VStack(spacing: 0) {
                MyClosetSectionView(
                    title: "상의",
                    imageNames: topItems
                ) {
                    print("상의 더보기")
                }
                .frame(width: 307, height: 136)
                
                MyClosetSectionView(
                    title: "하의",
                    imageNames: bottomItems
                ) {
                    print("하의 더보기")
                }
                .frame(width: 307, height: 136)
                
                MyClosetSectionView(
                    title: "기타",
                    imageNames: otherItems
                ) {
                    print("기타 더보기")
                }
                .frame(width: 307, height: 124)
                
                MyClosetButton(title: "옷장 전체 보기") {
                }
                .padding(.top, 8.87)
            }
            .padding(.bottom, 30)
        }
        
    }
    
}



#Preview {
    MyClosetView()
}
