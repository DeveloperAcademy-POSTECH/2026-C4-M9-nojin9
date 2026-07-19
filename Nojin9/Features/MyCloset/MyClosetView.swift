//
//  ClosetView.swift
//  Nojin9
//
//  Created by 김가은 on 7/15/26.
//

import SwiftUI

struct MyClosetView: View {
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
        ZStack {
            backgroundView
            VStack{
                topMenuView
                
                reviewView
                
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
            HStack{
                Text("내 옷장")
                    .font(.appTitle)
                    .padding(.leading, 16)
                
                
                
                HStack(spacing: 200) {
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
    }
    
    // MARK: - 리뷰
    private var reviewView: some View {
        VStack{
            Text("내가 받은 리뷰")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
                .padding(.leading, 18)
                .padding(.trailing, 286)
            HStack {
                NoteButton {
                }
                .frame(width: 99.83)
                
                NoteButton {
                }
                .frame(width: 99.83)

                NoteButton {
                }
                .frame(width: 99.83)
            }
            .padding(.top, 12.28)
            .padding(.bottom, 10.88)
            
            
        }
    }
    
    //    }
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
