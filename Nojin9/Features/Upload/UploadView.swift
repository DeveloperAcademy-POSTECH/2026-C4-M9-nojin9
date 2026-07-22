//
//  UploadView.swift
//  Nojin9
//

import SwiftUI
import PhotosUI
import UIKit

struct UploadView: View {
    private let cutoutService = VisionClothCutoutService()
    private let photoAreaHeight: CGFloat = 240
    private let selectedImagePadding: CGFloat = 12

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: AppDataStore
    
    @State private var itemName = ""
    @State private var selectedCategory: ClothCategory?
    @State private var precautions = ""
    
    @State private var isShowingImageSource = false
    
    @State private var selectedImage: UIImage?
    @State private var pickedColor: PickedClothColor?
    @State private var isCutoutProcessing = false
    @State private var cutoutErrorMessage: String?
    @State private var isShowingCutoutError = false
    
    @State private var isShowingCamera = false
    @State private var isShowingPhotoLibrary = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var isShowingCameraAlert = false
    
    private var canRegister: Bool {
        selectedImage != nil &&
        !isCutoutProcessing &&
        !itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        selectedCategory != nil
    }
    
    @MainActor
    private func processImage(_ originalImage: UIImage) async {
        isCutoutProcessing = true
        selectedImage = nil
        pickedColor = nil

        defer {
            isCutoutProcessing = false
        }

        guard let originalCGImage = originalImage.cgImage else {
            cutoutErrorMessage = "선택한 사진을 불러오지 못했어요."
            isShowingCutoutError = true
            return
        }

        do {
            let cutoutCGImage = try await cutoutService.generateCutout(
                from: originalCGImage
            )

            let cutoutImage = UIImage(
                cgImage: cutoutCGImage,
                scale: originalImage.scale,
                orientation: .up
            )

            selectedImage = cutoutImage
            pickedColor = ClothColorPickerAnalyzer.initialPick(in: cutoutImage)
        } catch {
            cutoutErrorMessage = error.localizedDescription
            isShowingCutoutError = true
        }
    }
    
    var body: some View {
        ZStack {
            Color.customWhite
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 22) {
                        photoSection
                        pointColorSection
                        divider
                        itemNameSection
                        categorySection
                        precautionsSection
                        registerButton
                    }
                    .padding(.horizontal, 14)
                    .padding(.top, 22)
                    .padding(.bottom, 30)
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil
            )
        }
        .navigationTitle("내 물품 등록하기")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        
        .confirmationDialog(
            "사진 첨부하기",
            isPresented: $isShowingImageSource,
            titleVisibility: .hidden
        ) {
            Button("사진 찍기") {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    isShowingCamera = true
                } else {
                    isShowingCameraAlert = true
                }
            }
            
            Button("사진 보관함") {
                isShowingPhotoLibrary = true
            }
            
            Button("취소", role: .cancel) { }
        }
        
        .photosPicker(
            isPresented: $isShowingPhotoLibrary,
            selection: $selectedPhotoItem,
            matching: .images
        )
        .onChange(of: selectedPhotoItem) { _, newItem in
            guard let newItem else {
                return
            }

            Task {
                guard let imageData = try? await newItem.loadTransferable(
                    type: Data.self
                ),
                let originalImage = UIImage(data: imageData) else {
                    return
                }

                await processImage(originalImage)
            }
        }
        .fullScreenCover(isPresented: $isShowingCamera) {
            CameraPickerView { originalImage in
                Task {
                    await processImage(originalImage)
                }
            }
            .ignoresSafeArea()
        }
        
        .alert("카메라를 사용할 수 없어요", isPresented: $isShowingCameraAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text("실제 기기에서 다시 시도해 주세요.")
        }
        
        .alert(
            "배경 제거에 실패했어요",
            isPresented: $isShowingCutoutError
        ) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(
                cutoutErrorMessage ??
                "옷과 배경이 잘 구분되는 사진으로 다시 시도해 주세요."
            )
        }
    }
}

private extension UIImage {
    var cgImageOrientation: CGImagePropertyOrientation {
        switch imageOrientation {
        case .up:
            return .up

        case .upMirrored:
            return .upMirrored

        case .down:
            return .down

        case .downMirrored:
            return .downMirrored

        case .left:
            return .left

        case .leftMirrored:
            return .leftMirrored

        case .right:
            return .right

        case .rightMirrored:
            return .rightMirrored

        @unknown default:
            return .up
        }
    }
}

// MARK: - 상단 메뉴

private extension UploadView {
    var navigationView: some View {
        ZStack {
            Text("내 물품 등록하기")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.customBlack)
            
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(.customBlack)
                        .frame(width: 44, height: 44)
                        .background(.customWhite)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.08), radius: 8, y: 3)
                }
                
                Spacer()
            }
        }
        .frame(height: 52)
        .padding(.horizontal, 14)
    }
}

// MARK: - 사진 첨부

