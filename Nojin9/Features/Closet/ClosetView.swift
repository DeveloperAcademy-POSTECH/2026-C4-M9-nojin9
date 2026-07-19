//
//  ClosetView.swift
//  Nojin9
//
//  Created by 김가은 on 7/15/26.
//

import SwiftUI

struct ClosetView: View {
    @EnvironmentObject private var store: AppDataStore

    private let categories: [ClothCategory] = [.top, .bottom, .accessory]

    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { geometry in
                    Image("Background")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    ClosetHeaderView(
                        onAddTap: { print("추가 버튼 클릭됨") },
                        onNotificationTap: { print("알림 버튼 클릭됨") },
                        onProfileTap: { print("프로필 버튼 클릭됨") },
                        onReturnTap: { print("돌려주기 버튼 클릭됨") }
                    )

                    ZStack(alignment: .center) {
                        Image("Closet")
                            .resizable()
                            .frame(width: 378, height: 642)

                        VStack(spacing: 0) {
                            VStack(spacing: 9) {
                                ForEach(categories, id: \.rawValue) { category in
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

                    pageIndicator
                        .offset(y: -25)
                        .zIndex(1)

                    Spacer()
                }
            }
            .ignoresSafeArea(edges: .top)
            .navigationBarHidden(true)
        }
    }
}

private extension ClosetView {
    func closetSectionView(for category: ClothCategory) -> some View {
        ZStack(alignment: .topLeading) {
            Image("ClosetSection")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            Text(category.displayName)
                .bodyBoldStyle()
                .padding(.leading, 8)
                .padding(.top, 8)

            ZStack(alignment: .trailing) {
                HStack(spacing: 4) {
                    ForEach(items(for: category)) { item in
                        NavigationLink {
                            RentalView(clothItemId: item.id)
                        } label: {
                            Image(item.imageName ?? item.name)
                                .resizable()
                                .frame(width: 89, height: 103)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.leading, 16)
                .padding(.trailing, 46)
                .padding(.top, 22)

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
                            print("\(category.displayName) 섹션 더보기 페이지로 이동")
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

    func items(for category: ClothCategory) -> [ClothItem] {
        store.clothItems(category: category)
    }

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

struct ClosetHeaderView: View {
    var onAddTap: () -> Void
    var onNotificationTap: () -> Void
    var onProfileTap: () -> Void
    var onReturnTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 62)

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

#Preview {
    ClosetView()
        .environmentObject(AppDataStore())
}
