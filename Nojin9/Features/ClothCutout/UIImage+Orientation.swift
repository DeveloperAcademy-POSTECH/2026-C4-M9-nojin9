//
//  UIImage+Orientation.swift
//  Nojin9
//
//  Created by 김가은 on 7/22/26.
//

import UIKit

extension UIImage {
    func normalizedUpImage() -> UIImage {
        guard imageOrientation != .up else {
            return self
        }

        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        format.opaque = false

        return UIGraphicsImageRenderer(
            size: size,
            format: format
        ).image { _ in
            draw(
                in: CGRect(
                    origin: .zero,
                    size: size
                )
            )
        }
    }
}
