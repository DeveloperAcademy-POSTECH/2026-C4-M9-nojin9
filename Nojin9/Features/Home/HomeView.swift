import Foundation
import SwiftUI

private enum ReviewRoute: Hashable {
    case allReview
    case itemSelection
    case writing(rentalId: UUID, itemId: UUID)
}

struct HomeView: View {
    @EnvironmentObject private var store: AppDataStore

    @State private var isUploadViewPresented = false
    @State private var isUnavailableClosetAlertPresented = false
    @State private var isMyPageViewPresented = false
    @State private var isReturnViewPresented = false
    @State private var isClosetAllViewPresented = false
    @State private var reviewPath = NavigationPath()
    @State private var selectedClosetOwnerId: UUID?
    @State private var selectedClosetOwnerName = ""
    @State private var selectedClosetCategory: MyClosetCategory = .all

    @State private var isRentalViewPresented = false
    @State private var selectedRentalItem: ClothItem?
    @State private var selectedClosetPage = 1
    @State private var currentReviewIndex = 0

    private let thankYouLetterPreviews: [HomeThankYouLetterPreview] = [
        HomeThankYouLetterPreview(authorName: "서은", imageName: "ThanksReview_1_1"),
        HomeThankYouLetterPreview(authorName: "현서", imageName: "ThanksReview_2_1"),
        HomeThankYouLetterPreview(authorName: "서은", imageName: "ThanksReview_3_1"),
        HomeThankYouLetterPreview(authorName: "현서", imageName: "ThanksReview_4_1"),
        HomeThankYouLetterPreview(authorName: "서은", imageName: "ThanksReview_5_1"),
        HomeThankYouLetterPreview(authorName: "현서", imageName: "ThanksReview_6_1")
    ]

