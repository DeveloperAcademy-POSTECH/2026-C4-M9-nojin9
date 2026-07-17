import SwiftUI

@main
struct Nojin9App: App {
    var body: some Scene {
        WindowGroup {
            ClothCutoutView(
                originalImage: UIImage(named: "Cloth01")!
            )
        }
    }
}

