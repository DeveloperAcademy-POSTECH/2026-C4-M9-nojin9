//
//  VisionClothCutoutService.swift
//  Nojin9
//
//  Created by 김가은 on 7/14/26.
//
import CoreGraphics
import CoreImage
import Vision

/// Vision 프레임워크를 사용해 이미지에서 전경(옷) 영역만 추출하고
/// 배경을 제거한 이미지를 생성하는 서비스
final class VisionClothCutoutService:
    ClothCutoutService,
    @unchecked Sendable {

    /// 배경 제거 과정에서 발생할 수 있는 에러 정의
    enum CutoutError: LocalizedError {
        /// 전경(옷) 인스턴스를 하나도 찾지 못한 경우
        case foregroundNotFound
        /// 마스크는 만들었지만 최종 CGImage로 변환하는 데 실패한 경우
        case imageGenerationFailed

        /// 사용자에게 보여줄 에러 메시지
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

    // CIImage -> CGImage 변환에 사용할 CIContext
    private let ciContext = CIContext()

    /// 입력 이미지에서 전경(옷) 부분만 남기고 배경을 제거한 CGImage를 생성
    /// - Parameters:
    ///   - image: 원본 CGImage
    ///   - orientation: 이미지 촬영 방향 (기본값 .up)
    /// - Returns: 배경이 제거된(마스킹된) CGImage
    /// - Throws: 전경을 찾지 못하거나 이미지 생성에 실패한 경우 CutoutError
    func generateCutout(
        from image: CGImage,
        orientation: CGImagePropertyOrientation = .up
    ) async throws -> CGImage {
        let ciContext = self.ciContext

        // .userInitiated: 사용자가 직접 기다리는 작업이므로 높은 우선순위 부여
        return try await Task.detached(
            priority: .userInitiated
        ) {
            try Task.checkCancellation()
            let request = VNGenerateForegroundInstanceMaskRequest()

            // 실제 이미지 분석을 수행할 핸들러 생성
            let handler = VNImageRequestHandler(
                cgImage: image,
                orientation: orientation,
                options: [:]
            )
            try handler.perform([request])
            try Task.checkCancellation()

            // 전경으로 인식된 인스턴스가 하나도 없으면 에러 처리
            guard
                let observation = request.results?.first,
                !observation.allInstances.isEmpty
            else {
                throw CutoutError.foregroundNotFound
            }

            // croppedToInstancesExtent: false -> 원본 이미지 크기를 그대로 유지 (전경 영역만 잘라내지 않음)
            let maskedPixelBuffer = try observation.generateMaskedImage(
                ofInstances: observation.allInstances,
                from: handler,
                croppedToInstancesExtent: false
            )

            // CVPixelBuffer -> CIImage로 변환
            let maskedImage = CIImage(
                cvPixelBuffer: maskedPixelBuffer
            )
            
            let outlinedImage = self.addingWhiteOutline(
                to: maskedImage,
                radius: 12
            )

            // CIImage -> CGImage로 최종 변환 (실패 시 이미지 생성 실패 에러)
            guard let cutoutImage = ciContext.createCGImage(
                outlinedImage,
                from: outlinedImage.extent
            ) else {
                throw CutoutError.imageGenerationFailed
            }

            return cutoutImage
        }.value
    }
    
    // 누끼 사진에 Outline 생성
    private func addingWhiteOutline(
        to image: CIImage,
        radius: Float = 12
    ) -> CIImage {
        let extent = image.extent

        let alphaMask = image
            .applyingFilter("CIMaskToAlpha")
            .cropped(to: extent)

        let expandedMask = alphaMask
            .applyingFilter(
                "CIMorphologyMaximum",
                parameters: [
                    kCIInputRadiusKey: radius
                ]
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

        let transparentImage = CIImage(
            color: CIColor(
                red: 0,
                green: 0,
                blue: 0,
                alpha: 0
            )
        )
        .cropped(to: extent)

        let whiteSilhouette = whiteImage
            .applyingFilter(
                "CIBlendWithMask",
                parameters: [
                    kCIInputBackgroundImageKey: transparentImage,
                    kCIInputMaskImageKey: expandedMask
                ]
            )
            .cropped(to: extent)

        return image
            .composited(over: whiteSilhouette)
            .cropped(to: extent)
    }
}


