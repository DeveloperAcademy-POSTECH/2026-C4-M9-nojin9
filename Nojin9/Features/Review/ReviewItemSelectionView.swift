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

    @State private var selectedRentalId: UUID?
    @State private var selectedItem: ClothItem?
    @State private var isWritingPresented = false

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
                navigationBar

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
        .navigationBarBackButtonHidden()
    }

    private var navigationBar: some View {
        ZStack {
            Text("감사 편지 작성하기")
                .font(.system(size: 15, weight: .medium))

            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.customBlack)
                        .frame(width: 40, height: 40)
                        .background(.customWhite)
                        .clipShape(Circle())
                        .shadow(color: .customBlack.opacity(0.08), radius: 8, y: 3)
                }

                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
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

            selectedItem = item
            isWritingPresented = true
        } label: {
            Text("작성하기")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.customWhite)
                .frame(maxWidth: .infinity)
                .frame(height: 47)
                .background(
                    selectedRental == nil
                        ? Color.gray20
                        : Color.brandPrimary
                )
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .disabled(selectedRental == nil)
        .navigationDestination(
            isPresented: $isWritingPresented
        ) {
            if let rental = selectedRental,
               let item = selectedItem {
                ReviewWritingView(
                    rental: rental,
                    item: item,
                    onHomeButtonTapped: {
                        moveToHome()
                    }
                )
            }
        }
    }
    
    private func moveToHome() {
        dismiss()
    }
}

#Preview {
    NavigationStack {
        ReviewItemSelectionView()
            .environmentObject(AppDataStore(snapshot: MockData.snapshot))
    }
}
