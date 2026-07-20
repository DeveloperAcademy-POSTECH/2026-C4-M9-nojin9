//
//  ReturnView.swift
//  Nojin9
//
//  Created by 김가은 on 7/20/26.
//


import SwiftUI

struct ReturnView: View {
    @EnvironmentObject private var store: AppDataStore
    @Environment(\.dismiss) private var dismiss

    private var activeRentals: [Rental] {
        store.snapshot.rentals
            .filter {
                $0.borrowerId == store.snapshot.userSession.currentUserId
                && $0.status == .borrowed
            }
            .sorted {
                ($0.dueAt ?? .distantFuture) < ($1.dueAt ?? .distantFuture)
            }
    }

    private var overdueRentals: [Rental] {
        activeRentals.filter { rental in
            guard let dueAt = rental.dueAt else { return false }
            return dueAt < Date()
        }
    }

    private var upcomingRentals: [Rental] {
        activeRentals.filter { rental in
            guard let dueAt = rental.dueAt else { return true }
            return dueAt >= Date()
        }
    }

    var body: some View {
        ZStack {
            backgroundView
            VStack(spacing: 0) {
                navigationBar
                    .padding(.bottom, 16)

                VStack(spacing: 0) {
                    if activeRentals.isEmpty {
                        emptyView
                    } else {
                        rentalSection(
                            title: "연체 물품",
                            rentals: overdueRentals
                        )

                        if !overdueRentals.isEmpty && !upcomingRentals.isEmpty {
                            Divider()
                                .padding(.vertical, 20)
                        }

                        rentalSection(
                            title: "돌려주기 예정",
                            rentals: upcomingRentals
                        )
                    }
                }
                .padding(.horizontal, 16)
            }


        }
        .navigationBarBackButtonHidden()
    }

    private var backgroundView: some View {
        Image("Background")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }

    private var navigationBar: some View {
        ToolbarUI(
            mode: .returnRequest,
            onBack: {
                print("뒤로가기")
            }
        )
    }

    @ViewBuilder
    private func rentalSection(
        title: String,
        rentals: [Rental]
    ) -> some View {
        if !rentals.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.system(size: 22, weight: .bold))

                ForEach(rentals) { rental in
                    if let item = store.clothItem(id: rental.clothItemId) {
                        ReturnItemCard(
                            rental: rental,
                            item: item
                        )
                    }
                }
            }
        }
    }

    private var emptyView: some View {
        VStack(spacing: 14) {
            Image(systemName: "shippingbox")
                .font(.system(size: 42))
                .foregroundStyle(.gray)

            Text("돌려줄 물품이 없어요")
                .font(.system(size: 18, weight: .semibold))

            Text("대여 중인 물품이 생기면 여기에 표시돼요.")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 150)
    }
}

#Preview {
    NavigationStack {
        ReturnView()
            .environmentObject(AppDataStore())
    }
}
