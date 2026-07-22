import UIKit

struct PickedClothColor {
    var normalizedPosition: CGPoint
    var uiColor: UIColor
    var name: String
    var hex: String
}

enum ClothColorPickerAnalyzer {
    static func initialPick(in image: UIImage) -> PickedClothColor? {
        guard let cgImage = image.cgImage,
              let pixelData = PixelData(cgImage: cgImage) else {
            return nil
        }

        let step = max(1, max(pixelData.width, pixelData.height) / 90)
        var bestScore: CGFloat = -1
        var bestPoint: CGPoint?
        var bestColor: UIColor?

        for y in stride(from: 0, to: pixelData.height, by: step) {
            for x in stride(from: 0, to: pixelData.width, by: step) {
                guard let sample = pixelData.colorSample(x: x, y: y),
                      sample.alpha > 0.12 else {
                    continue
                }

                let score = sample.saturation * max(sample.brightness, 0.25)
                if score > bestScore {
                    bestScore = score
                    bestPoint = CGPoint(
                        x: (CGFloat(x) + 0.5) / CGFloat(pixelData.width),
                        y: (CGFloat(y) + 0.5) / CGFloat(pixelData.height)
                    )
                    bestColor = sample.uiColor
                }
            }
        }

        guard let bestPoint, let bestColor else {
            return nil
        }

        return pickedColor(color: bestColor, normalizedPosition: bestPoint)
    }

    static func pick(in image: UIImage, normalizedPosition: CGPoint) -> PickedClothColor? {
        guard let cgImage = image.cgImage,
              let pixelData = PixelData(cgImage: cgImage) else {
            return nil
        }

        let clampedPosition = CGPoint(
            x: min(max(normalizedPosition.x, 0), 1),
            y: min(max(normalizedPosition.y, 0), 1)
        )
        let x = Int(clampedPosition.x * CGFloat(max(pixelData.width - 1, 0)))
        let y = Int(clampedPosition.y * CGFloat(max(pixelData.height - 1, 0)))

        guard let color = pixelData.averageColor(aroundX: x, y: y) else {
            return nil
        }

        return pickedColor(color: color, normalizedPosition: clampedPosition)
    }

    private static func pickedColor(
        color: UIColor,
        normalizedPosition: CGPoint
    ) -> PickedClothColor {
        PickedClothColor(
            normalizedPosition: normalizedPosition,
            uiColor: color,
            name: color.accessibilityColorName,
            hex: color.hexString
        )
    }
}

private struct PixelData {
    let width: Int
    let height: Int

    private let bytesPerPixel = 4
    private let data: [UInt8]

    init?(cgImage: CGImage) {
        width = cgImage.width
        height = cgImage.height

        let bytesPerRow = width * bytesPerPixel
        var rawData = [UInt8](repeating: 0, count: height * bytesPerRow)

        guard let context = CGContext(
            data: &rawData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            return nil
        }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        data = rawData
    }

    func colorSample(x: Int, y: Int) -> ColorSample? {
        guard x >= 0, x < width, y >= 0, y < height else {
            return nil
        }

        let offset = ((y * width) + x) * bytesPerPixel
        let red = CGFloat(data[offset]) / 255
        let green = CGFloat(data[offset + 1]) / 255
        let blue = CGFloat(data[offset + 2]) / 255
        let alpha = CGFloat(data[offset + 3]) / 255

        return ColorSample(red: red, green: green, blue: blue, alpha: alpha)
    }

    func averageColor(aroundX x: Int, y: Int) -> UIColor? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var count: CGFloat = 0

        for sampleY in max(0, y - 2)...min(height - 1, y + 2) {
            for sampleX in max(0, x - 2)...min(width - 1, x + 2) {
                guard let sample = colorSample(x: sampleX, y: sampleY),
                      sample.alpha > 0.12 else {
                    continue
                }

                red += sample.red
                green += sample.green
                blue += sample.blue
                count += 1
            }
        }

        guard count > 0 else {
            return nil
        }

        return UIColor(
            red: red / count,
            green: green / count,
            blue: blue / count,
            alpha: 1
        )
    }
}

private struct ColorSample {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat

    var uiColor: UIColor {
        UIColor(red: red, green: green, blue: blue, alpha: 1)
    }

    var saturation: CGFloat {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return saturation
    }

    var brightness: CGFloat {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return brightness
    }
}

private extension UIColor {
    var hexString: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return String(
            format: "#%02X%02X%02X",
            Int(round(red * 255)),
            Int(round(green * 255)),
            Int(round(blue * 255))
        )
    }

    var accessibilityColorName: String {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        if brightness < 0.18 {
            return "검은색"
        }

        if saturation < 0.12 {
            if brightness > 0.9 {
                return "흰색"
            }
            return "회색"
        }

        let degrees = hue * 360
        switch degrees {
        case 0..<18, 345...360:
            return "빨간색"
        case 18..<45:
            return "주황색"
        case 45..<70:
            return "노란색"
        case 70..<165:
            return "초록색"
        case 165..<255:
            return "파란색"
        case 255..<295:
            return "보라색"
        case 295..<345:
            return "분홍색"
        default:
            return "기본색"
        }
    }
}