    var body: some View {
        NavigationStack(path: $reviewPath) {
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    backgroundView

                    TabView(selection: $selectedClosetPage) {
                        closetPage(
                            mainTitle: "내 옷장",
                            subTitle: "내가 받은 감사 편지",
                            showsReview: true,
                            showsReturnButton: false,
                            showsPointStatus: true,
                            usesSmallClosetStyle: true,
                            ownerId: store.currentUser?.id,
                            ownerName: "내 옷장",
                            items: myClosetItems
                        )
                        .tag(0)

                        closetPage(
                            mainTitle: "공유 옷장",
                            subTitle: "첫째 언니",
                            showsReview: false,
                            showsReturnButton: true,
                            showsPointStatus: false,
                            usesSmallClosetStyle: false,
                            ownerId: store.sisters.indices.contains(0)
                                ? store.sisters[0].id
                                : nil,
                            ownerName: "첫째 언니의 옷장",
                            items: sisterClosetItems(index: 0)
                        )
                        .tag(1)

                        closetPage(
                            mainTitle: "공유 옷장",
                            subTitle: "둘째 언니",
                            showsReview: false,
                            showsReturnButton: true,
                            showsPointStatus: false,
                            usesSmallClosetStyle: false,
                            ownerId: store.sisters.indices.contains(1)
                                ? store.sisters[1].id
                                : nil,
                            ownerName: "둘째 언니의 옷장",
                            items: sisterClosetItems(index: 1)
                        )
                        .tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .padding(.top, topContentInset(for: geometry))
                    .padding(.bottom, bottomContentInset(for: geometry))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    topMenuView
                        .padding(.top, toolbarTopInset(for: geometry))
                        .frame(maxWidth: .infinity)
                        .frame(height: toolbarTopInset(for: geometry) + 72, alignment: .bottom)
                        .zIndex(2)

                    pageIndicator
                        .frame(height: 24)
                        .padding(.bottom, 10)
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height,
                            alignment: .bottom
                        )
                        .zIndex(2)
                }
            }
            .navigationDestination(
                isPresented: $isUploadViewPresented
            ) {
                UploadView()
            }
            .navigationDestination(
                isPresented: $isMyPageViewPresented
            ) {
                MyPageView()
            }
            .navigationDestination(
                isPresented: $isReturnViewPresented
            ) {
                ReturnView {
                    isReturnViewPresented = false
                }
            }
            .navigationDestination(
                isPresented: $isRentalViewPresented
            ) {
                if let selectedRentalItem {
                    RentalView(
                        clothItemId: selectedRentalItem.id
                    )
                }
            }
            .navigationDestination(
                isPresented: $isClosetAllViewPresented
            ) {
                if let selectedClosetOwnerId {
                    MyClosetAllView(
                        ownerId: selectedClosetOwnerId,
                        ownerName: selectedClosetOwnerName,
                        initialCategory: selectedClosetCategory
                    )
                }
            }
            .navigationDestination(for: ReviewRoute.self) { route in
                switch route {
                case .allReview:
                    AllReviewView(
                        onMoveToWriteReview: {
                            reviewPath.append(ReviewRoute.itemSelection)
                        },
                        onMoveToHome: {
                            reviewPath.removeLast()
                        }
                    )

                case .itemSelection:
                    ReviewItemSelectionView(
                        onStartWriting: { rental, item in
                            reviewPath.append(
                                ReviewRoute.writing(
                                    rentalId: rental.id,
                                    itemId: item.id
                                )
                            )
                        },
                        onMoveToHome: {
                            reviewPath = NavigationPath()
                        }
                    )

                case let .writing(rentalId, itemId):
                    if let rental = store.rental(id: rentalId),
                       let item = store.clothItem(id: itemId) {
                        ReviewWritingView(
                            rental: rental,
                            item: item,
                            onMoveToReviewList: {
                                // 작성 화면 한 단계만 제거
                                // → ReviewItemSelectionView로 돌아감
                                reviewPath.removeLast()
                            },
                            onMoveToHome: {
                                // 리뷰 관련 화면을 전부 제거
                                // → HomeView로 돌아감
                                reviewPath = NavigationPath()
                            }
                        )
                    }
                }
            }
        }
    }

    private func topContentInset(for geometry: GeometryProxy) -> CGFloat {
        toolbarTopInset(for: geometry) + 72
    }

    private func toolbarTopInset(for geometry: GeometryProxy) -> CGFloat {
        0
    }

    private func bottomContentInset(for geometry: GeometryProxy) -> CGFloat {
        geometry.safeAreaInsets.bottom + 42
    }

    private var myClosetItems: HomeClosetItems {
        guard let currentUser = store.currentUser else {
            return fallbackClosetItems
        }

        let items = closetItems(ownerId: currentUser.id)
        return normalizedClosetItems(items)
    }

    private var fallbackClosetItems: HomeClosetItems {
        HomeClosetItems(
            topItems: [],
            bottomItems: [],
            otherItems: []
        )
    }

    private func sisterClosetItems(index: Int) -> HomeClosetItems {
        guard store.sisters.indices.contains(index) else {
            return fallbackClosetItems
        }

        let items = closetItems(ownerId: store.sisters[index].id)
        return normalizedClosetItems(items)
    }

    private func closetItems(ownerId: UUID) -> HomeClosetItems {
        HomeClosetItems(
            topItems: store.clothItems(category: .top, ownerId: ownerId),
            bottomItems: store.clothItems(category: .bottom, ownerId: ownerId),
            otherItems: store.clothItems(category: .accessory, ownerId: ownerId)
        )
    }

    private func normalizedClosetItems(_ items: HomeClosetItems) -> HomeClosetItems {
        return items
    }

    private var backgroundView: some View {
        ZStack {
            Image("Background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }

    private var topMenuView: some View {
        ToolbarUI(
            mode: .home,
            onAdd: {
                isUploadViewPresented = true
            },
            onLetter: {
                reviewPath.append(ReviewRoute.allReview)
            },
            onProfile: {
                isMyPageViewPresented = true
            }
        )
    }

    private func closetPage(
        mainTitle: String,
        subTitle: String?,
        showsReview: Bool,
        showsReturnButton: Bool,
        showsPointStatus: Bool,
        usesSmallClosetStyle: Bool,
        ownerId: UUID?,
        ownerName: String,
        items: HomeClosetItems
    ) -> some View {
        GeometryReader { geometry in
            let headerHeight = pageHeaderHeight(
                hasSubTitle: subTitle != nil,
                showsReturnButton: showsReturnButton
            )
            let closetHeight = closetHeight(
                availableHeight: geometry.size.height,
                headerHeight: headerHeight,
                showsReview: showsReview,
                usesSmallClosetStyle: usesSmallClosetStyle
            )

            VStack(alignment: .leading, spacing: 0) {
                pageHeader(
                    mainTitle: mainTitle,
                    subTitle: subTitle,
                    headerHeight: headerHeight,
                    showsReturnButton: showsReturnButton,
                    showsPointStatus: showsPointStatus
                )

                if showsReview {
                    reviewView
                        .padding(.top, 10)
                        .padding(.bottom, 24)
                } else {
                    Spacer()
                        .frame(height: 16)
                }

                centeredClosetView(
                    items: items,
                    targetHeight: closetHeight,
                    ownerId: ownerId,
                    ownerName: ownerName,
                    usesSmallClosetStyle: usesSmallClosetStyle
                )
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .top
            )
        }
    }

    private func closetHeight(
        availableHeight: CGFloat,
        headerHeight: CGFloat,
        showsReview: Bool,
        usesSmallClosetStyle: Bool
    ) -> CGFloat {
        let reviewHeight: CGFloat = showsReview ? 154 : 0
        let headerToClosetGap: CGFloat = showsReview ? 0 : 16
        let availableClosetHeight = availableHeight - headerHeight - reviewHeight - headerToClosetGap
        let closetMaxHeight: CGFloat = usesSmallClosetStyle ? 466.67 : 542.14
        let closetMinHeight: CGFloat = usesSmallClosetStyle ? 360 : 390

        return min(closetMaxHeight, max(closetMinHeight, availableClosetHeight))
    }

    private func pageHeaderHeight(
        hasSubTitle: Bool,
        showsReturnButton: Bool
    ) -> CGFloat {
        if showsReturnButton {
            return 94
        }

        return hasSubTitle ? 86 : 46
    }

    private func pageHeader(
        mainTitle: String,
        subTitle: String?,
        headerHeight: CGFloat,
        showsReturnButton: Bool,
        showsPointStatus: Bool
    ) -> some View {
        HStack(alignment: .bottom, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(mainTitle)
                    .font(.appTitle)
                    .foregroundStyle(Color("customBlack"))

                if let subTitle {
                    Text(subTitle)
                        .font(.system(size: 24))
                        .foregroundStyle(.secondary)
                }
            }

            Spacer(minLength: 0)

            if showsPointStatus {
                pointStatusView
            }

            if showsReturnButton {
                OutlineButton(title: "↩︎ 돌려주기") {
                    isReturnViewPresented = true
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .frame(height: headerHeight, alignment: .bottom)
    }

    private var pointStatusView: some View {
        HStack(spacing: 6) {
            Image("Coin")
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)

            Text(formatNumber(store.currentUser?.point ?? 0))
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color("customBlack"))
        }
        .padding(.bottom, 2)
    }

    private var reviewView: some View {
        reviewScrollView
    }

    private var reviewScrollView: some View {
        GeometryReader { geometry in
            let leadingPadding: CGFloat = 16
            let trailingPadding: CGFloat = 16
            let trailingFadeWidth: CGFloat = 56
            let contentWidth = geometry.size.width - leadingPadding - trailingPadding
            let cardSize = contentWidth / 3

            ScrollViewReader { proxy in
                ZStack(alignment: .trailing) {
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 0) {
                            ForEach(Array(thankYouLetterPreviews.enumerated()), id: \.element.id) { index, preview in
                                ThankYouLetterPreviewCardView(
                                    preview: preview,
                                    cardSize: cardSize
                                )
                                .id(index)
                                .frame(width: cardSize, height: cardSize)
                            }
                        }
                    }
                    .scrollIndicators(.hidden)

                    ZStack {
                        LinearGradient(
                            colors: [
                                Color.customWhite.opacity(0),
                                Color.customWhite
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: trailingFadeWidth, height: cardSize)

                        PrimaryIconButton(
                            icon: Image(systemName: "chevron.right")
                        ) {
                            moveToNextReview(using: proxy)
                        }
                    }
                }
                .padding(.leading, leadingPadding)
                .padding(.trailing, trailingPadding)
                .frame(height: cardSize)
                .clipped()
            }
        }
        .frame(height: 120)
    }

    private func moveToNextReview(
        using proxy: ScrollViewProxy
    ) {
        guard !thankYouLetterPreviews.isEmpty else {
            return
        }

        if currentReviewIndex < thankYouLetterPreviews.count - 1 {
            currentReviewIndex += 1
        } else {
            currentReviewIndex = 0
        }

        withAnimation(.easeInOut(duration: 0.3)) {
            proxy.scrollTo(
                currentReviewIndex,
                anchor: .center
            )
        }
    }

    private func centeredClosetView(
        items: HomeClosetItems,
        targetHeight: CGFloat,
        ownerId: UUID?,
        ownerName: String,
        usesSmallClosetStyle: Bool
    ) -> some View {
        let closetBaseWidth: CGFloat = 356.4
        let closetBaseHeight: CGFloat = usesSmallClosetStyle ? 466.67 : 542.14
        let scale = targetHeight / closetBaseHeight
        let targetWidth = closetBaseWidth * scale

        return HStack {
            Spacer(minLength: 0)

            closetView(
                items: items,
                ownerId: ownerId,
                ownerName: ownerName,
                usesSmallClosetStyle: usesSmallClosetStyle
            )
            .scaleEffect(scale, anchor: .top)
            .frame(
                width: targetWidth,
                height: targetHeight,
                alignment: .top
            )

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity)
        .frame(height: targetHeight, alignment: .top)
        .clipped()
    }

    private func closetView(
        items: HomeClosetItems,
        ownerId: UUID?,
        ownerName: String,
        usesSmallClosetStyle: Bool
    ) -> some View {
        let closetBaseWidth: CGFloat = 356.4
        let closetBaseHeight: CGFloat = usesSmallClosetStyle ? 466.67 : 542.14

        return ZStack {
            Image(usesSmallClosetStyle ? "MyClosetSmall" : "MyCloset")
                .resizable()
                .scaledToFit()
                .frame(width: closetBaseWidth, height: closetBaseHeight)

            VStack(spacing: usesSmallClosetStyle ? 12 : 0) {
                MyClosetSectionView(
                    title: "상의",
                    items: items.topItems,
                    onItemTap: { item in
                        selectedRentalItem = item
                        isRentalViewPresented = true
                    }
                ) {
                    guard let ownerId else {
                        return
                    }
                    
                    selectedClosetOwnerId = ownerId
                    selectedClosetOwnerName = ownerName
                    selectedClosetCategory = .top
                    isClosetAllViewPresented = true
                }
                .frame(width: 307, height: 136)

                MyClosetSectionView(
                    title: "하의",
                    items: items.bottomItems,
                    onItemTap: { item in
                        selectedRentalItem = item
                        isRentalViewPresented = true
                    }
                ) {
                    guard let ownerId else {
                        return
                    }
                    
                    selectedClosetOwnerId = ownerId
                    selectedClosetOwnerName = ownerName
                    selectedClosetCategory = .bottom
                    isClosetAllViewPresented = true
                }
                .frame(width: 307, height: 136)

                if !usesSmallClosetStyle {
                    MyClosetSectionView(
                        title: "기타",
                        items: items.otherItems,
                        onItemTap: { item in
                            selectedRentalItem = item
                            isRentalViewPresented = true
                        }
                    ) {
                        guard let ownerId else {
                            return
                        }
                        
                        selectedClosetOwnerId = ownerId
                        selectedClosetOwnerName = ownerName
                        selectedClosetCategory = .other
                        isClosetAllViewPresented = true
                    }
                    .frame(width: 307, height: 124)
                }

                MyClosetButton(title: "옷장 전체 보기") {
                    guard let ownerId else {
                        return
                    }

                    selectedClosetOwnerId = ownerId
                    selectedClosetOwnerName = ownerName
                    selectedClosetCategory = .all
                    isClosetAllViewPresented = true
                }
                .padding(.top, usesSmallClosetStyle ? 2 : 8.87)
            }
            .padding(.top, usesSmallClosetStyle ? 0 : 0)
            .padding(.bottom, usesSmallClosetStyle ? 30 : 30)
        }
        .frame(width: closetBaseWidth, height: closetBaseHeight)
    }

    private func formatNumber(_ num: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: num)) ?? "\(num)"
    }

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(index == selectedClosetPage ? Color("customBlack") : Color("gray20"))
                    .frame(width: 8, height: 8)
            }
        }
    }
}

