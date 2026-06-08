# SafeSpot iOS App — Complete Implementation Specification

> **2026-06-08 architecture update:** The product now includes private iCloud synchronization through CloudKit. This decision supersedes the local-only and “no cloud sync” constraints below. SafeSpot still requires no app-specific account, uses no developer backend, and remains fully usable offline.

> **Document purpose:** This file is a step-by-step implementation guide for a coding agent working in Cursor with GPT-5.5.  
> **Product type:** Native iOS app.  
> **Language:** Swift.  
> **UI language:** English only.  
> **Core constraint:** Everything must work locally on the user's iPhone. No backend, no account, no cloud sync, no analytics SDK, no remote database.

---

## 0. Executive Summary

Build a native iOS app called **SafeSpot** that helps users remember where they placed important physical items, documents, and small valuables.

The app is a private, local-first “memory vault” for things users put in a safe place and later forget.

Examples:

- Passport
- Spare keys
- Emergency cash
- USB drive
- Jewelry
- Contracts
- Warranty documents
- Medical documents
- Backup SIM card
- Important paper notes

The app must feel premium, modern, fast, discreet, and trustworthy.

Primary product promise:

> **Find your important things fast. No account. No cloud. Only on your iPhone.**

---

## 1. Non-Negotiable Product Constraints

The coding agent must follow these rules strictly.

### 1.1 Local-Only Rules

The app must not include:

- Backend server
- Login or user account
- Cloud database
- iCloud sync
- Firebase
- Supabase
- CloudKit
- Remote analytics
- Remote crash reporting SDK
- Advertising SDK
- Social login
- Third-party tracking
- Remote feature flags
- Any network call required for core functionality

The app must be usable offline forever after installation.

### 1.2 Language Rules

The app interface must be **English only**.

All user-facing strings must be written in English:

- Buttons
- Labels
- Alerts
- Empty states
- Onboarding
- Settings
- Notification text
- Error messages
- App Store copy placeholders inside this spec

Do not add Italian strings in the app.

### 1.3 Privacy Positioning Rules

The app may say:

- “No account required”
- “No cloud sync”
- “Stored locally on this iPhone”
- “Protected with Face ID or device passcode”
- “No tracking SDKs”

The app must **not** claim strong app-level encryption unless that is explicitly implemented.

For the MVP, the app uses:

- iOS app sandboxing
- Device-level data protection
- LocalAuthentication access gate
- Local storage only
- Optional file protection for stored images

Do not market it as a password manager.

---

## 2. Recommended Technical Stack

### 2.1 Platform

- Native iOS app
- Recommended minimum target: **iOS 17.0+**
- Swift
- SwiftUI
- SwiftData
- No third-party dependencies for MVP

SwiftData is recommended because it provides a native model layer integrated with SwiftUI and allows the data model to be described directly in Swift code.

### 2.2 Apple Frameworks

Use these frameworks:

- `SwiftUI` for UI
- `SwiftData` for local persistence
- `PhotosUI` for selecting photos from the user's library
- `LocalAuthentication` for Face ID / Touch ID / passcode authentication
- `UserNotifications` for local reminders
- `Foundation` for dates, IDs, file management
- `UIKit` only where needed, for example for camera capture or image processing bridges

### 2.3 No External Packages

Do not add external dependencies in the MVP.

Avoid:

- Firebase
- Realm Cloud
- Sentry
- Amplitude
- Mixpanel
- RevenueCat in MVP
- Lottie in MVP
- Any remote SDK

Use native SwiftUI animations and SF Symbols.

---

## 3. Product Name and App Identity

### 3.1 Working Name

Use this working name in the project:

```text
SafeSpot
```

### 3.2 Bundle / Project Naming

Suggested names:

```text
Product Name: SafeSpot
Bundle Identifier: com.example.safespot
Display Name: SafeSpot
```

The final bundle identifier can be changed by the developer later.

### 3.3 App Tagline

Use this tagline in onboarding and App Store drafts:

```text
Remember where you keep what matters.
```

Alternative shorter tagline:

```text
Find your important things fast.
```

---

## 4. Product Vision

SafeSpot is a private iPhone app for remembering where important things are stored.

The user should open the app and immediately be able to answer:

- “Where did I put my passport?”
- “Where are the spare keys?”
- “Where did I hide the emergency cash?”
- “Where is the warranty for the TV?”
- “Where is that USB drive?”

The app should not try to become a full home inventory system. It is specifically for important things placed somewhere intentionally.

---

## 5. Target User

### 5.1 Primary User

People who intentionally put important items in a safe place and later forget the exact location.

Traits:

- Privacy-conscious
- Wants simplicity
- Does not want another account
- Does not want cloud sync
- Wants a beautiful app that feels safe and personal
- Uses iPhone as a trusted personal device

### 5.2 Secondary Users

- People managing documents for family members
- People with multiple homes, garage, office, or storage areas
- Minimalists who want to know where every important object is
- Frequent travelers who need to track passports, travel documents, adapters, SIM cards

---

## 6. Core MVP Scope

The MVP must include these features.

### 6.1 Item Creation

Users can create a saved item with:

- Item name
- Category
- Place
- Room
- Container
- Exact spot
- Optional photo
- Optional private note
- Sensitivity level
- Optional reminder

### 6.2 Item List

Users can browse saved items in a modern card-based list.

The list must support:

- Search
- Category filtering
- Sort by recently updated
- Sort by item name
- Sort by last checked
- Empty state
- Private item masking when Discreet Mode is enabled

### 6.3 Search

Search must be fast and local.

Search across:

- Item name
- Category name
- Place
- Room
- Container
- Exact spot
- Notes

### 6.4 Item Details

Users can open a saved item and view:

- Item photo if available
- Full location path
- Private note
- Category
- Sensitivity level
- Created date
- Updated date
- Last checked date
- Reminder status

Actions:

- Edit item
- Delete item
- Mark as checked
- Configure reminder

### 6.5 Face ID / Passcode Gate

Users can enable app protection.

When enabled:

- The app asks for Face ID / Touch ID / device passcode when opened.
- The app should lock again after returning from background.
- Authentication should use `LocalAuthentication`.

### 6.6 Discreet Mode

When enabled:

- Sensitive items are masked in lists.
- Notification text is generic.
- Sensitive item names are not visible until the item is opened after authentication.

Example masked card:

```text
Private Item
Location hidden
```

