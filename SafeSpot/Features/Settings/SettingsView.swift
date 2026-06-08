import SwiftUI
import UIKit

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @Environment(PersistenceManager.self) private var persistenceManager
    @AppStorage(AppSettingsKey.isAppLockEnabled) private var isAppLockEnabled = false
    @AppStorage(AppSettingsKey.isDiscreetModeEnabled) private var isDiscreetModeEnabled = false
    @AppStorage(AppSettingsKey.defaultReminderFrequency) private var defaultReminderRawValue = ReminderFrequency.none.rawValue
    @State private var isShowingProtectionError = false
    @State private var isUpdatingProtection = false
    @State private var isShowingDisableCloudSyncConfirmation = false
    @State private var cloudSyncErrorMessage: String?
    @State private var cloudSyncMonitor = CloudSyncMonitor()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.md) {
                    privacySection
                    cloudSyncSection
                    reminderSection
                    aboutSection
                }
                .padding(AppSpacing.lg)
            }
            .appScreenBackground()
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Could Not Enable Protection", isPresented: $isShowingProtectionError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Set up a device passcode, Face ID, or Touch ID in iOS Settings, then try again.")
            }
            .alert("Could Not Change Storage", isPresented: Binding(
                get: { cloudSyncErrorMessage != nil },
                set: { if !$0 { cloudSyncErrorMessage = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(cloudSyncErrorMessage ?? "Please try again.")
            }
            .confirmationDialog(
                "Turn Off iCloud Sync?",
                isPresented: $isShowingDisableCloudSyncConfirmation,
                titleVisibility: .visible
            ) {
                Button("Keep Data on This Device") {
                    changeStorageMode(to: .local)
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("SafeSpot will copy your current items to this device and stop syncing future changes. Existing copies already stored in iCloud are retained in case you turn sync back on.")
            }
        }
        .tint(AppColors.secondary)
        .task {
            await cloudSyncMonitor.refresh()
        }
    }

    private var cloudSyncSection: some View {
        SectionCard(title: "iCloud Sync", systemImage: "icloud.fill") {
            SettingsToggleRow(
                title: "Sync with iCloud",
                subtitle: cloudSyncToggleSubtitle,
                isOn: Binding(
                    get: { persistenceManager.storageMode == .cloud },
                    set: { requestCloudSyncChange(isEnabled: $0) }
                )
            )
            .disabled(
                persistenceManager.isSwitchingStorage
                    || cloudSyncMonitor.isRefreshing
            )

            if persistenceManager.isSwitchingStorage {
                HStack(spacing: AppSpacing.sm) {
                    ProgressView()
                        .controlSize(.small)

                    Text("Moving your saved items...")
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }

            Divider()
                .overlay(Color.white.opacity(0.1))

            HStack(alignment: .top, spacing: AppSpacing.sm) {
                Image(systemName: cloudSyncStatusSymbol)
                    .foregroundStyle(cloudSyncStatusColor)
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(cloudSyncStatusTitle)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppColors.textPrimary)

                    Text(cloudSyncStatusMessage)
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }

                Spacer(minLength: 0)

                if cloudSyncMonitor.isRefreshing
                    && persistenceManager.storageMode == .cloud {
                    ProgressView()
                        .controlSize(.small)
                }
            }

            Text(cloudSyncStorageMessage)
                .font(.caption)
                .foregroundStyle(AppColors.textSecondary)

            if persistenceManager.storageMode == .cloud
                && cloudSyncMonitor.availability != .available
                && cloudSyncMonitor.availability != .checking {
                Button("Open Settings") {
                    guard let settingsURL = URL(
                        string: UIApplication.openSettingsURLString
                    ) else {
                        return
                    }

                    openURL(settingsURL)
                }
                .buttonStyle(.bordered)
            }
        }
    }

    private var privacySection: some View {
        SectionCard(title: "Privacy", systemImage: "lock.shield.fill") {
            SettingsToggleRow(
                title: "Require Face ID or Passcode",
                subtitle: "Protect your saved items when opening the app.",
                isOn: Binding(
                    get: { isAppLockEnabled },
                    set: { updateAppLock(isEnabled: $0) }
                )
            )
            .disabled(isUpdatingProtection)

            Divider()
                .overlay(Color.white.opacity(0.1))

            SettingsToggleRow(
                title: "Discreet Mode",
                subtitle: "Hide private item names and locations in lists and notifications.",
                isOn: $isDiscreetModeEnabled
            )
        }
    }

    private var reminderSection: some View {
        SectionCard(title: "Reminders", systemImage: "bell.fill") {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Default Reminder")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppColors.textPrimary)

                Text("Prefill a local reminder when adding a new item.")
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)

                Picker("Default Reminder", selection: $defaultReminderRawValue) {
                    ForEach(ReminderFrequency.allCases.filter { $0 != .custom }) { frequency in
                        Text(frequency.title)
                            .tag(frequency.rawValue)
                    }
                }
                .pickerStyle(.menu)
            }
        }
    }

    private var aboutSection: some View {
        SectionCard(title: "About", systemImage: "info.circle.fill") {
            NavigationLink {
                PrivacyStatementView()
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text("Privacy Statement")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(AppColors.textPrimary)

                        Text("Optional iCloud sync. No tracking SDKs.")
                            .font(.caption)
                            .foregroundStyle(AppColors.textSecondary)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppColors.textTertiary)
                }
            }

            Divider()
                .overlay(Color.white.opacity(0.1))

            HStack {
                Text("Version")
                    .foregroundStyle(AppColors.textSecondary)

                Spacer()

                Text(appVersion)
                    .foregroundStyle(AppColors.textPrimary)
            }
            .font(.subheadline)
        }
    }

    private var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }

    private var cloudSyncStatusTitle: String {
        guard persistenceManager.storageMode == .cloud else {
            return "Stored on This Device"
        }

        return switch cloudSyncMonitor.availability {
        case .checking:
            "Checking iCloud"
        case .available:
            "iCloud Available"
        case .noAccount:
            "Sign In to iCloud"
        case .restricted:
            "iCloud Restricted"
        case .temporarilyUnavailable:
            "iCloud Temporarily Unavailable"
        case .unavailable:
            "Could Not Check iCloud"
        }
    }

    private var cloudSyncStatusMessage: String {
        guard persistenceManager.storageMode == .cloud else {
            return "iCloud sync is off. Changes made in SafeSpot stay in the local store on this device."
        }

        return switch cloudSyncMonitor.availability {
        case .checking:
            "Checking whether private iCloud sync is available on this device."
        case .available:
            "SafeSpot can synchronize changes using the iCloud account on this device."
        case .noAccount:
            "Sign in to an iCloud account in Settings to synchronize across devices."
        case .restricted:
            "Device restrictions currently prevent SafeSpot from accessing iCloud."
        case .temporarilyUnavailable:
            "Keep your local data. SafeSpot will retry automatically when iCloud is available."
        case .unavailable:
            "SafeSpot could not determine the iCloud account status. Local data remains available."
        }
    }

    private var cloudSyncStatusSymbol: String {
        guard persistenceManager.storageMode == .cloud else {
            return "internaldrive.fill"
        }

        return switch cloudSyncMonitor.availability {
        case .available:
            "checkmark.circle.fill"
        case .checking:
            "arrow.triangle.2.circlepath.icloud"
        case .noAccount, .restricted, .temporarilyUnavailable, .unavailable:
            "exclamationmark.triangle.fill"
        }
    }

    private var cloudSyncStatusColor: Color {
        guard persistenceManager.storageMode == .cloud else {
            return AppColors.secondary
        }

        return switch cloudSyncMonitor.availability {
        case .available:
            AppColors.secondary
        case .checking:
            AppColors.textSecondary
        case .noAccount, .restricted, .temporarilyUnavailable, .unavailable:
            .orange
        }
    }

    private var cloudSyncToggleSubtitle: String {
        if persistenceManager.storageMode == .cloud {
            "Keep items available offline and synchronize them across your devices."
        } else {
            "Keep items only in SafeSpot's local store on this device."
        }
    }

    private var cloudSyncStorageMessage: String {
        if persistenceManager.storageMode == .cloud {
            "Items, notes, locations, reminder settings, and photos synchronize through your private iCloud database."
        } else {
            "Existing copies previously synchronized to iCloud are retained and can be merged if you enable sync again."
        }
    }

    private func requestCloudSyncChange(isEnabled: Bool) {
        if isEnabled {
            guard cloudSyncMonitor.availability == .available else {
                cloudSyncErrorMessage = "Sign in to iCloud and make sure iCloud is available on this device before enabling sync."
                return
            }

            changeStorageMode(to: .cloud)
        } else {
            isShowingDisableCloudSyncConfirmation = true
        }
    }

    private func changeStorageMode(to mode: PersistenceStorageMode) {
        Task {
            do {
                try await persistenceManager.switchStorage(to: mode)
            } catch {
                cloudSyncErrorMessage = "SafeSpot could not move your saved items. Your current storage mode and data were not changed."
            }
        }
    }

    private func updateAppLock(isEnabled: Bool) {
        guard isEnabled else {
            isAppLockEnabled = false
            return
        }

        isUpdatingProtection = true

        Task {
            let canAuthenticate = AuthenticationService.shared.canAuthenticate()
            let didAuthenticate: Bool

            if canAuthenticate {
                didAuthenticate = await AuthenticationService.shared.authenticate()
            } else {
                didAuthenticate = false
            }

            if didAuthenticate {
                isAppLockEnabled = true
            } else {
                isShowingProtectionError = true
            }

            isUpdatingProtection = false
        }
    }
}

private struct SettingsToggleRow: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppColors.textPrimary)

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
    }
}
