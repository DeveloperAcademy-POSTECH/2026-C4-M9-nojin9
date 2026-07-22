//
//  MyPageView.swift
//  Nojin9
//
//  Created by 김가은 on 7/15/26.
//

//
//  MyPageView.swift
//  Nojin9
//
//  Created by 김가은 on 7/15/26.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject private var store: AppDataStore
    @State private var isReturnViewPresented = false

    private let menuItems = [
        "최근 본 상품",
        "추천과 초대코드 입력",
        "고객센터",
        "공지사항",
        "개인정보처리방침",
        "서비스 이용 약관"
    ]

    private var currentUser: User? {
        store.currentUser
    }

    private var profileImageName: String {
        currentUser?.profileImageName ?? "MyProfile"
    }

    private var displayName: String {
        currentUser?.name ?? "사용자"
    }

    private var rentalHistoryCount: Int {
        let currentUserId = store.snapshot.userSession.currentUserId
        return store.snapshot.rentals.filter {
            $0.borrowerId == currentUserId
        }.count
    }

    private var pointText: String {
        "\(formatNumber(currentUser?.point ?? 0))P"
    }

    var body: some View {
        ZStack {
            backgroundView
            
            VStack{
                profileView
                activitySummaryView
                dividerView
                menuListView
                accountButtonView
            }
            .padding(.top, 8)
        }
        .navigationTitle("마이페이지")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationDestination(
            isPresented: $isReturnViewPresented
        ) {
            ReturnView {
                isReturnViewPresented = false
            }
        }
    }

    // MARK: - 배경

    private var backgroundView: some View {
        ZStack {
            Color.customWhite.ignoresSafeArea()

            Image("Background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }

    // MARK: - 프로필

    private var profileView: some View {
        HStack(spacing: 12) {
            Image(profileImageName)
                .resizable()
                .scaledToFill()
                .frame(width: 44, height: 44)
                .clipShape(Circle())

            Text(displayName)
                .font(.system(size: 19, weight: .bold))
                .foregroundStyle(Color.customBlack)

            Spacer()

            Button {
                print("프로필 설정")
            } label: {
                HStack(spacing: 8) {
                    Text("프로필 설정")
                        .font(.system(size: 15, weight: .medium))

                    Image(systemName: "chevron.right")
                        .font(.system(size: 16))
                }
                .foregroundStyle(Color.customBlack)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 28)
        .padding(.bottom, 18)
    }

    // MARK: - 활동 요약

    private var activitySummaryView: some View {
        HStack(spacing: 0) {
            MyPageSummaryItem(
                icon: "calendar",
                title: "대여/반납",
                value: "\(rentalHistoryCount)개"
            ) {
                isReturnViewPresented = true
            }

            MyPageSummaryItem(
                icon: "square.and.pencil",
                title: "내가 쓴 리뷰",
                value: "5개"
            ) {
                print("내가 쓴 리뷰")
            }

            MyPageSummaryItem(
                icon: "heart.circle",
                title: "포인트",
                value: pointText
            ) {
                print("포인트")
            }
        }
        .padding(.vertical, 21)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(.brandPrimary10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(.brandPrimary, lineWidth: 1)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 18)
    }
    
    // MARK: - 구분 영역

    private var dividerView: some View {
        Color.gray5
            .frame(height: 10)
    }

    // MARK: - 메뉴 목록

    private var menuListView: some View {
        VStack(spacing: 0) {
            ForEach(menuItems, id: \.self) { menu in
                Button {
                    handleMenuTap(menu)
                } label: {
                    HStack {
                        Text(menu)
                            .font(.system(size: 17))
                            .foregroundStyle(Color.customBlack)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(Color.gray60)
                    }
                    .frame(height: 58)
                    .contentShape(Rectangle())
                }

                Divider()
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - 로그아웃 및 회원탈퇴

    private var accountButtonView: some View {
        HStack(spacing: 36) {
            Button("로그아웃") {
                print("로그아웃")
            }

            Button("회원탈퇴") {
                print("회원탈퇴")
            }
        }
        .font(.system(size: 14, weight: .medium))
        .foregroundStyle(Color.customBlack)
        .padding(.top, 75)
        .padding(.bottom, 40)
    }

    private func handleMenuTap(_ menu: String) {
        switch menu {
        case "최근 본 상품":
            print("최근 본 상품")
        case "추천과 초대코드 입력":
            print("추천과 초대코드 입력")
        case "고객센터":
            print("고객센터")
        case "공지사항":
            print("공지사항")
        case "개인정보처리방침":
            print("개인정보처리방침")
        case "서비스 이용 약관":
            print("서비스 이용 약관")
        default:
            break
        }
    }

    private func formatNumber(_ num: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: num)) ?? "\(num)"
    }
}

// MARK: - 활동 요약 아이템

private struct MyPageSummaryItem: View {
    let icon: String
    let title: String
    let value: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 7) {
                Image(systemName: icon)
                    .font(.system(size: 29, weight: .medium))
                    .frame(height: 32)
                    .foregroundStyle(.brandPrimary)
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.customBlack)
                Text(value)
                    .font(.system(size: 13))
                    .foregroundStyle(.brandPrimary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    NavigationStack {
        MyPageView()
    }
    .environmentObject(AppDataStore())
}
