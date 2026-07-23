//
//  ClothCutoutView.swift
//  Nojin9
//
//  Created by 김가은 on 7/17/26.
//

// TODO: 임시 뷰이므로 추후 삭제 예정

import SwiftUI
import UIKit
import ImageIO

struct ClothCutoutView: View {
    // Vision에 넣을 원본 이미지
    let originalImage: UIImage

    private let cutoutService: any ClothCutoutService

    // Vision 처리 결과
    @State private var cutoutImage: UIImage?

    // 처리 상태
    @State private var isLoading = false

    // 에러 메시지
    @State private var errorMessage: String?

    init(
        originalImage: UIImage,
        cutoutService: any ClothCutoutService = VisionClothCutoutService()
    ) {
        self.originalImage = originalImage
        self.cutoutService = cutoutService
    }

    var body: some View {
        VStack(spacing: 24) {
            Text("옷 사진 확인")
                .font(.title2)
                .fontWeight(.bold)

            imageContent

            if cutoutImage != nil {
                Button {
                    // 이후 저장 또는 업로드 로직 연결
                } label: {
                    Text("이 사진 사용하기")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(20)
        .task {
            await generateCutout()
        }
    }

    @ViewBuilder
    private var imageContent: some View {
        if isLoading {
            loadingView
        } else if let cutoutImage {
            resultImageView(cutoutImage)
        } else if let errorMessage {
            errorView(errorMessage)
        } else {
            originalImageView
        }
    }

    private var originalImageView: some View {
        Image(uiImage: originalImage)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: 500)
            .clipShape(
                RoundedRectangle(cornerRadius: 20)
            )
    }

    private var loadingView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.customBlack)

            VStack(spacing: 16) {
                ProgressView()
                    .controlSize(.large)
                    .tint(Color.customWhite)

                Text("배경을 제거하고 있어요")
                    .font(.subheadline)
                    .foregroundStyle(Color.customWhite)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 500)
    }

    private func resultImageView(
        _ image: UIImage
    ) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .padding(20)
            .frame(maxWidth: .infinity)
            .frame(height: 500)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.customBlack)
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 20)
            )
    }

    private func errorView(
        _ message: String
    ) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 44))
                .foregroundStyle(.orange)

            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.gray60)

            Button("다시 시도") {
                Task {
                    await generateCutout()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 400)
    }

    @MainActor
    private func generateCutout() async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            let normalizedImage = originalImage.normalizedUpImage()

            guard let cgImage = normalizedImage.cgImage else {
                throw ImageNormalizationError.cgImageCreationFailed
            }

            let result = try await cutoutService.generateCutout(
                from: cgImage
            )

            try Task.checkCancellation()

            cutoutImage = UIImage(
                cgImage: result,
                scale: normalizedImage.scale,
                orientation: .up
            )
        } catch is CancellationError {
            return
        } catch {
            print("Vision 오류:", error)
            errorMessage = error.localizedDescription
        }
    }
}


// MARK: - Image Normalization

private enum ImageNormalizationError: LocalizedError {
    case cgImageCreationFailed

    var errorDescription: String? {
        switch self {
        case .cgImageCreationFailed:
            return "사진의 방향을 보정하지 못했어요."
        }
    }
}

private extension UIImage {
    var cgImagePropertyOrientation: CGImagePropertyOrientation {
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



#Preview {
    ClothCutoutView(
        originalImage: UIImage(named: "Cloth01")!
    )
}
