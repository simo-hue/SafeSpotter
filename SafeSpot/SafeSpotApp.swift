import SwiftData
import SwiftUI

@main
struct SafeSpotApp: App {
    @State private var persistenceManager: PersistenceManager

    init() {
        do {
            _persistenceManager = State(
                initialValue: try PersistenceManager()
            )
        } catch {
            fatalError("Could not initialize the SafeSpot data store: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .id(persistenceManager.containerID)
                .environment(persistenceManager)
        }
        .modelContainer(persistenceManager.modelContainer)
    }
}
