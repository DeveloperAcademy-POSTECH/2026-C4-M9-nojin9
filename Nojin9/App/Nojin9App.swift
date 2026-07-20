import SwiftUI

@main
struct Nojin9App: App {
    @StateObject private var store = AppDataStore()
    
    var body: some Scene {
        WindowGroup {
            //            MyClosetView()
            //                .environmentObject(store)
            NavigationStack {
                ReturnView()
            }
            .environmentObject(store)
        }
    }
}

