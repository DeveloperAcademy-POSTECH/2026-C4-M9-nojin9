//
//  ReturnItemCard.swift
//  Nojin9
//
//  Created by 김가은 on 7/20/26.
//

import SwiftUI

struct ReturnItemCard: View {
    let rental: Rental
    let item: ClothItem
    let onReturn: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            itemInformation

            HStack(spacing: 8) {
                Button {
                    print("편지 작성하기")
                } label: {
                    Text("편지 작성하기")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.brandPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 47)
                        .background(.brandPrimary10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.brandPrimary, lineWidth: 1)
                        }
                }

                Button {
                    onReturn()
                } label: {
                    Text("돌려주기")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.customWhite)
                        .frame(maxWidth: .infinity)
                        .frame(height: 47)
                        .background(.brandPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 14)
        }
        .padding(12)
        .background(.customWhite)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
    private var itemInformation: some View {
        HStack(spacing: 12) {
            itemImage

            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    Text(item.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.customBlack)

                    Spacer()

                    Text(dDayText)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(dDayColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(dDayColor.opacity(0.12))
                        .clipShape(Capsule())
                }

                Text(rentalPeriodText)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private var itemImage: some View {
        ZStack {
            Color.brandPrimary10

            if let imageName = item.cutoutImageName ?? item.imageName {
                ClothImageView(imageName: imageName)
                    .scaledToFit()
                    .padding(12)
            } else {
                Image(systemName: "tshirt")
                    .font(.system(size: 32))
                    .foregroundStyle(.gray60)
            }
        }
        .frame(width: 82, height: 82)
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }

    private var rentalPeriodText: String {
        let start = rental.borrowedAt.returnDateText
        let end = rental.dueAt?.returnDateText ?? "미정"

        return "\(start) ~ \(end)"
    }

    private var dDayText: String {
        guard let dueAt = rental.dueAt else {
            return "기한 미정"
        }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dueDate = calendar.startOfDay(for: dueAt)

        let difference = calendar.dateComponents(
            [.day],
            from: today,
            to: dueDate
        ).day ?? 0

        if difference < 0 {
            return "D+\(abs(difference))"
        }

        if difference == 0 {
            return "D-Day"
        }

        return "D-\(difference)"
    }

    private var dDayColor: Color {
        guard let dueAt = rental.dueAt else {
            return .customBlack
        }

        return dueAt < Date() ? .brandPrimary : .secondary
    }
}

extension Date {
    var returnDateText: String {
        formatted(
            .dateTime
                .year(.twoDigits)
                .month(.twoDigits)
                .day(.twoDigits)
        )
    }
}

#Preview {
    ReturnItemCard(
        rental: MockData.rentals[1],
        item: MockData.clothItems[4],
        onReturn: {}
    )
}
