//
//  UploadView.swift
//  Nojin9
//

import SwiftUI
import PhotosUI
import UIKit

struct UploadView: View {
    private let cutoutService = VisionClothCutoutService()

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: AppDataStore
    
    @State private var itemName = ""
    @State private var selectedCategory: ClothCategory?
    @State private var precautions = ""
    
    @State private var isShowingImageSource = false
    
    @State private var selectedImage: UIImage?
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

            selectedImage = UIImage(
                cgImage: cutoutCGImage,
                scale: originalImage.scale,
                orientation: .up
            )
        } catch {
            cutoutErrorMessage = error.localizedDescription
            isShowingCutoutError = true
        }
    }
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    navigationView
                    
                    VStack(alignment: .leading, spacing: 22) {
                        photoSection
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
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .navigationBarBackButtonHidden()
        
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
                        .background(Color.gray.opacity(0.08))
                        .clipShape(Circle())
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
            
            Button {
                isShowingImageSource = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.brandPrimary10)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray10)
                    
                    if isCutoutProcessing {
                        VStack(spacing: 14) {
                            ProgressView()
                                .tint(.brandPrimary)
                                .scaleEffect(1.2)

                            Text("사진 배경을 제거하고 있어요")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(.brandPrimary)
                        }
                    } else if let selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .padding(12)
                    } else {
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
                }
                .frame(height: 240)
            }
            .buttonStyle(.plain)
            .disabled(isCutoutProcessing)
            
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
            
            TextField("회색 오프숄더 니트", text: $itemName)
                .font(.system(size: 16))
                .padding(.horizontal, 14)
                .frame(height: 52)
                .background(Color.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray.opacity(0.35), lineWidth: 1)
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
                .foregroundStyle(.gray)
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $precautions)
                    .font(.system(size: 16))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
                    .frame(height: 125)
                    .scrollContentBackground(.hidden)
                    .background(Color.white)
                
                if precautions.isEmpty {
                    Text(
                        """
                        옷이 잘 늘어나니 주의 필요함.
                        오염있으면 문지르지 말고 그대로 둬야함.
                        (드라이클리닝 해야함)
                        """
                    )
                    .font(.system(size: 16))
                    .foregroundStyle(Color.gray.opacity(0.6))
                    .padding(.horizontal, 13)
                    .padding(.vertical, 15)
                    .allowsHitTesting(false)
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray.opacity(0.35), lineWidth: 1)
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
                .foregroundStyle(.white)
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
                imageName: storedImageName,
                cutoutImageName: storedImageName
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
