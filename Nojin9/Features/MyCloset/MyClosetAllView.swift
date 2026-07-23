//
//  MyClosetAllView.swift
//  Nojin9
//
//  Created by 김가은 on 7/21/26.
//

import SwiftUI

struct MyClosetAllView: View {
    @EnvironmentObject private var store: AppDataStore

    let ownerId: UUID
    let ownerName: String

    @State private var selectedCategory: MyClosetCategory
    @State private var selectedRentalItem: ClothItem?
    @State private var isRentalViewPresented = false

    private let itemsPerRow = 3

    init(ownerId: UUID, ownerName: String, initialCategory: MyClosetCategory = .all) {
        self.ownerId = ownerId
        self.ownerName = ownerName
        self._selectedCategory = State(initialValue: initialCategory)
    }

    var body: some View {
        ZStack {
            backgroundView

            VStack(spacing: 0) {
                categoryButtons
                    .padding(.top, 12)
                    .padding(.bottom, 14)

                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(
                            Array(itemRows.enumerated()),
                            id: \.offset
                        ) { _, rowItems in
                            closetRow(rowItems)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 30)
                }
                .scrollIndicators(.hidden)
            }
        }
        .navigationTitle(ownerName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationDestination(
            isPresented: $isRentalViewPresented
        ) {
            if let selectedRentalItem {
                RentalView(
                    clothItemId: selectedRentalItem.id
                )
            }
        }
    }
    
    private func activeRental(
        for item: ClothItem
    ) -> Rental? {
        let rentals = store.rentals(for: item.id)

        return rentals.first { rental in
            rental.status == RentalStatus.borrowed
        }
    }
    
    private func borrowedRentalByCurrentUser(
        for item: ClothItem
    ) -> Rental? {
        guard let currentUserId = store.currentUser?.id else {
            return nil
        }

        let rentals: [Rental] = store.rentals(for: item.id)

        return rentals.first { rental -> Bool in
            let isBorrowed = rental.status == RentalStatus.borrowed
            let isCurrentUser = rental.borrowerId == currentUserId

            return isBorrowed && isCurrentUser
        }
    }
    
    private func dueDateText(
        for rental: Rental
    ) -> String {
        guard let dueAt = rental.dueAt else {
            return ""
        }

        return dueAt.formatted(
            .dateTime
                .month(.defaultDigits)
                .day(.defaultDigits)
        )
    }

    private var myItems: [ClothItem] {
        let topItems = store.clothItems(
            category: .top,
            ownerId: ownerId
        )

        let bottomItems = store.clothItems(
            category: .bottom,
            ownerId: ownerId
        )

        let accessoryItems = store.clothItems(
            category: .accessory,
            ownerId: ownerId
        )

        return topItems + bottomItems + accessoryItems
    }

    private var filteredItems: [ClothItem] {
        switch selectedCategory {
        case .all:
            return myItems

        case .top:
            return myItems.filter {
                $0.category == .top
            }

        case .bottom:
            return myItems.filter {
                $0.category == .bottom
            }

        case .other:
            return myItems.filter {
                $0.category == .accessory
            }
        }
    }

    private var itemRows: [[ClothItem]] {
        filteredItems.chunked(into: itemsPerRow)
    }

    private var backgroundView: some View {
        Image("Background")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .frame(width: .infinity, height: 300)
    }

    private var categoryButtons: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(
                    MyClosetCategory.allCases,
                    id: \.self
                ) { category in
                    categoryButton(category)
                }
            }
            .padding(.horizontal, 20)
        }
        .scrollIndicators(.hidden)
    }

    private func categoryButton(
        _ category: MyClosetCategory
    ) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedCategory = category
            }
        } label: {
            Text(category.title)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(
                    selectedCategory == category
                    ? Color("customWhite")
                    : Color("customBlack")
                )
                .padding(.horizontal, 20)
                .frame(height: 38)
                .background(
                    selectedCategory == category
                    ? Color("brandPrimary")
                    : Color("customWhite")
                )
                .clipShape(Capsule())
                .overlay {
                    if selectedCategory != category {
                        Capsule()
                            .stroke(
                                Color("gray20"),
                                lineWidth: 1
                            )
                    }
                }
        }
        .buttonStyle(.plain)
    }

    private func closetRow(
        _ items: [ClothItem]
    ) -> some View {
        ZStack {
            Image("ClosetFullView")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 154)
                .clipped()

            HStack(spacing: 0) {
                ForEach(items) { item in
                    clothItemButton(item)
                        .frame(maxWidth: .infinity)
                }

                if items.count < itemsPerRow {
                    ForEach(
                        0..<(itemsPerRow - items.count),
                        id: \.self
                    ) { _ in
                        Color.clear
                            .frame(maxWidth: .infinity)
                            .frame(height: 120)
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 10)
        }
        .frame(height: 154)
        .clipShape(
            RoundedRectangle(cornerRadius: 6)
        )
    }

    private func clothItemButton(
        _ item: ClothItem
    ) -> some View {
        Button {
            selectedRentalItem = item
            isRentalViewPresented = true
        } label: {
            ZStack {
                clothImage(item)
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .padding(.horizontal, 4)

                if let rental = borrowedRentalByCurrentUser(for: item) {
                    borrowedSticker(rental: rental)
                        .offset(x: -5, y: 18)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 125)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func clothImage(
        _ item: ClothItem
    ) -> some View {
        if let imageName = item.cutoutImageName ?? item.imageName {
            ClothImageView(imageName: imageName)
                .scaledToFit()
                .padding(6)
        } else {
            Image(systemName: "tshirt")
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color("gray40"))
                .padding(28)
        }
    }

    // MARK: - Sticker

    private func borrowedSticker(
        rental: Rental
    ) -> some View {
        let dateText = dueDateText(for: rental)

        return Text(
            dateText.isEmpty
            ? "빌린 옷"
            : "빌린 옷~\(dateText)"
        )
        .font(.system(size: 12, weight: .bold))
        .foregroundStyle(Color("customWhite"))
        .padding(.horizontal, 9)
        .frame(height: 34)
        .background(Color("brandPrimary"))
        .clipShape(
            RoundedRectangle(cornerRadius: 3)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 3)
                .stroke(
                    Color("customWhite"),
                    lineWidth: 2
                )
        }
        .rotationEffect(.degrees(-7))
    }
}

enum MyClosetCategory: CaseIterable {
    case all
    case top
    case bottom
    case other

    var title: String {
        switch self {
        case .all:
            return "전체"

        case .top:
            return "상의"

        case .bottom:
            return "하의"

        case .other:
            return "기타"
        }
    }
}

private extension Array {
    func chunked(
        into size: Int
    ) -> [[Element]] {
        guard size > 0 else {
            return []
        }

        return stride(
            from: 0,
            to: count,
            by: size
        ).map { startIndex in
            let endIndex = Swift.min(
                startIndex + size,
                count
            )

            return Array(
                self[startIndex..<endIndex]
            )
        }
    }
}

#Preview {
    NavigationStack {
        MyClosetAllView(
            ownerId: AppDataStore().currentUser?.id ?? UUID(),
            ownerName: "내 옷장"
        )
        .environmentObject(AppDataStore())
    }
}