### 6.7 Local Reminders

Users can set local reminders to check an item.

Reminder examples:

- “Check this item in 1 month”
- “Check this item in 3 months”
- “Check this item in 6 months”
- “Custom date”

Notification text must be discreet by default:

```text
SafeSpot
Time to check a saved item.
```

Do not include sensitive item names in notifications.

### 6.8 Settings

Settings must include:

- Require Face ID / Passcode
- Discreet Mode
- Default reminder frequency
- About SafeSpot
- Privacy statement
- App version placeholder

---

## 7. Explicitly Out of Scope for MVP

Do not implement these in the first version:

- iCloud sync
- Cloud backup
- Multi-device sync
- Family sharing / shared vaults
- Account creation
- Login
- Password manager functionality
- OCR
- Barcode scanning
- AI object detection
- Maps or geolocation
- Web dashboard
- Apple Watch app
- Widgets
- Siri Shortcuts
- In-app purchases
- Export/import encrypted backups

Some of these can be future roadmap items, but they must not block the MVP.

---

## 8. User Experience Principles

### 8.1 UX Keywords

The interface should feel:

- Calm
- Premium
- Fast
- Private
- Modern
- Minimal
- Trustworthy
- Slightly warm, not cold enterprise security

### 8.2 Design Direction

Use a modern Apple-native SwiftUI style.

Suggested visual identity:

- Dark navy / charcoal backgrounds
- Soft cards
- Rounded corners
- Subtle gradients
- SF Symbols
- Large search bar
- Clear primary action button
- Smooth sheet presentations
- Minimal but expressive empty states

### 8.3 Avoid These UI Patterns

Do not make the app look like:

- A spreadsheet
- A file manager
- A password manager clone
- A corporate inventory system
- A generic notes app
- A medical app
- A bank app

---

## 9. Design System

Create a small internal design system.

### 9.1 Colors

Create a file:

```text
Design/AppColors.swift
```

Suggested color roles:

```swift
struct AppColors {
    static let background = Color(red: 0.04, green: 0.06, blue: 0.12)
    static let surface = Color(red: 0.09, green: 0.11, blue: 0.18)
    static let elevatedSurface = Color(red: 0.13, green: 0.15, blue: 0.24)
    static let primary = Color(red: 0.55, green: 0.42, blue: 0.96)
    static let secondary = Color(red: 0.20, green: 0.78, blue: 0.67)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.68)
    static let textTertiary = Color.white.opacity(0.42)
    static let danger = Color(red: 1.00, green: 0.31, blue: 0.31)
}
```

The exact palette can be adjusted, but keep the overall look premium and modern.

### 9.2 Typography

Use system fonts.

Suggested hierarchy:

- Large title: `.largeTitle.bold()`
- Screen title: `.title.bold()`
- Section title: `.headline`
- Body: `.body`
- Metadata: `.caption`

Avoid custom font dependencies in MVP.

### 9.3 Spacing

Use consistent spacing tokens.

Create:

```text
Design/AppSpacing.swift
```

```swift
struct AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
}
```

### 9.4 Corners

Use large rounded corners.

```swift
struct AppCorners {
    static let card: CGFloat = 24
    static let button: CGFloat = 18
    static let field: CGFloat = 16
}
```

### 9.5 Reusable Components

Create reusable components:

```text
Components/PrimaryButton.swift
Components/SecondaryButton.swift
Components/SearchField.swift
Components/EmptyStateView.swift
Components/CategoryChip.swift
Components/ItemCardView.swift
Components/SectionCard.swift
Components/PrivacyBadge.swift
Components/GlassCard.swift
```

---

## 10. Information Architecture

The app has five main areas:

1. Onboarding
2. Authentication gate
3. Home / item list
4. Add/Edit item flow
5. Settings

Suggested root flow:

```text
SafeSpotApp
 └── RootView
      ├── OnboardingView, if first launch not completed
      ├── LockView, if app lock enabled and not authenticated
      └── MainTabView or HomeView
```

For MVP, use a single main screen with settings accessible from the top-right toolbar.

Do not use a heavy tab bar unless needed.

---

## 11. Navigation Structure

Use SwiftUI `NavigationStack`.

Suggested navigation:

```text
HomeView
 ├── ItemDetailView
 │    └── EditItemView
 ├── AddItemView
 └── SettingsView
```

Use sheets for:

- Add item
- Edit item
- Settings
- Reminder picker
- Category picker

Use navigation push for:

- Item details

---

## 12. Data Model

Use SwiftData for local persistence.

### 12.1 Main Entity: StoredItem

Create:

```text
Models/StoredItem.swift
```

Recommended SwiftData model:

```swift
import Foundation
import SwiftData

@Model
final class StoredItem {
    var id: UUID
    var name: String
    var categoryRawValue: String
    var place: String
    var room: String
    var container: String
    var exactSpot: String
    var privateNote: String
    var photoFileName: String?
    var sensitivityRawValue: String
    var createdAt: Date
    var updatedAt: Date
    var lastCheckedAt: Date?
    var reminderDate: Date?
    var reminderFrequencyRawValue: String
    var isArchived: Bool

    init(
        id: UUID = UUID(),
        name: String,
        categoryRawValue: String,
        place: String = "",
        room: String = "",
        container: String = "",
        exactSpot: String = "",
        privateNote: String = "",
        photoFileName: String? = nil,
        sensitivityRawValue: String = SensitivityLevel.normal.rawValue,
        createdAt: Date = .now,
        updatedAt: Date = .now,
        lastCheckedAt: Date? = nil,
        reminderDate: Date? = nil,
        reminderFrequencyRawValue: String = ReminderFrequency.none.rawValue,
        isArchived: Bool = false
    ) {
        self.id = id
        self.name = name
        self.categoryRawValue = categoryRawValue
        self.place = place
        self.room = room
        self.container = container
        self.exactSpot = exactSpot
        self.privateNote = privateNote
        self.photoFileName = photoFileName
        self.sensitivityRawValue = sensitivityRawValue
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastCheckedAt = lastCheckedAt
        self.reminderDate = reminderDate
        self.reminderFrequencyRawValue = reminderFrequencyRawValue
        self.isArchived = isArchived
    }
}
```

### 12.2 Computed Properties Extension

Create:

```text
Models/StoredItem+Computed.swift
```

