//
//  ReviewWritingView.swift
//  Nojin9
//
//  Created by 김가은 on 7/21/26.
//

import PhotosUI
import SwiftUI

struct ReviewWritingView: View {
    @EnvironmentObject private var store: AppDataStore

    let rental: Rental
    let item: ClothItem
    let onMoveToReviewList: () -> Void
    let onMoveToHome: () -> Void

    @State private var message = ""

    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    @State private var photoDataList: [Data] = []
    @State private var currentPhotoIndex = 0
    
    @State private var isCompleted = false

    private let maxPhotoCount = 5

    private var canSubmit: Bool {
        !selectedImages.isEmpty &&
        !message
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
    }
    
    init(
        rental: Rental,
        item: ClothItem,
        onMoveToReviewList: @escaping () -> Void,
        onMoveToHome: @escaping () -> Void
    ) {
        self.rental = rental
        self.item = item
        self.onMoveToReviewList = onMoveToReviewList
        self.onMoveToHome = onMoveToHome

        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(
            Color.brandPrimary
        )
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.systemGray4
    }

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 0) {
                itemSummary

                Rectangle()
                    .fill(.gray5)
                    .frame(height: 8)

                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        photoSection
                        messageSection
                    }
                    .padding(16)
                }

                submitButton
            }

            if isCompleted {
                ReviewCompletionOverlay(
                    onMoveToReviewList: onMoveToReviewList,
                    onMoveToHome: onMoveToHome
                )
                .transition(.opacity)
            }
        }
        .navigationTitle("감사 편지 작성하기")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .onChange(of: selectedPhotos) { _, newValue in
            loadPhotos(from: newValue)
        }
    }

    // MARK: - Item Summary

    private var itemSummary: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("편지를 작성할 물품")
                .font(.appSubtitle)
                .bold()

            ReviewRentalRow(
                rental: rental,
                item: item,
                isSelected: true,
                action: {}
            )
            .allowsHitTesting(false)
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 18)
    }

    // MARK: - Photo Section

    private var photoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 5) {
                Text("후기 사진")
                    .font(.appSubtitle)
                    .bold()

                Text("필수")
                    .font(.caption)
                    .foregroundStyle(.brandPrimary)

                Spacer()

                Text("\(selectedImages.count)/\(maxPhotoCount)")
                    .font(.caption)
                    .foregroundStyle(.gray40)
                    .padding(.trailing, 16)
            }

            if selectedImages.isEmpty {
                emptyPhotoPicker
            } else {
                selectedPhotoList
            }
        }
    }

    private var emptyPhotoPicker: some View {
        PhotosPicker(
            selection: $selectedPhotos,
            maxSelectionCount: maxPhotoCount,
            matching: .images
        ) {
            ZStack {
                Color.brandPrimary10

                VStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(.brandPrimary.opacity(0.2))
                            .frame(width: 98, height: 98)

                        Image(systemName: "camera.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.brandPrimary)
                    }

                    Text("사진 첨부하기")
                        .font(.caption)
                        .foregroundStyle(.brandPrimary)
                }
            }
            .frame(width: 370, height: 220)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray10, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private var selectedPhotoList: some View {
        VStack(spacing: 12) {

            TabView(selection: $currentPhotoIndex) {

                ForEach(selectedImages.indices, id: \.self) { index in

                    ZStack(alignment: .topTrailing) {

                        Image(uiImage: selectedImages[index])
                            .resizable()
                            .scaledToFill()
                            .frame(width: 370, height: 220)
                            .clipped()
                            .clipShape(
                                RoundedRectangle(cornerRadius: 5)
                            )

                        Button {
                            removePhoto(at: index)
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(width: 24, height: 24)
                                .background(.customBlack.opacity(0.65))
                                .clipShape(Circle())
                        }
                        .padding(8)
                    }
                    .tag(index)
                }

                if selectedImages.count < maxPhotoCount {
                    addPhotoButton
                        .tag(selectedImages.count)
                }
            }
            .frame(width: 370, height: 220)
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
    }

    private func photoThumbnail(
        image: UIImage,
        index: Int
    ) -> some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 130, height: 160)
                .clipped()
                .clipShape(
                    RoundedRectangle(cornerRadius: 6)
                )

            Button {
                removePhoto(at: index)
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 24, height: 24)
                    .background(.customBlack.opacity(0.65))
                    .clipShape(Circle())
            }
            .padding(6)
        }
    }

    private var addPhotoButton: some View {
        PhotosPicker(
            selection: $selectedPhotos,
            maxSelectionCount: maxPhotoCount,
            matching: .images
        ) {
            VStack(spacing: 8) {
                Image(systemName: "plus")
                    .font(.system(size: 26, weight: .medium))

                Text("사진 추가")
                    .font(.system(size: 12))
            }
            .foregroundStyle(.pink)
            .frame(width: 370, height: 220)
            .background(.brandPrimary10)
            .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Message Section

    private var messageSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 5) {
                Text("후기글")
                    .font(.appSubtitle)
                    .bold()

                Text("필수")
                    .font(.caption)
                    .foregroundStyle(.brandPrimary)
            }
            .padding(.top, 17)
            
            Text("정성을 담은 한마디로 고마움을 전달할 수 있어요.")
                .font(.caption)
                .foregroundStyle(.gray40)
                .padding(.bottom, 8)

            ZStack(alignment: .topLeading) {
                TextEditor(text: $message)
                    .font(.system(size: 14))
                    .padding(8)
                    .frame(height: 110)
                    .scrollContentBackground(.hidden)

                if message.isEmpty {
                    Text("나에게 옷을 빌려줘서 고마워~!")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.gray20)
                        .padding(.horizontal, 13)
                        .padding(.vertical, 16)
                        .allowsHitTesting(false)
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray10, lineWidth: 1)
            }
        }
    }

    // MARK: - Submit Button

    private var submitButton: some View {
        Button {
            registerReview()
        } label: {
            Text("등록하기")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.customWhite)
                .frame(width: 370, height: 47)
                .background(
                    canSubmit
                        ? Color.brandPrimary
                        : Color.gray20
                )
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .disabled(!canSubmit)
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }

    // MARK: - Photo Logic

    private func loadPhotos(
        from items: [PhotosPickerItem]
    ) {
        Task {
            var loadedImages: [UIImage] = []
            var loadedData: [Data] = []

            for photoItem in items.prefix(maxPhotoCount) {
                guard let data = try? await photoItem.loadTransferable(
                    type: Data.self
                ),
                let image = UIImage(data: data) else {
                    continue
                }

                loadedImages.append(image)
                loadedData.append(data)
            }

            await MainActor.run {
                selectedImages = loadedImages
                photoDataList = loadedData
            }
        }
    }

    private func removePhoto(at index: Int) {

        guard selectedImages.indices.contains(index) else {
            return
        }

        selectedImages.remove(at: index)

        if photoDataList.indices.contains(index) {
            photoDataList.remove(at: index)
        }

        if selectedPhotos.indices.contains(index) {
            selectedPhotos.remove(at: index)
        }

        if currentPhotoIndex >= selectedImages.count {
            currentPhotoIndex = max(
                0,
                selectedImages.count - 1
            )
        }
    }

    // MARK: - Register

    private func registerReview() {
        guard canSubmit else {
            return
        }

        let trimmedMessage = message.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        store.addReview(
            rental: rental,
            item: item,
            message: trimmedMessage,
            photoDataList: photoDataList
        )

        withAnimation {
            isCompleted = true
        }
    }
}

#Preview {
    NavigationStack {
        ReviewWritingView(
            rental: MockData.snapshot.rentals.first!,
            item: MockData.snapshot.clothItems.first!,
            onMoveToReviewList: {
                print("리뷰 선택 화면으로 이동")
            },
            onMoveToHome: {
                print("홈으로 이동")
            }
        )
        .environmentObject(
            AppDataStore(snapshot: MockData.snapshot)
        )
    }
}
