//
//  ReviewCompletionOverlay.swift
//  Nojin9
//
//  Created by 김가은 on 7/21/26.
//

import SwiftUI

struct ReviewCompletionOverlay: View {
    let onMoveToReviewList: () -> Void
    let onMoveToHome: () -> Void

    @State private var stickerScale: CGFloat = 0.5
    @State private var stickerOpacity: Double = 0

    var body: some View {
        ZStack {
            Color.black.opacity(0.78)
                .ignoresSafeArea()

            VStack {
                Spacer()

                completionSticker

                Spacer()

                actionButtons
            }
        }
        .onAppear {
            withAnimation(
                .spring(
                    response: 0.45,
                    dampingFraction: 0.65
                )
            ) {
                stickerScale = 1
                stickerOpacity = 1
            }
        }
    }

    // MARK: - 완료 스티커

    private var completionSticker: some View {
        Image("ReviewCompleteSticker")
            .resizable()
            .scaledToFit()
            .frame(width: 280, height: 280)
            .scaleEffect(stickerScale)
            .opacity(stickerOpacity)
    }

    // MARK: - 하단 버튼

    private var actionButtons: some View {
        VStack(spacing: 8) {
            Button {
                onMoveToReviewList()
            } label: {
                Text("감사 편지 리스트로 가기")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.customWhite)
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .background(.brandPrimary)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 5)
                    )
            }

            Button {
                onMoveToHome()
            } label: {
                Text("홈으로 돌아가기")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.brandPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 47)
                    .background(.brandPrimary10)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 5)
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 22)
    }
}

#Preview {
    ReviewCompletionOverlay(
        onMoveToReviewList: {
            print("감사 편지 리스트로 이동")
        },
        onMoveToHome: {
            print("홈으로 이동")
        }
    )
}