private extension UploadView {
    var photoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            requiredTitle("물품 사진")

            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(.brandPrimary10)

                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray10)

                if isCutoutProcessing {
                    cutoutProgressView
                } else if let selectedImage {
                    selectedPhotoView(selectedImage)
                } else {
                    emptyPhotoView
                }
            }
            .frame(height: photoAreaHeight)
            .contentShape(Rectangle())
            .onTapGesture {
                guard selectedImage == nil, !isCutoutProcessing else {
                    return
                }

                isShowingImageSource = true
            }
            
            HStack{
                Image(systemName: "checkmark")
                    .font(.caption)
                    .foregroundStyle(.brandPrimary)
                Text("배경이 있는 이미지도 자동으로 배경이 제거됩니다.")
                    .font(.caption)
                    .foregroundStyle(.gray60)
            }
            .padding(.leading, 10)
        }
    }

    var cutoutProgressView: some View {
        VStack(spacing: 14) {
            ProgressView()
                .tint(.brandPrimary)
                .scaleEffect(1.2)

            Text("사진 배경을 제거하고 있어요")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.brandPrimary)
        }
    }

    var emptyPhotoView: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(.brandPrimary)
                    .opacity(0.2)
                    .frame(width: 98, height: 98)

                Image(systemName: "camera.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.brandPrimary)
            }

            Text("사진 첨부하기")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.brandPrimary)
        }
    }

    func selectedPhotoView(_ image: UIImage) -> some View {
        GeometryReader { geometry in
            let imageRect = fittedImageRect(
                image: image,
                in: geometry.size,
                padding: selectedImagePadding
            )

            ZStack(alignment: .topLeading) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageRect.width, height: imageRect.height)
                    .position(x: imageRect.midX, y: imageRect.midY)

                if let pickedColor {
                    colorPickerCircle(color: pickedColor.uiColor)
                        .position(
                            pickerPoint(
                                for: pickedColor.normalizedPosition,
                                in: imageRect
                            )
                        )
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    updatePickedColor(
                                        at: value.location,
                                        imageRect: imageRect,
                                        image: image
                                    )
                                }
                        )
                }

                Button {
                    isShowingImageSource = true
                } label: {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.brandPrimary)
                        .frame(width: 34, height: 34)
                        .background(Color.customWhite.opacity(0.92))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 2)
                }
                .buttonStyle(.plain)
                .position(x: geometry.size.width - 28, y: 28)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }

    func colorPickerCircle(color: UIColor) -> some View {
        Circle()
            .fill(Color(color))
            .frame(width: 30, height: 30)
            .overlay {
                Circle()
                    .stroke(Color.white, lineWidth: 4)
            }
            .shadow(color: .black.opacity(0.18), radius: 6, x: 0, y: 2)
            .contentShape(Circle())
    }

    func updatePickedColor(
        at location: CGPoint,
        imageRect: CGRect,
        image: UIImage
    ) {
        let normalizedPosition = CGPoint(
            x: (location.x - imageRect.minX) / max(imageRect.width, 1),
            y: (location.y - imageRect.minY) / max(imageRect.height, 1)
        )

        guard let nextColor = ClothColorPickerAnalyzer.pick(
            in: image,
            normalizedPosition: normalizedPosition
        ) else {
            return
        }

        pickedColor = nextColor
    }

    func pickerPoint(for normalizedPosition: CGPoint, in imageRect: CGRect) -> CGPoint {
        CGPoint(
            x: imageRect.minX + imageRect.width * normalizedPosition.x,
            y: imageRect.minY + imageRect.height * normalizedPosition.y
        )
    }

    func fittedImageRect(
        image: UIImage,
        in containerSize: CGSize,
        padding: CGFloat
    ) -> CGRect {
        let availableWidth = max(containerSize.width - padding * 2, 1)
        let availableHeight = max(containerSize.height - padding * 2, 1)
        let imageSize = image.size
        let scale = min(
            availableWidth / max(imageSize.width, 1),
            availableHeight / max(imageSize.height, 1)
        )
        let fittedSize = CGSize(
            width: imageSize.width * scale,
            height: imageSize.height * scale
        )

        return CGRect(
            x: (containerSize.width - fittedSize.width) / 2,
            y: (containerSize.height - fittedSize.height) / 2,
            width: fittedSize.width,
            height: fittedSize.height
        )
    }
}

// MARK: - 포인트 색상

private extension UploadView {
    @ViewBuilder
    var pointColorSection: some View {
        if let pickedColor {
            HStack(spacing: 8) {
                Text("이 옷의 포인트 색깔은")
                    .font(.system(size: 15))
                    .foregroundStyle(.customBlack)

                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(pickedColor.uiColor))
                    .frame(width: 28, height: 18)
                    .overlay {
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(Color.gray.opacity(0.25), lineWidth: 1)
                    }
                    .accessibilityHidden(true)

                Text("\(pickedColor.name) 입니다.")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.customBlack)
            }
            .padding(.horizontal, 10)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("이 옷의 포인트 색깔은 \(pickedColor.name) 입니다.")
        }
    }
}

