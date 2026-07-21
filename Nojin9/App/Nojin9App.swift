import SwiftUI

@main
struct Nojin9App: App {
    @StateObject private var store = AppDataStore()
    @State private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                HomeView()
                    .environmentObject(store)
            } else {
                OnboardingFlowView {
                    hasCompletedOnboarding = true
                }
                .environmentObject(store)
            }
        }
    }
}
