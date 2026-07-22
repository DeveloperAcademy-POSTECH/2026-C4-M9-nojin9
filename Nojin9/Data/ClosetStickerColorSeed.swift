import Foundation

enum ClosetStickerColorSeed {
    static let colors: [String: (name: String, hex: String)] = [
        "2ndSisAccessories1": (name: "노란색", hex: "#FCF0B4"),
        "2ndSisAccessories2": (name: "주황색", hex: "#BB8E70"),
        "2ndSisAccessories3": (name: "빨간색", hex: "#B05961"),
        "2ndSisBottom1": (name: "빨간색", hex: "#6E2F2B"),
        "2ndSisBottom2": (name: "검은색", hex: "#0C0704"),
        "2ndSisBottom3": (name: "회색", hex: "#A0A0A0"),
        "2ndSisTop1": (name: "주황색", hex: "#98720F"),
        "2ndSisTop2": (name: "회색", hex: "#9EA19F"),
        "2ndSisTop3": (name: "주황색", hex: "#C7BA9A"),
        "Accessories1": (name: "검은색", hex: "#0E0200"),
        "Accessories2": (name: "검은색", hex: "#010002"),
        "Accessories3": (name: "검은색", hex: "#050002"),
        "Accessories4": (name: "검은색", hex: "#050601"),
        "Accessories5": (name: "주황색", hex: "#CF9365"),
        "Accessories6": (name: "노란색", hex: "#B4AB6D"),
        "Bottom1": (name: "검은색", hex: "#0C080A"),
        "Bottom2": (name: "검은색", hex: "#090906"),
        "Bottom3": (name: "주황색", hex: "#997E63"),
        "Bottom4": (name: "검은색", hex: "#111427"),
        "Bottom5": (name: "검은색", hex: "#140700"),
        "Bottom6": (name: "검은색", hex: "#1D0500"),
        "Bottom7": (name: "검은색", hex: "#000308"),
        "MyAccessories1": (name: "검은색", hex: "#1A1E21"),
        "MyAccessories2": (name: "파란색", hex: "#596987"),
        "MyAccessories3": (name: "검은색", hex: "#000202"),
        "MyBottom1": (name: "회색", hex: "#959592"),
        "MyBottom2": (name: "파란색", hex: "#40618D"),
        "MyBottom3": (name: "파란색", hex: "#476A94"),
        "MyTop1": (name: "검은색", hex: "#0F0A05"),
        "MyTop2": (name: "검은색", hex: "#000007"),
        "MyTop3": (name: "회색", hex: "#BABFBC"),
        "Top1": (name: "회색", hex: "#A7A7A7"),
        "Top2": (name: "검은색", hex: "#191512"),
        "Top3": (name: "검은색", hex: "#030400"),
        "Top4": (name: "검은색", hex: "#010006"),
        "Top5": (name: "파란색", hex: "#4789A7")
    ]

    static func color(for imageName: String?) -> (name: String, hex: String)? {
        guard let imageName else {
            return nil
        }

        return colors[imageName]
    }
}
