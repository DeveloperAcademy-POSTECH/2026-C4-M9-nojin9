import Foundation
import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: AppDataStore

    @State private var isUploadViewPresented = false
    @State private var isClosetViewPresented = false
    @State private var isMyPageViewPresented = false
    @State private var selectedClosetPage = 1
    @State private var currentReviewIndex = 0

    private let reviewCount = 5
    private let debugYMarkers: [CGFloat] = [
        0, 44, 72, 88, 100, 116, 128, 144, 160, 200
    ]

    private let fallbackTopItems = [
        "Top1",
        "Top2",
        "Top3",
        "Top1", "Top1", "Top1", "Top1", "Top1"
    ]

    private let fallbackBottomItems = [
        "Bottom1",
        "Bottom2",
        "Bottom3"
    ]

    private let fallbackOtherItems = [
        "Accessories1",
        "Accessories2",
        "Accessories3"
    ]

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    backgroundView

                    TabView(selection: $selectedClosetPage) {
                        closetPage(
                            mainTitle: "내 옷장",
                            subTitle: nil,
                            showsReview: true,
                            showsReturnButton: false,
                            items: myClosetItems
                        )
                        .tag(0)

                        closetPage(
                            mainTitle: "공유 옷장",
                            subTitle: "첫째 언니",
                            showsReview: false,
                            showsReturnButton: true,
                            items: sisterClosetItems(index: 0)
                        )
                        .tag(1)

                        closetPage(
                            mainTitle: "공유 옷장",
                            subTitle: "둘째 언니",
                            showsReview: false,
                            showsReturnButton: true,
                            items: sisterClosetItems(index: 1)
                        )
                        .tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .background(Color.blue.opacity(0.12))
                    .overlay(alignment: .topLeading) {
                        debugLabel("TABVIEW CONTENT")
                    }
                    .padding(.top, topContentInset(for: geometry))
                    .padding(.bottom, bottomContentInset(for: geometry))
                    .background(Color.purple.opacity(0.12))
                    .overlay(alignment: .topLeading) {
                        debugLabel("TABVIEW PADDED")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    topMenuView
                        .background(Color.red.opacity(0.22))
                        .overlay(alignment: .topLeading) {
                            debugLabel("TOOLBAR ACTUAL")
                        }
                        .padding(.top, toolbarTopInset(for: geometry))
                        .background(Color.orange.opacity(0.20))
                        .overlay(alignment: .topLeading) {
                            debugLabel("TOP PADDING")
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: toolbarTopInset(for: geometry) + 72, alignment: .bottom)
                        .background(Color.yellow.opacity(0.18))
                        .overlay(alignment: .topLeading) {
                            debugLabel("TOP FINAL FRAME")
                        }
                        .zIndex(2)

                    VStack {
                        Spacer()

                        pageIndicator
                            .frame(height: 24)
                            .padding(.bottom, max(10, geometry.safeAreaInsets.bottom + 10))
                            .background(Color.green.opacity(0.22))
                            .overlay(alignment: .topLeading) {
                                debugLabel("PAGE INDICATOR")
                            }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.08))
                    .overlay(alignment: .topLeading) {
                        debugLabel("INDICATOR OVERLAY")
                    }
                    .zIndex(2)

                    debugRuler
                        .zIndex(9)

                    debugMetricsPanel(geometry: geometry)
                        .zIndex(10)
                }
            }
            .navigationDestination(
                isPresented: $isUploadViewPresented
            ) {
                UploadView()
            }
            .navigationDestination(
                isPresented: $isClosetViewPresented
            ) {
                ClosetView()
            }
            .navigationDestination(
                isPresented: $isMyPageViewPresented
            ) {
                MyPageView()
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

    // MARK: - Debug Layout

    private var debugRuler: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ForEach(debugYMarkers, id: \.self) { yPosition in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.black.opacity(0.55))
                            .frame(width: geometry.size.width, height: 1)

                        Text("\(Int(yPosition))pt")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundStyle(Color.black)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(Color.white.opacity(0.78))
                            .clipShape(RoundedRectangle(cornerRadius: 3))
                            .offset(x: 4, y: -9)
                    }
                    .offset(y: yPosition)
                }
            }
        }
        .allowsHitTesting(false)
    }

    private func debugMetricsPanel(geometry: GeometryProxy) -> some View {
        let safeTop = geometry.safeAreaInsets.top
        let toolbarInset = toolbarTopInset(for: geometry)
        let topInset = topContentInset(for: geometry)
        let toolbarFrameHeight = toolbarInset + 72

        return VStack(alignment: .leading, spacing: 4) {
            Text("safeTop: \(safeTop, specifier: "%.1f")")
            Text("toolbarInset: \(toolbarInset, specifier: "%.1f")")
            Text("toolbarFrame: \(toolbarFrameHeight, specifier: "%.1f")")
            Text("topContentInset: \(topInset, specifier: "%.1f")")
        }
        .font(.system(size: 11, weight: .semibold, design: .monospaced))
        .foregroundStyle(Color.black)
        .padding(8)
        .background(Color.white.opacity(0.82))
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.black.opacity(0.45), lineWidth: 1)
        )
        .padding(.trailing, 8)
        .padding(.top, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .allowsHitTesting(false)
    }

    private func debugLabel(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 10, weight: .bold, design: .monospaced))
            .foregroundStyle(Color.black)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .background(Color.white.opacity(0.72))
            .clipShape(RoundedRectangle(cornerRadius: 3))
            .padding(4)
            .allowsHitTesting(false)
    }

    // MARK: - Data

    private var myClosetItems: HomeClosetItems {
        guard let currentUser = store.currentUser else {
            return fallbackClosetItems
        }

        let items = closetItems(ownerId: currentUser.id)
        return normalizedClosetItems(items)
    }

    private var fallbackClosetItems: HomeClosetItems {
        HomeClosetItems(
            topItems: fallbackTopItems,
            bottomItems: fallbackBottomItems,
            otherItems: fallbackOtherItems
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
            topItems: imageNames(category: .top, ownerId: ownerId),
            bottomItems: imageNames(category: .bottom, ownerId: ownerId),
            otherItems: imageNames(category: .accessory, ownerId: ownerId)
        )
    }

    private func imageNames(category: ClothCategory, ownerId: UUID) -> [String] {
        store.clothItems(category: category, ownerId: ownerId).compactMap { item in
            item.imageName ?? item.cutoutImageName
        }
    }

    private func normalizedClosetItems(_ items: HomeClosetItems) -> HomeClosetItems {
        HomeClosetItems(
            topItems: displayItems(items.topItems, fallback: fallbackTopItems),
            bottomItems: displayItems(items.bottomItems, fallback: fallbackBottomItems),
            otherItems: displayItems(items.otherItems, fallback: fallbackOtherItems)
        )
    }

    private func displayItems(_ items: [String], fallback: [String]) -> [String] {
        guard items.count >= 3 else {
            return Array(fallback.prefix(3))
        }

        return items
    }

    // MARK: - Background

    private var backgroundView: some View {
        ZStack {
            Image("Background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }

    // MARK: - Top Menu

    private var topMenuView: some View {
        ToolbarUI(
            mode: .home,
            onAdd: {
                isUploadViewPresented = true
            },
            onNotification: {
                print("알림")
            },
            onProfile: {
                isMyPageViewPresented = true
            }
        )
    }

    // MARK: - Closet Page

    private func closetPage(
        mainTitle: String,
        subTitle: String?,
        showsReview: Bool,
        showsReturnButton: Bool,
        items: HomeClosetItems
    ) -> some View {
        GeometryReader { geometry in
            let closetHeight = closetHeight(
                availableHeight: geometry.size.height,
                showsReview: showsReview,
                showsReturnButton: showsReturnButton
            )

            VStack(alignment: .leading, spacing: 0) {
                pageHeader(
                    mainTitle: mainTitle,
                    subTitle: subTitle,
                    showsReturnButton: showsReturnButton
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
                    targetHeight: closetHeight
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.cyan.opacity(0.12))
            .overlay(alignment: .topLeading) {
                debugLabel("CLOSET PAGE")
            }
        }
    }

    private func closetHeight(
        availableHeight: CGFloat,
        showsReview: Bool,
        showsReturnButton: Bool
    ) -> CGFloat {
        let headerHeight: CGFloat = showsReturnButton ? 94 : 46
        let reviewHeight: CGFloat = showsReview ? 170 : 0
        let headerToClosetGap: CGFloat = showsReview ? 0 : 16
        let availableClosetHeight = availableHeight - headerHeight - reviewHeight - headerToClosetGap

        return min(542.14, max(390, availableClosetHeight))
    }

    private func pageHeader(
        mainTitle: String,
        subTitle: String?,
        showsReturnButton: Bool
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

            if showsReturnButton {
                OutlineButton(title: "↩︎ 돌려주기") {
                    print("돌려주기")
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .frame(height: showsReturnButton ? 94 : 46, alignment: .bottom)
        .background(Color.pink.opacity(0.20))
        .overlay(alignment: .topLeading) {
            debugLabel("PAGE HEADER")
        }
    }

    // MARK: - Review

    private var reviewView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("내가 받은 리뷰")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
                .padding(.leading, 18)

            reviewScrollView
                .padding(.top, 12.28)
                .padding(.bottom, 10.88)
        }
        .background(Color.mint.opacity(0.22))
        .overlay(alignment: .topLeading) {
            debugLabel("REVIEW VIEW")
        }
    }

    private var reviewScrollView: some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .trailing) {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(0..<reviewCount, id: \.self) { index in
                            NoteButton {
                            }
                            .frame(width: 99.83)
                            .id(index)
                            .padding(.horizontal, 3)
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
                    .frame(width: 40, height: 100)

                    PrimaryIconButton(
                        icon: Image(systemName: "chevron.right")
                    ) {
                        moveToNextReview(using: proxy)
                    }
                }
            }
            .frame(height: 100)
            .clipped()
        }
        .padding(.leading, 23)
        .padding(.trailing, 58.83)
    }

    private func moveToNextReview(
        using proxy: ScrollViewProxy
    ) {
        guard reviewCount > 0 else {
            return
        }

        if currentReviewIndex < reviewCount - 1 {
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

    // MARK: - Closet

    private func centeredClosetView(
        items: HomeClosetItems,
        targetHeight: CGFloat
    ) -> some View {
        let scale = targetHeight / 542.14
        let targetWidth = 356.4 * scale

        return HStack {
            Spacer(minLength: 0)

            closetView(items: items)
                .scaleEffect(scale, anchor: .top)
                .frame(width: targetWidth, height: targetHeight, alignment: .top)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity)
        .frame(height: targetHeight, alignment: .top)
        .background(Color.teal.opacity(0.18))
        .overlay(alignment: .topLeading) {
            debugLabel("CENTERED CLOSET")
        }
        .clipped()
    }

    private func closetView(items: HomeClosetItems) -> some View {
        ZStack {
            Image("MyCloset")
                .resizable()
                .scaledToFit()
                .frame(width: 356.4, height: 542.14)

            VStack(spacing: 0) {
                MyClosetSectionView(
                    title: "상의",
                    imageNames: items.topItems
                ) {
                    print("상의 더보기")
                }
                .frame(width: 307, height: 136)

                MyClosetSectionView(
                    title: "하의",
                    imageNames: items.bottomItems
                ) {
                    print("하의 더보기")
                }
                .frame(width: 307, height: 136)

                MyClosetSectionView(
                    title: "기타",
                    imageNames: items.otherItems
                ) {
                    print("기타 더보기")
                }
                .frame(width: 307, height: 124)

                MyClosetButton(title: "옷장 전체 보기") {
                    isClosetViewPresented = true
                }
                .padding(.top, 8.87)
            }
            .padding(.bottom, 30)
        }
        .frame(width: 356.4, height: 542.14)
        .background(Color.brown.opacity(0.18))
        .overlay(alignment: .topLeading) {
            debugLabel("CLOSET FRAME")
        }
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
    let topItems: [String]
    let bottomItems: [String]
    let otherItems: [String]

    var isEmpty: Bool {
        topItems.isEmpty && bottomItems.isEmpty && otherItems.isEmpty
    }
}

#Preview {
    HomeView()
        .environmentObject(AppDataStore())
}