private struct HomeClosetItems {
    let topItems: [ClothItem]
    let bottomItems: [ClothItem]
    let otherItems: [ClothItem]

    var isEmpty: Bool {
        topItems.isEmpty && bottomItems.isEmpty && otherItems.isEmpty
    }
}

private struct HomeThankYouLetterPreview: Identifiable {
    var id: String {
        imageName
    }

    let authorName: String
    let imageName: String
}

private struct ReviewAuthorBadgeView: View {
    let authorName: String

    var body: some View {
        Text(authorName)
            .font(.system(size: 12, weight: .bold))
            .foregroundStyle(Color("customWhite"))
            .frame(width: 32, height: 32)
            .background(Color("gray40"))
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(Color("customWhite"), lineWidth: 1.2)
            }
    }
}

private struct ThankYouLetterThumbnailView: View {
    let imageName: String
    let size: CGFloat

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

private struct ThankYouLetterPreviewCardView: View {
    let preview: HomeThankYouLetterPreview
    let cardSize: CGFloat

    var body: some View {
        ThankYouLetterThumbnailView(
            imageName: preview.imageName,
            size: max(cardSize - 8, CGFloat.zero)
        )
            .overlay(alignment: .topLeading) {
                ReviewAuthorBadgeView(authorName: preview.authorName)
                    .padding(.top, 4)
                    .padding(.leading, 4)
            }
            .frame(width: cardSize, height: cardSize, alignment: .leading)
    }
}

#Preview {
    HomeView()
        .environmentObject(AppDataStore())
}