```swift
extension StoredItem {
    var category: ItemCategory {
        ItemCategory(rawValue: categoryRawValue) ?? .other
    }

    var sensitivity: SensitivityLevel {
        SensitivityLevel(rawValue: sensitivityRawValue) ?? .normal
    }

    var reminderFrequency: ReminderFrequency {
        ReminderFrequency(rawValue: reminderFrequencyRawValue) ?? .none
    }

    var locationSummary: String {
        [place, room, container, exactSpot]
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: " › ")
    }

    var searchableText: String {
        [name, category.title, place, room, container, exactSpot, privateNote]
            .joined(separator: " ")
            .lowercased()
    }

    var hasLocation: Bool {
        !locationSummary.isEmpty
    }
}
```

### 12.3 Category Enum

Create:

```text
Models/ItemCategory.swift
```

```swift
import Foundation

// Store rawValue in SwiftData instead of storing enum directly.
enum ItemCategory: String, CaseIterable, Identifiable {
    case documents
    case keys
    case money
    case jewelry
    case electronics
    case travel
    case health
    case home
    case personal
    case other

    var id: String { rawValue }

    var title: String {
        switch self {
        case .documents: return "Documents"
        case .keys: return "Keys"
        case .money: return "Money"
        case .jewelry: return "Jewelry"
        case .electronics: return "Electronics"
        case .travel: return "Travel"
        case .health: return "Health"
        case .home: return "Home"
        case .personal: return "Personal"
        case .other: return "Other"
        }
    }

    var symbolName: String {
        switch self {
        case .documents: return "doc.text.fill"
        case .keys: return "key.fill"
        case .money: return "banknote.fill"
        case .jewelry: return "sparkles"
        case .electronics: return "externaldrive.fill"
        case .travel: return "airplane"
        case .health: return "cross.case.fill"
        case .home: return "house.fill"
        case .personal: return "person.crop.circle.fill"
        case .other: return "archivebox.fill"
        }
    }
}
```

### 12.4 Sensitivity Enum

Create:

```text
Models/SensitivityLevel.swift
```

```swift
enum SensitivityLevel: String, CaseIterable, Identifiable {
    case normal
    case privateItem
    case highlyPrivate

    var id: String { rawValue }

    var title: String {
        switch self {
        case .normal: return "Normal"
        case .privateItem: return "Private"
        case .highlyPrivate: return "Highly Private"
        }
    }

    var description: String {
        switch self {
        case .normal:
            return "Visible in your list."
        case .privateItem:
            return "Can be hidden when Discreet Mode is on."
        case .highlyPrivate:
            return "Always treated as sensitive."
        }
    }

    var shouldMaskInDiscreetMode: Bool {
        switch self {
        case .normal: return false
        case .privateItem, .highlyPrivate: return true
        }
    }
}
```

### 12.5 Reminder Frequency Enum

Create:

```text
Models/ReminderFrequency.swift
```

```swift
enum ReminderFrequency: String, CaseIterable, Identifiable {
    case none
    case oneMonth
    case threeMonths
    case sixMonths
    case oneYear
    case custom

    var id: String { rawValue }

    var title: String {
        switch self {
        case .none: return "No Reminder"
        case .oneMonth: return "Every Month"
        case .threeMonths: return "Every 3 Months"
        case .sixMonths: return "Every 6 Months"
        case .oneYear: return "Every Year"
        case .custom: return "Custom Date"
        }
    }
}
```

---

## 13. App Settings Model

Use `@AppStorage` for lightweight settings.

Create:

```text
Settings/AppSettings.swift
```

Suggested keys:

```swift
enum AppSettingsKey {
    static let hasCompletedOnboarding = "hasCompletedOnboarding"
    static let isAppLockEnabled = "isAppLockEnabled"
    static let isDiscreetModeEnabled = "isDiscreetModeEnabled"
    static let defaultReminderFrequency = "defaultReminderFrequency"
    static let sortOption = "sortOption"
}
```

Sort enum:

```swift
enum ItemSortOption: String, CaseIterable, Identifiable {
    case recentlyUpdated
    case nameAscending
    case lastChecked
    case category

    var id: String { rawValue }

    var title: String {
        switch self {
        case .recentlyUpdated: return "Recently Updated"
        case .nameAscending: return "Name"
        case .lastChecked: return "Last Checked"
        case .category: return "Category"
        }
    }
}
```

---

## 14. Project File Structure

Create this folder structure:

```text
SafeSpot/
├── SafeSpotApp.swift
├── RootView.swift
├── Design/
│   ├── AppColors.swift
│   ├── AppSpacing.swift
│   ├── AppCorners.swift
│   └── ViewModifiers.swift
├── Models/
│   ├── StoredItem.swift
│   ├── StoredItem+Computed.swift
│   ├── ItemCategory.swift
│   ├── SensitivityLevel.swift
│   ├── ReminderFrequency.swift
│   └── ItemSortOption.swift
├── Services/
│   ├── AuthenticationService.swift
│   ├── PhotoStorageService.swift
│   ├── ReminderScheduler.swift
│   └── HapticService.swift
├── Settings/
│   └── AppSettings.swift
├── Components/
│   ├── PrimaryButton.swift
│   ├── SecondaryButton.swift
│   ├── SearchField.swift
│   ├── EmptyStateView.swift
│   ├── CategoryChip.swift
│   ├── ItemCardView.swift
│   ├── SectionCard.swift
│   ├── PrivacyBadge.swift
│   └── GlassCard.swift
├── Features/
│   ├── Onboarding/
│   │   └── OnboardingView.swift
│   ├── Lock/
│   │   └── LockView.swift
│   ├── Home/
│   │   ├── HomeView.swift
│   │   ├── HomeHeaderView.swift
│   │   ├── ItemListView.swift
│   │   └── CategoryFilterBar.swift
│   ├── ItemDetail/
│   │   └── ItemDetailView.swift
│   ├── ItemEditor/
│   │   ├── AddItemView.swift
│   │   ├── EditItemView.swift
│   │   ├── ItemEditorView.swift
│   │   ├── ItemEditorViewModel.swift
│   │   ├── PhotoPickerSection.swift
│   │   ├── LocationFieldsSection.swift
│   │   └── ReminderSection.swift
│   └── Settings/
│       ├── SettingsView.swift
│       └── PrivacyStatementView.swift
└── Resources/
    └── Assets.xcassets
```

---

