import SwiftData
import SwiftUI

@main
struct SafeSpotApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: StoredItem.self)
    }
}