// MARK: - 구분선

private var divider: some View {
    Rectangle()
        .fill(.gray5)
        .frame(height: 3)
}


// MARK: - 물품 이름

private extension UploadView {
    var itemNameSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            requiredTitle("물품 이름")
            
            TextField(
                "",
                text: $itemName,
                prompt: Text("회색 오프숄더 니트")
                    .foregroundStyle(Color.gray60)
            )
                .font(.system(size: 16))
                .foregroundStyle(Color.customBlack)
                .tint(Color.brandPrimary)
                .padding(.horizontal, 14)
                .frame(height: 52)
                .background(Color.customWhite)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray60.opacity(0.35), lineWidth: 1)
                }
        }
    }
}

// MARK: - 카테고리

private extension UploadView {
    var categorySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            requiredTitle("물품 카테고리")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.customBlack)
            
            HStack(spacing: 10) {
                categoryButton(
                    title: "상의",
                    category: .top
                )
                
                categoryButton(
                    title: "하의",
                    category: .bottom
                )
                
                categoryButton(
                    title: "기타",
                    category: .accessory
                )
            }
        }
    }
    
    func categoryButton(
        title: String,
        category: ClothCategory
    ) -> some View {
        let isSelected = selectedCategory == category
        
        return Button {
            selectedCategory = category
        } label: {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(
                    isSelected ? Color.customWhite : Color.customBlack.opacity(0.8)
                )
                .padding(.horizontal, 22)
                .frame(height: 40)
                .background(
                    isSelected
                    ? .brandPrimary
                    : .customWhite.opacity(0.06)
                )
                .clipShape(Capsule())
                .overlay {
                    Capsule()
                        .stroke(
                            isSelected
                            ? .brandPrimary10
                            : .gray10.opacity(0.4),
                            lineWidth: 1
                        )
                }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 주의사항

private extension UploadView {
    var precautionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("주의사항")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.customBlack)
            
            Text("주의사항은 항목별로 줄바꿈해 주세요.")
                .font(.system(size: 14))
                .foregroundStyle(Color.gray60)
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $precautions)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.customBlack)
                    .tint(Color.brandPrimary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
                    .frame(height: 125)
                    .scrollContentBackground(.hidden)
                    .background(Color.customWhite)
                
                if precautions.isEmpty {
                    Text(
                        """
                        옷이 잘 늘어나니 주의 필요함.
                        오염있으면 문지르지 말고 그대로 둬야함.
                        (드라이클리닝 해야함)
                        """
                    )
                    .font(.system(size: 16))
                    .foregroundStyle(Color.gray60.opacity(0.6))
                    .padding(.horizontal, 13)
                    .padding(.vertical, 15)
                    .allowsHitTesting(false)
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray60.opacity(0.35), lineWidth: 1)
            }
        }
    }
}

// MARK: - 등록 버튼

private extension UploadView {
    var registerButton: some View {
        Button {
            registerItem()
        } label: {
            Text("등록하기")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.customWhite)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    canRegister
                    ? .brandPrimary
                    : .gray20
                )
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .disabled(!canRegister)
        .animation(.easeInOut(duration: 0.2), value: canRegister)
    }
    
    func registerItem() {
        guard let selectedCategory, let selectedImage else {
            return
        }

        do {
            let storedImageName = try UploadedClothImageStore.save(selectedImage)

            store.addClothItem(
                name: itemName,
                category: selectedCategory,
                description: precautions,
                pointCost: selectedCategory.defaultPointCost,
                imageName: storedImageName,
                cutoutImageName: storedImageName,
                keyColorName: pickedColor?.name,
                keyColorHex: pickedColor?.hex
            )
            dismiss()
        } catch {
            cutoutErrorMessage = "이미지를 저장하지 못했어요. 다시 시도해 주세요."
            isShowingCutoutError = true
        }
    }
}

// MARK: - 공통 UI

private extension UploadView {
    func requiredTitle(_ title: String) -> some View {
        HStack(spacing: 7) {
            Text(title)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.customBlack)
            
            Text("필수")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.brandPrimary)
        }
    }
}

// MARK: - 카메라 권한
struct CameraPickerView: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss

    let onImageSelected: (UIImage) -> Void

    func makeUIViewController(
        context: Context
    ) -> UIImagePickerController {
        let picker = UIImagePickerController()

        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.allowsEditing = false
        picker.delegate = context.coordinator

        return picker
    }

    func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: Context
    ) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    final class Coordinator: NSObject,
                             UIImagePickerControllerDelegate,
                             UINavigationControllerDelegate {
        private let parent: CameraPickerView

        init(parent: CameraPickerView) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [
                UIImagePickerController.InfoKey: Any
            ]
        ) {
            if let originalImage = info[.originalImage] as? UIImage {
                parent.onImageSelected(originalImage)
            }

            parent.dismiss()
        }

        func imagePickerControllerDidCancel(
            _ picker: UIImagePickerController
        ) {
            parent.dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        UploadView()
    }
}