## 15. Root App Setup

### 15.1 SafeSpotApp

Create a SwiftData model container at the app root.

```swift
import SwiftUI
import SwiftData

@main
struct SafeSpotApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: StoredItem.self)
    }
}
```

### 15.2 RootView Responsibilities

`RootView` decides what to show:

- Onboarding if not completed
- Lock screen if app lock is enabled and app is not authenticated
- Home screen otherwise

Pseudo-structure:

```swift
struct RootView: View {
    @AppStorage(AppSettingsKey.hasCompletedOnboarding) private var hasCompletedOnboarding = false
    @AppStorage(AppSettingsKey.isAppLockEnabled) private var isAppLockEnabled = false
    @State private var isAuthenticated = false
    @Environment(\.scenePhase) private var scenePhase

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
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background || newPhase == .inactive {
                if isAppLockEnabled {
                    isAuthenticated = false
                }
            }
        }
    }
}
```

---

## 16. Authentication Service

Create:

```text
Services/AuthenticationService.swift
```

Use `LocalAuthentication`.

Requirements:

- Check whether authentication is available.
- Authenticate with biometrics or device passcode.
- Use a clear reason string.
- Return a boolean result.
- Handle cancellation gracefully.

Suggested implementation:

```swift
import Foundation
import LocalAuthentication

@MainActor
final class AuthenticationService: ObservableObject {
    func authenticate() async -> Bool {
        let context = LAContext()
        var error: NSError?

        let policy: LAPolicy = .deviceOwnerAuthentication

        guard context.canEvaluatePolicy(policy, error: &error) else {
            return false
        }

        do {
            let reason = "Unlock SafeSpot to view your saved items."
            return try await context.evaluatePolicy(policy, localizedReason: reason)
        } catch {
            return false
        }
    }
}
```

### 16.1 Info.plist Requirement

Add:

```text
NSFaceIDUsageDescription = SafeSpot uses Face ID to protect access to your saved items.
```

---

## 17. Photo Storage Service

Photos must be stored locally in the app container.

Create:

```text
Services/PhotoStorageService.swift
```

### 17.1 Rules

- Store photos in Application Support.
- Save compressed JPEG data.
- Use UUID file names.
- Store only the file name in SwiftData.
- Delete photo file when item is deleted.
- Replace old photo file when user changes photo.
- Apply file protection where possible.

### 17.2 Suggested Directory

```text
Application Support/SafeSpot/ItemPhotos/
```

### 17.3 Suggested Implementation Skeleton

```swift
import Foundation
import UIKit

final class PhotoStorageService {
    static let shared = PhotoStorageService()

    private init() {}

    private var photosDirectory: URL {
        let baseURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        let directory = baseURL.appendingPathComponent("SafeSpot/ItemPhotos", isDirectory: true)
        if !FileManager.default.fileExists(atPath: directory.path) {
            try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        }
        return directory
    }

    func saveImage(_ image: UIImage) throws -> String {
        let fileName = UUID().uuidString + ".jpg"
        let url = photosDirectory.appendingPathComponent(fileName)

        guard let data = image.jpegData(compressionQuality: 0.82) else {
            throw PhotoStorageError.encodingFailed
        }

        try data.write(to: url, options: [.atomic, .completeFileProtection])
        return fileName
    }

    func loadImage(fileName: String) -> UIImage? {
        let url = photosDirectory.appendingPathComponent(fileName)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    func deleteImage(fileName: String?) {
        guard let fileName else { return }
        let url = photosDirectory.appendingPathComponent(fileName)
        try? FileManager.default.removeItem(at: url)
    }
}

enum PhotoStorageError: Error {
    case encodingFailed
}
```

---

## 18. Photo Picker

Use `PhotosUI` and `PhotosPicker` for selecting a photo.

Create:

```text
Features/ItemEditor/PhotoPickerSection.swift
```

Requirements:

- Photo is optional.
- User can add, replace, or remove photo.
- Use a modern card UI.
- Do not require photo library permission beyond the system picker.
- Do not upload images anywhere.

Suggested UI copy:

```text
Add Photo
Optional, stored only on this iPhone.
```

If implementing camera capture in MVP, add:

```text
NSCameraUsageDescription = SafeSpot uses the camera only to attach a photo to an item you choose to save.
```

Camera capture is optional for MVP. PhotosPicker is sufficient.

---

## 19. Reminder Scheduler

Create:

```text
Services/ReminderScheduler.swift
```

Use `UserNotifications`.

### 19.1 Rules

- Request notification permission only when the user first creates a reminder.
- Notifications must be local only.
- Notification content must be discreet.
- Do not put item names in notification title or body.
- Cancel existing reminder for an item before scheduling a new one.
- Notification identifier should use the item UUID.

### 19.2 Notification Copy

Title:

```text
SafeSpot
```

Body:

```text
Time to check a saved item.
```

### 19.3 Suggested Scheduler Skeleton

```swift
import Foundation
import UserNotifications

final class ReminderScheduler {
    static let shared = ReminderScheduler()

    private init() {}

    func requestPermissionIfNeeded() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()

        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return true
        case .denied:
            return false
        case .notDetermined:
            do {
                return try await center.requestAuthorization(options: [.alert, .sound, .badge])
            } catch {
                return false
            }
        @unknown default:
            return false
        }
    }

    func scheduleReminder(for item: StoredItem, date: Date) async {
        let granted = await requestPermissionIfNeeded()
        guard granted else { return }

        cancelReminder(for: item.id)

        let content = UNMutableNotificationContent()
        content.title = "SafeSpot"
        content.body = "Time to check a saved item."
        content.sound = .default

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(
            identifier: notificationIdentifier(for: item.id),
            content: content,
            trigger: trigger
        )

        try? await UNUserNotificationCenter.current().add(request)
    }

    func cancelReminder(for itemID: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [notificationIdentifier(for: itemID)]
        )
    }

    private func notificationIdentifier(for itemID: UUID) -> String {
        "safespot.item-reminder.\(itemID.uuidString)"
    }
}
```

---

## 20. Home Screen Specification

Create:

```text
Features/Home/HomeView.swift
```

### 20.1 Home Screen Purpose

The home screen must help users find an item quickly.

The most important element is the search field.

### 20.2 Home Layout

Top-to-bottom layout:

1. Header
2. Search field
3. Category filter chips
4. Sort/filter row
5. Item cards
6. Floating add button or prominent bottom button

