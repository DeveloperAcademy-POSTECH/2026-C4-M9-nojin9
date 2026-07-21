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

    private var displayedItems: [ClothItem] {
        Array(items.prefix(3))
    }

    var body: some View {
        ZStack{
            Image("MyClosetSection")
                .resizable()
            VStack(alignment: .leading, spacing: 0) {
                titleView
                
                divider
                
                clothesPreviewView
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

    // MARK: - 옷 미리보기

    private var clothesPreviewView: some View {
        ZStack(alignment: .trailing) {
            HStack(spacing: 4) {
                ForEach(displayedItems) { item in
                    Button {
                        onItemTap(item)
                    } label: {
                        MyClothThumbnailView(item: item)
                            .scaleEffect(0.86)
                            .frame(width: 82, height: 82)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.leading, 8)
            .frame(maxWidth: .infinity, alignment: .leading)

            PrimaryIconButton(
                icon: Image(systemName: "chevron.right")
            ) {
                action()
            }
        }
        .clipped()
    }
}

#Preview {
    MyClosetSectionView(
        title: "상의",
        items: Array(MockData.clothItems.prefix(3)),
        onItemTap: { _ in }
    ) {}
}
