//
//  ClothThumbnailView.swift
//  Nojin9
//
//  Created by 김가은 on 7/18/26.
//

import SwiftUI

struct MyClothThumbnailView: View {
    let imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 90)
    }
}

#Preview {
    MyClothThumbnailView(imageName: "Top01")
}