### 20.3 Header Copy

When there are no items:

```text
Your safe spots, remembered.
```

When there are items:

```text
What are you looking for?
```

Subtitle:

```text
Find important things you stored away.
```

### 20.4 Search Placeholder

```text
Search passport, keys, drawer...
```

### 20.5 Empty State

Title:

```text
Nothing saved yet
```

Body:

```text
Add your first important item and SafeSpot will remember where you put it.
```

Button:

```text
Add First Item
```

### 20.6 Item Card Content

Normal card:

```text
[icon] Passport
Documents
Home › Bedroom › Wardrobe › Blue box
Last checked: Never
```

Masked card in Discreet Mode:

```text
[lock icon] Private Item
Location hidden
Tap to unlock details
```

### 20.7 Home Filtering Logic

The displayed list should be derived from:

- All non-archived items
- Optional search query
- Optional selected category
- Selected sort option

Filtering requirements:

```swift
let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

let matchesSearch = query.isEmpty || item.searchableText.contains(query)
let matchesCategory = selectedCategory == nil || item.category == selectedCategory
let isVisible = !item.isArchived && matchesSearch && matchesCategory
```

---

## 21. Add/Edit Item Flow

Use one reusable editor view for both add and edit.

Create:

```text
Features/ItemEditor/ItemEditorView.swift
Features/ItemEditor/ItemEditorViewModel.swift
Features/ItemEditor/AddItemView.swift
Features/ItemEditor/EditItemView.swift
```

### 21.1 Editor Sections

The editor should contain these sections:

1. Basic Info
2. Category
3. Location
4. Photo
5. Private Note
6. Sensitivity
7. Reminder
8. Save button

### 21.2 Required Fields

Only one field is strictly required:

- Item name

However, the app should encourage location details.

### 21.3 Field Labels and Placeholders

Item name:

```text
Item Name
Passport, spare keys, USB drive...
```

Place:

```text
Place
Home, office, parents' house...
```

Room:

```text
Room
Bedroom, garage, study...
```

Container:

```text
Container
Wardrobe, drawer, safe, box...
```

Exact spot:

```text
Exact Spot
Top shelf, blue folder, behind documents...
```

Private note:

```text
Private Note
Anything useful to remember later.
```

### 21.4 Validation

Save button must be disabled when:

- Item name is empty after trimming whitespace

Before saving:

- Trim all text fields
- Update `updatedAt`
- If creating, set `createdAt`
- If a reminder date exists, schedule local notification
- If reminder removed, cancel existing notification

### 21.5 Save Success Behavior

After saving:

- Dismiss sheet
- Provide subtle haptic feedback
- New item appears immediately in list

---

## 22. Item Detail Screen

Create:

```text
Features/ItemDetail/ItemDetailView.swift
```

### 22.1 Detail Screen Purpose

The detail screen gives the user the full answer: where the item is and any extra context.

### 22.2 Layout

Top-to-bottom layout:

1. Hero section with photo or icon
2. Item name
3. Category badge
4. Location card
5. Private note card if note exists
6. Reminder card if reminder exists
7. Metadata card
8. Action buttons

### 22.3 Location Card

Title:

```text
Where it is
```

If location exists, display the path:

```text
Home › Bedroom › Wardrobe › Blue box on the top shelf
```

If no location exists:

```text
No location details saved yet.
```

### 22.4 Private Note Card

Title:

```text
Private Note
```

Display note body.

### 22.5 Metadata

Show:

- Created date
- Last updated date
- Last checked date

Copy:

```text
Created
Updated
Last Checked
```

If never checked:

```text
Never
```

### 22.6 Actions

Primary action:

```text
Mark as Checked
```

Secondary actions:

```text
Edit
Delete
```

Delete must show confirmation:

```text
Delete Item?
This will remove the item and its photo from this iPhone. This action cannot be undone.
```

Buttons:

```text
Delete
Cancel
```

---

## 23. Onboarding

Create:

```text
Features/Onboarding/OnboardingView.swift
```

### 23.1 Onboarding Goals

The onboarding must communicate:

- What the app does
- Data stays on device
- Face ID protection is available
- The user can start quickly

### 23.2 Suggested Onboarding Screens

#### Screen 1

Title:

```text
Remember where you keep what matters
```

Body:

```text
Save the exact spot of important things like passports, spare keys, documents, and valuables.
```

Symbol:

```text
archivebox.fill
```

#### Screen 2

Title:

```text
Private by design
```

Body:

```text
No account. No cloud. Your saved items stay on this iPhone.
```

Symbol:

```text
lock.shield.fill
```

#### Screen 3

Title:

```text
Find things fast
```

Body:

```text
Search by item, room, drawer, box, or note whenever you need to find something.
```

Symbol:

```text
magnifyingglass
```

Final button:

```text
Get Started
```

### 23.3 After Onboarding

Set:

```swift
hasCompletedOnboarding = true
```

Optionally ask the user if they want to enable app lock:

```text
Protect SafeSpot with Face ID?
```

Buttons:

```text
Enable Protection
Maybe Later
```

Do not force Face ID during onboarding.

---

## 24. Lock Screen

Create:

```text
Features/Lock/LockView.swift
```

### 24.1 Layout

Show:

- App icon or shield symbol
- Title
- Subtitle
- Unlock button

Copy:

```text
SafeSpot is Locked
Unlock to view your saved items.
Unlock
```

### 24.2 Behavior

- Try authentication automatically when view appears.
- Also provide a manual Unlock button.
- If authentication fails, remain on lock screen.
- Do not reveal item data behind the lock screen.

---

## 25. Settings Screen

Create:

```text
Features/Settings/SettingsView.swift
```

### 25.1 Sections

#### Privacy

- Require Face ID / Passcode
- Discreet Mode

#### Reminders

- Default Reminder

#### About

- Privacy Statement
- Version

### 25.2 Setting Copy

Require Face ID / Passcode:

```text
Require Face ID or Passcode
Protect SafeSpot when opening the app.
```

Discreet Mode:

```text
Discreet Mode
Hide private item names and locations in lists and notifications.
```

Privacy Statement:

```text
Privacy Statement
SafeSpot stores your items locally on this iPhone. The app does not use accounts, cloud sync, tracking SDKs, or remote analytics.
```

---

## 26. Privacy Statement Screen

Create:

