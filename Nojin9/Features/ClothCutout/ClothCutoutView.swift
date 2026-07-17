import SwiftUI
import UIKit

struct ClothCutoutView: View {
    // Vision에 전달할 원본 이미지
    let originalImage: UIImage

    private let cutoutService = VisionClothCutoutService()

    // Vision을 통해 나온 누끼 이미지
    @State private var cutoutImage: UIImage?

    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
    
        VStack {
            if isLoading {
                ProgressView("배경을 제거하고 있어요")
            } else if let cutoutImage {
                Image(uiImage: cutoutImage)
                    .resizable()
                    .scaledToFit()
                    .background(Color.black)
            } else if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            } else {
                Image(uiImage: originalImage)
                    .resizable()
                    .scaledToFit()
            }
        }
        .task {
            await generateCutout()
        }
    }

    @MainActor
    private func generateCutout() async {
        guard let cgImage = originalImage.cgImage else {
            errorMessage = "이미지를 불러오지 못했어요."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let result = try await cutoutService.generateCutout(
                from: cgImage,
                orientation: .up
            )

            cutoutImage = UIImage(cgImage: result)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

#Preview {
    ClothCutoutView(
        originalImage: UIImage(named: "Cloth01")!
    )
}
