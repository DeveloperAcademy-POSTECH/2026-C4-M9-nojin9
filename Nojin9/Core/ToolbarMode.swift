//
//  ToolbarUI.swift
//  Nojin9
//
//  Created by 김가은 on 7/18/26.
//

import SwiftUI

// MARK: - ToolbarMode

enum ToolbarMode {
    case home
    case rental
    case returnRequest
    case returnConfirm

    var title: String? {
        switch self {
        case .home:
            return nil

        case .rental:
            return "빌려오기"

        case .returnRequest:
            return "돌려주기"

        case .returnConfirm:
            return "반납하기"
        }
    }

    var showsBackButton: Bool {
        switch self {
        case .home:
            return false

        case .rental,
             .returnRequest,
             .returnConfirm:
            return true
        }
    }
}

// MARK: - ToolbarUI

struct ToolbarUI: View {
    let mode: ToolbarMode

    let onBack: () -> Void
    let onAdd: () -> Void
    let onNotification: () -> Void
    let onProfile: () -> Void

    init(
        mode: ToolbarMode,
        onBack: @escaping () -> Void = {},
        onAdd: @escaping () -> Void = {},
        onNotification: @escaping () -> Void = {},
        onProfile: @escaping () -> Void = {}
    ) {
        self.mode = mode
        self.onBack = onBack
        self.onAdd = onAdd
        self.onNotification = onNotification
        self.onProfile = onProfile
    }

    var body: some View {
        ZStack {
            centerTitle

            HStack {
                leadingContent

                Spacer()

                trailingContent
            }
        }
        .frame(height: 72)
        .padding(.horizontal, 20)
    }

    // MARK: - 가운데 제목

    @ViewBuilder
    private var centerTitle: some View {
        if let title = mode.title {
            Text(title)
                .font(.headline)
                .foregroundStyle(.customBlack)
        }
    }

    // MARK: - 왼쪽 영역

    @ViewBuilder
    private var leadingContent: some View {
        if mode.showsBackButton {
            BackButton {
                onBack()
            }
        }
    }

    // MARK: - 오른쪽 영역

    @ViewBuilder
    private var trailingContent: some View {
        switch mode {
        case .home:
            homeMenu

        case .rental,
             .returnRequest,
             .returnConfirm:
            EmptyView()
        }
    }

    // MARK: - 홈 메뉴

    private var homeMenu: some View {
        HStack(spacing: 10) {
            HStack(spacing: 20) {
                Button(action: onAdd) {
                    Image(systemName: "plus")
                        .foregroundStyle(.customBlack)
                        .frame(width: 36, height: 36)
                }
                
                Button(action: onNotification) {
                    Image(systemName: "bell.fill")
                        .foregroundStyle(.customBlack)
                        .frame(width: 36, height: 36)
                }
            }
            .frame(width: 104, height: 44)
            .background {
                Capsule()
                    .fill(Color.white.opacity(0.9))
            }
            .shadow(
                color: .black.opacity(0.05),radius: 10, x: 0, y: 4)
            
            Button(action: onProfile) {
                Image("MyProfile")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
            }
        }
    }
}

// MARK: - Preview

#Preview("홈") {
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

#Preview("빌려오기") {
    ToolbarUI(
        mode: .rental,
        onBack: {
            print("뒤로가기")
        }
    )
}

#Preview("돌려주기") {
    ToolbarUI(
        mode: .returnRequest,
        onBack: {
            print("뒤로가기")
        }
    )
}
