//
//  VisionClothCutoutService.swift
//  Nojin9
//
//  Created by 김가은 on 7/14/26.
//

import CoreGraphics
import CoreImage
import ImageIO
import Vision

/// Vision 프레임워크를 사용해 이미지에서 전경 영역을 추출하고,
/// 투명 배경과 흰색 외곽선을 적용한 이미지를 생성합니다.
final class VisionClothCutoutService:
    ClothCutoutService,
    @unchecked Sendable {

    enum CutoutError: LocalizedError {
        case foregroundNotFound
        case imageGenerationFailed

        var errorDescription: String? {
            switch self {
            case .foregroundNotFound:
                return """
                옷과 배경을 구분하기 어려워요.
                옷을 펼치고 다른 물건이 겹치지 않게 다시 촬영해주세요.
                """

            case .imageGenerationFailed:
                return "배경을 제거한 이미지를 만들지 못했어요."
            }
        }
    }

    private let ciContext = CIContext()

    func generateCutout(
        from image: CGImage,
    ) async throws -> CGImage {
        let ciContext = self.ciContext

        return try await Task.detached(
            priority: .userInitiated
        ) {
            try Task.checkCancellation()

            let request = VNGenerateForegroundInstanceMaskRequest()

            let handler = VNImageRequestHandler(
                cgImage: image,
                orientation: .up,
                options: [:]
            )

            try handler.perform([request])
            try Task.checkCancellation()

            guard
                let observation = request.results?.first,
                !observation.allInstances.isEmpty
            else {
                throw CutoutError.foregroundNotFound
            }

            let maskedPixelBuffer = try observation.generateMaskedImage(
                ofInstances: observation.allInstances,
                from: handler,
                croppedToInstancesExtent: false
            )

            let maskedImage = CIImage(
                cvPixelBuffer: maskedPixelBuffer
            )

            let outlinedImage = Self.addingWhiteOutline(
                to: maskedImage,
                radius: 18
            )

            guard let cutoutImage = ciContext.createCGImage(
                outlinedImage,
                from: outlinedImage.extent
            ) else {
                throw CutoutError.imageGenerationFailed
            }

            return cutoutImage
        }.value
    }

    // MARK: - Outline

    /// 이미지의 알파 영역을 확장하여 흰색 외곽선을 생성합니다.
    private static func addingWhiteOutline(
        to image: CIImage,
        radius: Float
    ) -> CIImage {
        let extent = image.extent.integral

        /*
         CIColorMatrix를 사용하여 원본 이미지의 알파값을
         RGB와 알파 채널 모두에 복사합니다.

         이렇게 해야 morphology 필터와 blend mask 필터에서
         안정적인 흑백 마스크로 사용할 수 있습니다.
         */
        let alphaMask = image
            .applyingFilter(
                "CIColorMatrix",
                parameters: [
                    "inputRVector": CIVector(
                        x: 0,
                        y: 0,
                        z: 0,
                        w: 1
                    ),
                    "inputGVector": CIVector(
                        x: 0,
                        y: 0,
                        z: 0,
                        w: 1
                    ),
                    "inputBVector": CIVector(
                        x: 0,
                        y: 0,
                        z: 0,
                        w: 1
                    ),
                    "inputAVector": CIVector(
                        x: 0,
                        y: 0,
                        z: 0,
                        w: 1
                    )
                ]
            )
            .cropped(to: extent)

        // 기존 알파 영역을 바깥쪽으로 확장
        let expandedMask = alphaMask
            .applyingFilter(
                "CIMorphologyMaximum",
                parameters: [
                    kCIInputRadiusKey: radius
                ]
            )
            .cropped(to: extent)

        let transparentImage = CIImage(
            color: CIColor(
                red: 0,
                green: 0,
                blue: 0,
                alpha: 0
            )
        )
        .cropped(to: extent)

        let whiteImage = CIImage(
            color: CIColor(
                red: 1,
                green: 1,
                blue: 1,
                alpha: 1
            )
        )
        .cropped(to: extent)

        // 확장된 영역 전체에 흰색 실루엣 생성
        let whiteSilhouette = whiteImage
            .applyingFilter(
                "CIBlendWithMask",
                parameters: [
                    kCIInputBackgroundImageKey: transparentImage,
                    kCIInputMaskImageKey: expandedMask
                ]
            )
            .cropped(to: extent)

        // 흰색 실루엣 위에 실제 누끼 이미지를 올림
        // 원본 옷 부분은 가려지므로 바깥쪽 흰 선만 남게 됨
        return image
            .composited(over: whiteSilhouette)
            .cropped(to: extent)
    }
}
