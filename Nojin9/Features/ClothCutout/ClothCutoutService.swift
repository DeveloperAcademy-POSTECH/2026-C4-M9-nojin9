//
//  ClothCutoutService.swift
//  Nojin9
//
//  Created by 김가은 on 7/14/26.
//

import CoreGraphics
import ImageIO

protocol ClothCutoutService: Sendable {
    func generateCutout(
        from image: CGImage,
        orientation: CGImagePropertyOrientation
    ) async throws -> CGImage
}
