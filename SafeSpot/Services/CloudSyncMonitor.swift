import CloudKit
import Observation

enum CloudSyncAvailability: Equatable {
    case checking
    case available
    case noAccount
    case restricted
    case temporarilyUnavailable
    case unavailable

    init(accountStatus: CKAccountStatus) {
        self = switch accountStatus {
        case .available:
            .available
        case .noAccount:
            .noAccount
        case .restricted:
            .restricted
        case .temporarilyUnavailable:
            .temporarilyUnavailable
        case .couldNotDetermine:
            .unavailable
        @unknown default:
            .unavailable
        }
    }
}

@MainActor
@Observable
final class CloudSyncMonitor {
    private(set) var availability: CloudSyncAvailability = .checking
    private(set) var isRefreshing = false

    private let container: CKContainer
    @ObservationIgnored
    private nonisolated(unsafe) var accountChangedObserver: NSObjectProtocol?

    init(
        containerIdentifier: String = PersistenceController.cloudKitContainerIdentifier
    ) {
        container = CKContainer(identifier: containerIdentifier)
        accountChangedObserver = NotificationCenter.default.addObserver(
            forName: .CKAccountChanged,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            Task { @MainActor [weak self] in
                await self?.refresh()
            }
        }
    }

    deinit {
        if let accountChangedObserver {
            NotificationCenter.default.removeObserver(accountChangedObserver)
        }
    }

    func refresh() async {
        guard !isRefreshing else {
            return
        }

        isRefreshing = true
        defer { isRefreshing = false }

        do {
            availability = CloudSyncAvailability(
                accountStatus: try await container.accountStatus()
            )
        } catch {
            availability = .unavailable
        }
    }
}
