//
//  ReviewRentalRow.swift
//  Nojin9
//
//  Created by 김가은 on 7/21/26.
//

import SwiftUI

struct ReviewRentalRow: View {
    let rental: Rental
    let item: ClothItem
    let isSelected: Bool
    let action: () -> Void

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        return formatter
    }()
    
    private var itemImage: some View {
        ZStack {
            Color.pink.opacity(0.12)

            if let imageName = item.cutoutImageName ?? item.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .padding(7)
            } else {
                Image(systemName: "tshirt")
                    .foregroundStyle(.gray)
            }
        }
        .frame(width: 48, height: 48)
        .clipShape(RoundedRectangle(cornerRadius: 2))
    }

    private var selectionIcon: some View {
        ZStack {
            Circle()
                .stroke(
                    isSelected
                    ? Color.pink
                    : Color.gray.opacity(0.4),
                    lineWidth: 1
                )
                .frame(width: 18, height: 18)

            if isSelected {
                Circle()
                    .fill(Color.pink)
                    .frame(width: 18, height: 18)

                Image(systemName: "checkmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
    }
    
    private var rentalPeriodText: String {
        let startDate = dateFormatter.string(from: rental.borrowedAt)

        guard let dueAt = rental.dueAt else {
            return "\(startDate) ~ 반납일 미정"
        }

        let endDate = dateFormatter.string(from: dueAt)
        return "\(startDate) ~ \(endDate)"
    }
    
    // MARK: - 리뷰 쓰기 화면
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                itemImage

                VStack(alignment: .leading, spacing: 7) {
                    Text(item.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.customBlack)

                    Text(rentalPeriodText)
                        .font(.system(size: 12))
                        .foregroundStyle(.gray60)
                }

                Spacer()

                selectionIcon
            }
            .padding(10)
            .background(Color.white)
            .overlay {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(
                        isSelected
                        ? Color.pink
                        : Color.gray.opacity(0.2),
                        lineWidth: isSelected ? 1.5 : 1
                    )
            }
        }
        .buttonStyle(.plain)
    }

    
}

#Preview {
    ReviewRentalRow(
        rental: MockData.snapshot.rentals.first!,
        item: MockData.snapshot.clothItems.first!,
        isSelected: true,
        action: {}
    )
    .padding()
}