```text
Features/Settings/PrivacyStatementView.swift
```

Use this exact text or a polished equivalent:

```text
Privacy Statement

SafeSpot is designed to work locally on your iPhone.

Your saved items, notes, locations, and photos are stored in the app's local container on this device. SafeSpot does not require an account, does not use cloud sync, and does not send your saved content to a server.

If you enable Face ID or Passcode protection, SafeSpot uses Apple's local authentication system to help protect access to the app. SafeSpot never receives your biometric data.

Local reminders are scheduled on this device using iOS notifications. Notification text is intentionally discreet and does not include item names.

SafeSpot does not include advertising SDKs, tracking SDKs, or remote analytics in this version.
```

---

## 27. Modern UI Implementation Notes

### 27.1 Background

Use a premium dark gradient background.

Example:

```swift
LinearGradient(
    colors: [
        AppColors.background,
        Color(red: 0.07, green: 0.08, blue: 0.16),
        Color(red: 0.12, green: 0.09, blue: 0.18)
    ],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
.ignoresSafeArea()
```

### 27.2 Cards

Use rounded cards with subtle borders:

```swift
.background(AppColors.surface.opacity(0.86))
.clipShape(RoundedRectangle(cornerRadius: AppCorners.card, style: .continuous))
.overlay(
    RoundedRectangle(cornerRadius: AppCorners.card, style: .continuous)
        .stroke(Color.white.opacity(0.08), lineWidth: 1)
)
```

### 27.3 Buttons

Primary buttons should have:

- Strong accent color or gradient
- Rounded rectangle shape
- Haptic feedback on tap
- Clear disabled state

### 27.4 Motion

Use subtle animations only:

- Card insertion fade/slide
- Search filtering transition
- Button press scale
- Onboarding page transition

Respect Reduce Motion.

---

## 28. Accessibility Requirements

The app must support:

- Dynamic Type
- VoiceOver labels
- Sufficient contrast
- Large tap targets
- Reduce Motion
- Clear focus order

### 28.1 VoiceOver Examples

Item card:

```text
Passport, Documents, stored in Home, Bedroom, Wardrobe, Blue box.
```

Masked private item:

```text
Private item. Details hidden in Discreet Mode.
```

Add button:

```text
Add new item
```

---

## 29. App Permissions

### 29.1 Required Info.plist Entries

Face ID:

```text
NSFaceIDUsageDescription = SafeSpot uses Face ID to protect access to your saved items.
```

Camera, only if camera capture is implemented:

```text
NSCameraUsageDescription = SafeSpot uses the camera only to attach a photo to an item you choose to save.
```

### 29.2 Avoid Unnecessary Permissions

Do not request:

- Location
- Contacts
- Microphone
- Calendar
- Bluetooth
- Health
- Full photo library access, unless absolutely necessary

Use the system photo picker instead of broad photo library access.

---

## 30. Data Lifecycle

### 30.1 Creating an Item

When user saves a new item:

1. Validate name.
2. Save optional photo to local file storage.
3. Create `StoredItem` in SwiftData.
4. Schedule reminder if selected.
5. Dismiss editor.
6. Refresh list automatically.

### 30.2 Editing an Item

When user edits an item:

1. Load existing values.
2. Allow updates.
3. If photo replaced, delete old photo after new one is successfully saved.
4. Update SwiftData entity.
5. Reschedule reminder if changed.
6. Set `updatedAt = Date.now`.

### 30.3 Deleting an Item

When user deletes an item:

1. Show confirmation dialog.
2. Cancel local notification.
3. Delete local photo file.
4. Delete SwiftData model.
5. Save context.

### 30.4 Marking as Checked

When user taps “Mark as Checked”:

1. Set `lastCheckedAt = Date.now`.
2. Set `updatedAt = Date.now`.
3. If recurring reminder selected, compute next reminder date.
4. Schedule next reminder.
5. Show subtle success UI.

---

## 31. Reminder Frequency Logic

Create helper:

```text
Services/ReminderDateCalculator.swift
```

Suggested behavior:

```swift
struct ReminderDateCalculator {
    static func nextDate(from date: Date = .now, frequency: ReminderFrequency) -> Date? {
        let calendar = Calendar.current
        switch frequency {
        case .none:
            return nil
        case .oneMonth:
            return calendar.date(byAdding: .month, value: 1, to: date)
        case .threeMonths:
            return calendar.date(byAdding: .month, value: 3, to: date)
        case .sixMonths:
            return calendar.date(byAdding: .month, value: 6, to: date)
        case .oneYear:
            return calendar.date(byAdding: .year, value: 1, to: date)
        case .custom:
            return nil
        }
    }
}
```

For custom reminders, use the selected custom date.

---

## 32. Search and Sorting

### 32.1 Search Implementation

Keep search simple for MVP.

Use local text matching:

```swift
func matches(_ item: StoredItem, query: String) -> Bool {
    let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    guard !trimmed.isEmpty else { return true }
    return item.searchableText.contains(trimmed)
}
```

Future enhancement: tokenized search or fuzzy search.

### 32.2 Sorting

Implement sort options:

```swift
func sortedItems(_ items: [StoredItem], option: ItemSortOption) -> [StoredItem] {
    switch option {
    case .recentlyUpdated:
        return items.sorted { $0.updatedAt > $1.updatedAt }
    case .nameAscending:
        return items.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    case .lastChecked:
        return items.sorted { ($0.lastCheckedAt ?? .distantPast) > ($1.lastCheckedAt ?? .distantPast) }
    case .category:
        return items.sorted { $0.category.title < $1.category.title }
    }
}
```

---

## 33. Error Handling

The app should handle errors calmly.

### 33.1 Photo Save Error

Title:

```text
Could Not Save Photo
```

Body:

```text
Your item can still be saved without a photo.
```

### 33.2 Notification Permission Denied

Title:

```text
Reminders Are Disabled
```

Body:

```text
You can enable notifications for SafeSpot in iOS Settings.
```

### 33.3 Authentication Failed

Title:

```text
Could Not Unlock
```

Body:

```text
Please try again.
```

Avoid scary security language.

---

## 34. Haptics

Create:

```text
Services/HapticService.swift
```

Use native feedback:

- Success after save
- Light impact on primary button tap
- Warning on delete confirmation

Implementation skeleton:

```swift
import UIKit

struct HapticService {
    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    static func warning() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }

    static func lightImpact() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}
```

