//
//  ClosetSectionView.swift
//  Nojin9
//
//  Created by 김가은 on 7/18/26.
//

import SwiftUI

/// 옷장 카테고리 한 줄을 담당하는 뷰
struct MyClosetSectionView: View {
    let title: String
    let items: [ClothItem]
    let onItemTap: (ClothItem) -> Void

    /// 카테고리 전체 보기 화면으로 이동할 때 사용
    let action: () -> Void

    /// 현재 화살표 버튼으로 이동한 이미지 위치
    @State private var currentIndex = 0

    var body: some View {
        ZStack{
            Image("MyClosetSection")
                .resizable()
            VStack(alignment: .leading, spacing: 0) {
                titleView
                
                divider
                
                clothesScrollView
                    .padding(.top, 3)
            }
            
        }
    
    }

    // MARK: - 제목

    private var titleView: some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.black)
        }
        .padding(.horizontal, 10)
            .padding(.top, 8)
            .padding(.bottom, 4)
    }

    // MARK: - 구분선

    private var divider: some View {
        Rectangle()
            .fill(.black)
            .frame(height: 2)
    }

    // MARK: - 가로 스크롤

    private var clothesScrollView: some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .trailing) {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(
                            Array(items.enumerated()),
                            id: \.element.id
                        ) { index, item in
                            Button {
                                onItemTap(item)
                            } label: {
                                MyClothThumbnailView(item: item)
                            }
                            .buttonStyle(.plain)
                            .id(index)
                        }
                    }
                }
                .scrollIndicators(.hidden)

                ZStack {
                    LinearGradient(
                        colors: [Color.customWhite.opacity(0), Color.customWhite],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: 60)

                    PrimaryIconButton(
                        icon: Image(systemName: "chevron.right")
                    ) {
                        moveToNextItem(using: proxy)
                    }
                }
            }
            .clipped()
        }
    }

    // MARK: - 다음 이미지로 이동

    private func moveToNextItem(
        using proxy: ScrollViewProxy
    ) {
        guard !items.isEmpty else {
            return
        }

        if currentIndex < items.count - 1 {
            currentIndex += 1
        } else {
            currentIndex = 0
        }

        withAnimation(.easeInOut(duration: 0.3)) {
            proxy.scrollTo(
                currentIndex,
                anchor: .center
            )
        }
    }
}

#Preview {
    MyClosetSectionView(
        title: "상의",
        items: Array(MockData.clothItems.prefix(3)),
        onItemTap: { _ in }
    ) {}
}
