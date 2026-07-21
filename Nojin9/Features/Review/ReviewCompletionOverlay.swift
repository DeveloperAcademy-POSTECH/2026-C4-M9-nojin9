//
//  ReviewCompletionOverlay.swift
//  Nojin9
//
//  Created by 김가은 on 7/21/26.
//

import SwiftUI

struct ReviewCompletionOverlay: View {
    @Environment(\.dismiss) private var dismiss
    @State private var stickerScale: CGFloat = 0.5

    var body: some View {
        ZStack {
            Color.black.opacity(0.78)
                .ignoresSafeArea()

            VStack {
                Spacer()

                completionSticker

                Spacer()

                VStack(spacing: 8) {
                    Button {
                        // 감사 편지 목록 화면으로 이동하도록 추후 연결
                        dismiss()
                    } label: {
                        Text("감사 편지 리스트로 가기")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 46)
                            .background(Color.pink)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }

                    Button {
                        // 현재 NavigationStack 구조에 따라
                        // 홈으로 이동하는 상태값과 연결
                        dismiss()
                    } label: {
                        Text("홈으로 돌아가기")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.pink)
                            .frame(maxWidth: .infinity)
                            .frame(height: 46)
                            .background(Color.pink.opacity(0.13))
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 22)
            }
        }
    }

    private var completionSticker: some View {
        ZStack {
            Image("ReviewCompleteSticker")
                .resizable()
                .scaledToFit()
                .frame(width: 280, height: 280)
                .scaleEffect(stickerScale)
            }
        }
    }

#Preview {
    NavigationStack {
        ReviewItemSelectionView()
            .environmentObject(AppDataStore())
    }
}
