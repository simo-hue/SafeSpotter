import SwiftData
import SwiftUI

@main
struct SafeSpotApp: App {
    private let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try PersistenceController.makeModelContainer()
        } catch {
            fatalError("Could not initialize the SafeSpot data store: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(modelContainer)
    }
}