---

## 35. Sample Seed Data for Debug Only

For development previews, create sample items.

Do not ship sample data in production.

Create:

```text
Preview Content/SampleData.swift
```

Example items:

- Passport
- Spare Keys
- Emergency Cash
- USB Backup Drive
- Warranty Documents

Use previews to test:

- Empty state
- Normal item list
- Discreet Mode
- Long item names
- Missing location
- Missing photo

---

## 36. Implementation Plan for Cursor Coding Agent

The coding agent must implement the app in small, verifiable steps.

After each major step:

1. Build the project.
2. Fix compiler errors.
3. Ensure the app launches.
4. Do not continue until the current step works.

---

## 37. Step-by-Step Build Plan

### Step 1 — Create Project

Create a new Xcode iOS app project:

```text
Name: SafeSpot
Interface: SwiftUI
Language: Swift
Minimum iOS: 17.0
Persistence: SwiftData, if available in the template
```

Acceptance criteria:

- Project builds.
- App launches to a placeholder root view.
- No third-party dependencies.

---

### Step 2 — Add Models

Create all model files:

- `StoredItem.swift`
- `StoredItem+Computed.swift`
- `ItemCategory.swift`
- `SensitivityLevel.swift`
- `ReminderFrequency.swift`
- `ItemSortOption.swift`

Acceptance criteria:

- Models compile.
- SwiftData container is configured for `StoredItem`.
- Preview sample item can be created.

---

### Step 3 — Add Design System

Create:

- `AppColors.swift`
- `AppSpacing.swift`
- `AppCorners.swift`
- `ViewModifiers.swift`
- Reusable card style

Acceptance criteria:

- App has a premium dark background.
- Components can use shared colors and spacing.
- No hardcoded color chaos across screens.

---

### Step 4 — Implement Root Flow

Create:

- `RootView.swift`
- `OnboardingView.swift`
- `LockView.swift`
- `HomeView.swift`

Acceptance criteria:

- First launch shows onboarding.
- Completing onboarding shows home.
- AppStorage persists onboarding state.
- LockView can be displayed when lock is enabled.

---

### Step 5 — Implement Home UI

Create:

- Header
- Search field
- Category chips
- Sort menu
- Empty state
- Item card component
- Add item button

Acceptance criteria:

- Empty state works.
- Items display in cards.
- Search filters items.
- Category chips filter items.
- Sort menu changes order.
- Discreet Mode masks private items.

---

### Step 6 — Implement Add Item

Create:

- `ItemEditorViewModel`
- `ItemEditorView`
- `AddItemView`
- Editor sections
- Validation
- Save logic

Acceptance criteria:

- User can create item with name only.
- User can add location fields.
- User can select category.
- User can select sensitivity.
- Item persists after app restart.

---

### Step 7 — Implement Item Detail

Create detail screen.

Acceptance criteria:

- Tapping card opens detail.
- Full location is visible.
- Notes are visible when present.
- Metadata is visible.
- Mark as checked updates date.
- Delete works with confirmation.

---

### Step 8 — Implement Edit Item

Create edit flow using the same editor.

Acceptance criteria:

- User can edit all fields.
- Updated item persists.
- `updatedAt` changes on save.
- Existing values prefill correctly.

---

### Step 9 — Implement Photo Picker and Local Photo Storage

Create:

- `PhotoStorageService`
- `PhotoPickerSection`

Acceptance criteria:

- User can attach optional photo.
- Photo persists after restart.
- User can remove photo.
- Deleted item deletes local photo file.
- No photo upload or cloud dependency exists.

---

### Step 10 — Implement Authentication

Create:

- `AuthenticationService`
- Lock behavior in `RootView`
- Settings toggle

Acceptance criteria:

- User can enable app lock.
- App locks when backgrounded.
- App requires Face ID / passcode on return.
- App data is not visible while locked.

---

### Step 11 — Implement Discreet Mode

Acceptance criteria:

- Toggle exists in settings.
- Private and highly private items are masked in lists.
- Notification text remains generic.
- Detail screen can show full item after app is unlocked.

---

### Step 12 — Implement Local Reminders

Create:

- `ReminderScheduler`
- Reminder selection UI
- Notification permission flow

Acceptance criteria:

- User can set reminder date.
- App requests notification permission only when needed.
- Local notification is scheduled.
- Notification text is generic.
- Editing reminder reschedules notification.
- Deleting item cancels notification.

---

### Step 13 — Implement Settings

Create:

- `SettingsView`
- `PrivacyStatementView`

Acceptance criteria:

- User can toggle app lock.
- User can toggle discreet mode.
- User can read privacy statement.
- Settings UI matches design system.

---

### Step 14 — Polish UI

Polish:

- Empty states
- Animations
- Button states
- Haptics
- Date formatting
- Card spacing
- Dark mode consistency
- Accessibility labels

Acceptance criteria:

- App feels modern and premium.
- UI works on small and large iPhones.
- No clipped text in common layouts.

---

### Step 15 — Testing and Cleanup

Acceptance criteria:

- No compiler warnings that indicate real problems.
- No unused files.
- No dead code.
- No network dependencies.
- App works offline.
- Add/edit/delete/search/reminder flows tested manually.

---

## 38. Suggested Cursor Agent Prompt

Use this prompt in Cursor after creating the Xcode project:

```text
You are an expert iOS software engineer. Implement the SafeSpot app using the specification in specifiche.md. Follow the document strictly.

Hard constraints:
- Native SwiftUI app.
- SwiftData for local persistence.
- English-only user interface.
- No backend.
- No login.
- No cloud sync.
- No analytics SDK.
- No third-party dependencies.
- Everything must work locally on the iPhone.

Work incrementally. After each phase, make sure the project builds before continuing. Prefer clean, production-quality Swift code over quick hacks. Do not introduce features that are marked as out of scope.

Start with the data models, design system, root flow, and home screen. Then proceed through the implementation steps in the spec.
```

---

## 39. App Store Positioning Draft

### 39.1 Short Description

```text
Remember where you keep important things.
```

### 39.2 Longer Description

```text
SafeSpot helps you remember where you placed important items like passports, spare keys, documents, valuables, and backup drives.

Save the exact spot, add an optional photo, write a private note, and find everything quickly with search.

SafeSpot is designed to be private and simple: no account, no cloud sync, and no tracking SDKs. Your saved items stay on your iPhone.
```

