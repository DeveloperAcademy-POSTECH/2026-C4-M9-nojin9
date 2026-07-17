//
//  ClothImagePicker.swift.swift
//  Nojin9
//
//  Created by 김가은 on 7/14/26.
//

import PhotosUI
import SwiftUI
import UIKit

/// "사진 촬영" 버튼 & "앨범에서 선택" 버튼 두 가지를 제공
struct ClothImagePicker: View {
    enum Source {
        case camera
        case photoLibrary
    }

    let onImageSelected: (Data) -> Void

    // MARK: - State (이 뷰 내부에서만 관리하는 상태값들)

    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var isCameraPresented = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 12) {
            // MARK: 사진 촬영 버튼
            Button {
                openCamera()
            } label: {
                Label(
                    "사진 촬영",
                    systemImage: "camera"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            // MARK: 앨범에서 선택 버튼
            PhotosPicker(
                selection: $selectedPhotoItem,  // 사용자가 고른 사진이 이 바인딩에 저장됨
                matching: .images                // 이미지 파일만 보여주도록 필터링
            ) {
                Label(
                    "앨범에서 선택",
                    systemImage: "photo"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            // 에러 메시지가 있을 때만 화면에 표시
            if let errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }
        }
        // selectedPhotoItem 값이 바뀔 때마다 (= 사용자가 앨범에서 새 사진을 고를 때마다) 실행
        .onChange(of: selectedPhotoItem) {
            Task {
                await loadSelectedPhoto()
            }
        }
        .sheet(isPresented: $isCameraPresented) {
            CameraPicker { imageData in
                onImageSelected(imageData)
                isCameraPresented = false
            } onCancel: {
                isCameraPresented = false
            }
            .ignoresSafeArea()
        }
    }

    /// 카메라 버튼을 눌렀을 때 호출
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            errorMessage = """
            이 기기에서는 카메라를 사용할 수 없어요.
            실제 iPhone에서 실행해주세요.
            """
            return
        }

        errorMessage = nil
        isCameraPresented = true
    }

    private func loadSelectedPhoto() async {
        // selectedPhotoItem이 nil이면 (선택 취소된 경우 등) 아무것도 안 함
        guard let selectedPhotoItem else {
            return
        }

        do {
            guard let data = try await selectedPhotoItem.loadTransferable(
                type: Data.self
            ) else {
                throw ImagePickerError.invalidImageData
            }

            errorMessage = nil
            onImageSelected(data)

        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// MARK: - 이 파일 내부에서만 쓰는 에러 타입
private extension ClothImagePicker {

    enum ImagePickerError: LocalizedError {
        case invalidImageData

        var errorDescription: String? {
            "선택한 사진을 불러오지 못했어요."
        }
    }
}

// MARK: - 카메라 촬영 화면
private struct CameraPicker: UIViewControllerRepresentable {

    let onImageCaptured: (Data) -> Void
    let onCancel: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(
            onImageCaptured: onImageCaptured,
            onCancel: onCancel
        )
    }

    func makeUIViewController(
        context: Context
    ) -> UIImagePickerController {
        let picker = UIImagePickerController()

        picker.sourceType = .camera        // 카메라 모드로 설정
        picker.cameraDevice = .rear        // 후면 카메라 기본 사용
        picker.allowsEditing = false       // 촬영 후 자르기/편집 화면 생략
        picker.delegate = context.coordinator  // 촬영 완료/취소 이벤트를 Coordinator가 받도록 연결

        return picker
    }

    func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: Context
    ) {
    }

    /// UIImagePickerControllerDelegate를 채택해서 카메라의 촬영 완료/취소 이벤트를 처리하는 클래스
    /// NSObject를 상속해야 하는 이유: UIKit delegate 프로토콜들이 Objective-C 기반이라 NSObject가 필요함
    final class Coordinator:
        NSObject,
        UIImagePickerControllerDelegate,
        UINavigationControllerDelegate {

        private let onImageCaptured: (Data) -> Void
        private let onCancel: () -> Void

        init(
            onImageCaptured: @escaping (Data) -> Void,
            onCancel: @escaping () -> Void
        ) {
            self.onImageCaptured = onImageCaptured
            self.onCancel = onCancel
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [
                UIImagePickerController.InfoKey: Any
            ]
        ) {
            guard
                // info 딕셔너리에서 원본 촬영 이미지를 꺼냄
                let image = info[.originalImage] as? UIImage,
                // UIImage를 JPEG Data로 압축 변환 (0.95 = 거의 원본 화질 유지)
                let data = image.jpegData(compressionQuality: 0.95)
            else {
                // 이미지를 못 꺼내면 그냥 취소 처리
                picker.dismiss(animated: true)
                onCancel()
                return
            }

            picker.dismiss(animated: true) {
                self.onImageCaptured(data)
            }
        }

        func imagePickerControllerDidCancel(
            _ picker: UIImagePickerController
        ) {
            picker.dismiss(animated: true) {
                self.onCancel()
            }
        }
    }
}

#Preview {
    ClothImagePicker { data in
        print("이미지 선택됨: \(data.count) bytes")
    }
}

