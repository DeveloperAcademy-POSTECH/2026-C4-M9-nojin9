//
//  ReviewItemSelectionView.swift
//  Nojin9
//
//  Created by 김가은 on 7/21/26.
//

import SwiftUI

struct ReviewItemSelectionView: View {
    @EnvironmentObject private var store: AppDataStore
    @Environment(\.dismiss) private var dismiss

    let onMoveToHome: () -> Void

    @State private var selectedRentalId: UUID?

    // MARK: - 화면 이동 및 데이터 전달을 위한 State
    @State private var isShowingWritingView = false
    @State private var targetRental: Rental?
    @State private var targetItem: ClothItem?

    private var selectedRental: Rental? {
        store.reviewableRentals.first {
            $0.id == selectedRentalId
        }
    }

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("편지를 작성할 물품을 선택해주세요.")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)

                    if store.reviewableRentals.isEmpty {
                        emptyView
                    } else {
                        rentalList
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 18)

                Spacer()

                nextButton
            }
        }
        .navigationTitle("감사 편지 작성하기")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }


    private var rentalList: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(store.reviewableRentals) { rental in
                    if let item = store.clothItem(id: rental.clothItemId) {
                        ReviewRentalRow(
                            rental: rental,
                            item: item,
                            isSelected: selectedRentalId == rental.id
                        ) {
                            selectedRentalId = rental.id
                        }
                    }
                }
            }
        }
    }

    private var emptyView: some View {
        VStack(spacing: 12) {
            Spacer()

            Image(systemName: "envelope")
                .font(.system(size: 44))
                .foregroundStyle(.gray.opacity(0.5))

            Text("감사 편지를 작성할 수 있는\n반납 완료 물품이 없어요.")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private var nextButton: some View {
        Button {
            guard let rental = selectedRental,
                  let item = store.clothItem(id: rental.clothItemId) else {
                return
            }

            // 전달할 데이터를 저장하고 화면 이동 트리거
            targetRental = rental
            targetItem = item
            isShowingWritingView = true

        } label: {
            Text("작성하기")
                .font(.appButton)
                .foregroundStyle(.customWhite)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    selectedRental == nil
                        ? Color.gray20
                        : Color.brandPrimary
                )
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .frame(width: 332, height: 46)
        .disabled(selectedRental == nil)
        // MARK: - 네비게이션 목적지 설정
        .navigationDestination(isPresented: $isShowingWritingView) {
            if let rental = targetRental, let item = targetItem {
                ReviewWritingView(
                    rental: rental,
                    item: item,
                    onMoveToReviewList: {
                        isShowingWritingView = false
                        dismiss() // 리뷰 작성 완료 후 선택화면도 닫기
                    },
                    onMoveToHome: onMoveToHome
                )
            }
        }
    }
    
    private func moveToHome() {
        onMoveToHome()
    }
}

#Preview {
    NavigationStack {
        ReviewItemSelectionView(
            onMoveToHome: {
                print("홈으로 이동")
            }
        )
        .environmentObject(
            AppDataStore(snapshot: MockData.snapshot)
        )
    }
}