### 39.3 Keywords Brainstorm

```text
organizer, inventory, documents, keys, passport, reminder, storage, private, local, home, valuables
```

---

## 40. App Privacy Notes

For the MVP, assuming the implementation follows this spec:

- The app does not create accounts.
- The app does not send saved item data to a server.
- The app does not track users.
- The app does not use third-party analytics SDKs.
- User content is stored locally on device.

Before App Store submission, verify the final implementation carefully in App Store Connect.

Important: Apple requires developers to accurately describe data handling practices. If any SDK or network functionality is added later, the privacy answers must be updated.

---

## 41. Security Notes and Limitations

### 41.1 What the MVP Protects Against

The MVP helps protect casual access by:

- Requiring Face ID / passcode when enabled
- Hiding private item names in Discreet Mode
- Keeping data local
- Avoiding cloud and remote services
- Avoiding tracking SDKs

### 41.2 What the MVP Does Not Claim

The MVP does not claim:

- Full app-level database encryption
- Password manager-grade security
- Multi-device encrypted sync
- Protection against a fully compromised device

### 41.3 Future Security Upgrade

Future versions may add:

- Encrypted export file
- App-level encryption for sensitive notes
- Keychain-stored encryption key
- Per-item unlock for highly private items

Do not implement these in MVP unless explicitly requested.

---

## 42. Edge Cases

Handle these cases:

### 42.1 Empty Item Name

Disable Save button.

### 42.2 Item With No Location

Allow save, but show:

```text
No location details saved yet.
```

### 42.3 Item With No Photo

Show category icon placeholder.

### 42.4 Notification Permission Denied

Save the item anyway. Show a non-blocking message.

### 42.5 Authentication Cancelled

Keep user on LockView.

### 42.6 Deleted Photo Missing on Disk

Do not crash. Show placeholder.

### 42.7 Long Text Fields

Use line limits and wrapping. Avoid UI overflow.

### 42.8 Discreet Mode Search

Search can still match private item content, but result cards should remain masked in the list.

---

## 43. Date Formatting

Create helper:

```text
Utilities/DateFormatters.swift
```

Use user locale for date formatting, but labels remain English.

Suggested display:

```text
May 31, 2026
```

Use `Date.FormatStyle` where possible.

---

## 44. Accessibility Checklist

Before considering the MVP complete:

- [ ] All buttons have readable labels.
- [ ] Item cards have VoiceOver descriptions.
- [ ] Masked items do not reveal sensitive content to VoiceOver.
- [ ] Dynamic Type does not break the main screens.
- [ ] Colors have sufficient contrast.
- [ ] Primary actions are reachable with one hand.
- [ ] Delete confirmation is clear.
- [ ] Reduce Motion does not make navigation confusing.

---

## 45. Manual QA Checklist

### First Launch

- [ ] App opens.
- [ ] Onboarding appears.
- [ ] Onboarding is English only.
- [ ] Get Started works.

### Add Item

- [ ] Add item sheet opens.
- [ ] Save disabled with empty name.
- [ ] Save works with name only.
- [ ] Save works with all fields.
- [ ] Item appears in home list.

### Search

- [ ] Search by item name works.
- [ ] Search by room works.
- [ ] Search by container works.
- [ ] Search by note works.
- [ ] Empty search restores list.

### Detail

- [ ] Detail opens.
- [ ] Location path is correct.
- [ ] Mark as checked works.
- [ ] Edit opens.
- [ ] Delete removes item.

### Photos

- [ ] Add photo works.
- [ ] Replace photo works.
- [ ] Remove photo works.
- [ ] Photo persists after restart.
- [ ] Deleted item removes photo file.

### Privacy

- [ ] Enable Face ID setting works.
- [ ] App locks after backgrounding.
- [ ] Discreet Mode masks private items.
- [ ] Notifications do not reveal item names.

### Offline

- [ ] App works in airplane mode.
- [ ] Add/edit/delete works offline.
- [ ] Search works offline.

---

## 46. Future Roadmap

Do not implement these in MVP, but keep architecture clean enough to support them later.

### Version 1.1 Ideas

- Widgets
- Better reminder presets
- Archive view
- Recently viewed items
- Custom categories
- Custom icons
- Export as PDF inventory

### Version 1.2 Ideas

- Encrypted manual backup/export
- Import from encrypted backup
- Per-item additional unlock
- App icon customization

### Future Advanced Ideas

- OCR for documents
- QR labels for boxes
- Local-only AI suggestions using on-device models
- Apple Watch companion
- Siri Shortcuts

---

## 47. Definition of Done

The MVP is complete when:

- User can complete onboarding.
- User can add an item.
- User can save location details.
- User can attach an optional photo.
- User can search items locally.
- User can view item details.
- User can edit and delete items.
- User can mark items as checked.
- User can enable Face ID / passcode lock.
- User can enable Discreet Mode.
- User can set local reminders.
- App works fully offline.
- App uses English-only UI.
- App has no backend.
- App has no cloud sync.
- App has no analytics SDK.
- App has a modern, polished, premium SwiftUI interface.

---

## 48. Official Apple Documentation References

Use official Apple documentation while implementing:

- SwiftData: https://developer.apple.com/documentation/swiftdata
- SwiftUI model data: https://developer.apple.com/documentation/SwiftUI/Managing-model-data-in-your-app
- LocalAuthentication: https://developer.apple.com/documentation/localauthentication
- Face ID / Touch ID login flow: https://developer.apple.com/documentation/localauthentication/logging-a-user-into-your-app-with-face-id-or-touch-id
- UserNotifications: https://developer.apple.com/documentation/usernotifications
- Scheduling local notifications: https://developer.apple.com/documentation/usernotifications/scheduling-a-notification-locally-from-your-app
- PhotosPicker: https://developer.apple.com/documentation/PhotosUI/PhotosPicker
- Human Interface Guidelines: https://developer.apple.com/design/human-interface-guidelines
- App privacy details: https://developer.apple.com/app-store/app-privacy-details/

---

## 49. Final Instruction to Coding Agent

Implement the app exactly as a focused MVP.

Do not over-engineer.  
Do not add cloud.  
Do not add login.  
Do not add analytics.  
Do not add extra features before the MVP is complete.  
Keep the UI modern, polished, and fully English.  
Prioritize speed, privacy, simplicity, and trust.
