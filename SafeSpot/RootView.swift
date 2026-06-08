import OSLog
import SwiftData
import SwiftUI

struct RootView: View {
    @AppStorage(AppSettingsKey.hasCompletedOnboarding) private var hasCompletedOnboarding = false
    @AppStorage(AppSettingsKey.isAppLockEnabled) private var isAppLockEnabled = false
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    @Environment(PersistenceManager.self) private var persistenceManager
    @Query private var items: [StoredItem]
    @State private var isAuthenticated = false
    private let logger = Logger(subsystem: "com.safespot", category: "Maintenance")

    var body: some View {
        Group {
            if !hasCompletedOnboarding {
                OnboardingView()
            } else if isAppLockEnabled && !isAuthenticated {
                LockView(isAuthenticated: $isAuthenticated)
            } else {
                HomeView()
            }
        }
        .preferredColorScheme(.dark)
        .alert(
            storageChangeConfirmationTitle,
            isPresented: Binding(
                get: {
                    persistenceManager.completedStorageChange != nil
                },
                set: { isPresented in
                    if !isPresented {
                        persistenceManager.dismissStorageChangeConfirmation()
                    }
                }
            )
        ) {
            Button("OK", role: .cancel) {
                persistenceManager.dismissStorageChangeConfirmation()
            }
        } message: {
            Text(storageChangeConfirmationMessage)
        }
        .onChange(of: scenePhase) { _, newPhase in
            if isAppLockEnabled && (newPhase == .background || newPhase == .inactive) {
                isAuthenticated = false
            }

            if newPhase == .active {
                Task {
                    await ReminderScheduler.shared.reconcileReminders(for: items)
                }
            }
        }
        .onChange(of: isAppLockEnabled) { _, isEnabled in
            isAuthenticated = isEnabled
        }
        .onChange(of: reminderReconciliationSignature) {
            Task {
                await ReminderScheduler.shared.reconcileReminders(for: items)
            }
        }
        .task {
            do {
                let migratedPhotoCount = try LegacyPhotoMigrationService.migratePhotos(
                    in: modelContext
                )

                if migratedPhotoCount > 0 {
                    logger.info("Migrated \(migratedPhotoCount) legacy photo(s) to SwiftData.")
                }
            } catch {
                logger.error("Legacy photo migration failed: \(error.localizedDescription)")
            }

            await ReminderScheduler.shared.reconcileReminders(for: items)
        }
    }

    private var reminderReconciliationSignature: [ReminderReconciliationState] {
        items
            .map {
                ReminderReconciliationState(
                    id: $0.id,
                    reminderDate: $0.reminderDate,
                    isArchived: $0.isArchived
                )
            }
            .sorted { $0.id.uuidString < $1.id.uuidString }
    }

    private var storageChangeConfirmationTitle: String {
        switch persistenceManager.completedStorageChange {
        case .cloud:
            "iCloud Sync Enabled"
        case .local:
            "iCloud Sync Disabled"
        case nil:
            ""
        }
    }

    private var storageChangeConfirmationMessage: String {
        switch persistenceManager.completedStorageChange {
        case .cloud:
            "Your saved items are now using private iCloud sync and can stay updated across your devices."
        case .local:
            "Your saved items are now stored only on this device. Future changes will not sync with iCloud."
        case nil:
            ""
        }
    }
}

private struct ReminderReconciliationState: Equatable {
    let id: UUID
    let reminderDate: Date?
    let isArchived: Bool
}

#Preview {
    RootView()
        .modelContainer(for: StoredItem.self, inMemory: true)
}
