//
//  ClothThumbnailView.swift
//  Nojin9
//
//  Created by 김가은 on 7/18/26.
//

import SwiftUI
import UIKit

enum UploadedClothImageStoreError: Error {
    case invalidImageData
}

enum UploadedClothImageStore {
    static func save(_ image: UIImage) throws -> String {
        let fileName = "uploaded-cloth-\(UUID().uuidString).png"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        guard let imageData = image.pngData() else {
            throw UploadedClothImageStoreError.invalidImageData
        }

        try imageData.write(to: fileURL, options: .atomic)
        return fileName
    }

    static func image(named imageName: String) -> UIImage? {
        if let assetImage = UIImage(named: imageName) {
            return assetImage
        }

        let fileURL = documentsDirectory.appendingPathComponent(imageName)
        return UIImage(contentsOfFile: fileURL.path)
    }

    private static var documentsDirectory: URL {
        FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
    }
}

struct ClothImageView: View {
    let imageName: String

    var body: some View {
        if let image = UploadedClothImageStore.image(named: imageName) {
            Image(uiImage: image)
                .resizable()
        } else {
            Image(systemName: "tshirt")
                .resizable()
                .foregroundStyle(.gray60)
        }
    }
}

struct MyClothThumbnailView: View {
    let item: ClothItem

    private var imageName: String? {
        item.imageName ?? item.cutoutImageName
    }

    var body: some View {
        Group {
            if let imageName {
                ClothImageView(imageName: imageName)
                    .scaledToFit()
            } else {
                Image(systemName: "tshirt")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.gray60)
            }
        }
        .frame(width: 100, height: 90)
    }
}

#Preview {
    MyClothThumbnailView(item: MockData.clothItems[0])
}
