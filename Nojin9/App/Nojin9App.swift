import SwiftUI

@main
struct Nojin9App: App {
    @StateObject private var store = AppDataStore()
    @State private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    HomeView()
                } else {
                    OnboardingFlowView {
                        hasCompletedOnboarding = true
                    }
                }
            }
            .environmentObject(store)
            .preferredColorScheme(.light)
            .tint(Color.customBlack)
        }
    }
}
