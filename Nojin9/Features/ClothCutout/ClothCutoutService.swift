//
//  ClothCutoutService.swift
//  Nojin9
//
//  Created by 김가은 on 7/14/26.
//

import CoreGraphics

protocol ClothCutoutService: Sendable {
    func generateCutout(
        from image: CGImage,
    ) async throws -> CGImage
}
