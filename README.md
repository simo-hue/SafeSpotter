# SafeSpot
> **Find your important things fast. No account. Private iCloud sync.**

SafeSpot is a native, local-first iOS "memory vault" designed to help you remember where you placed important physical items, documents, and small valuables. From passports to spare keys and emergency cash, SafeSpot keeps track of your most important belongings with maximum privacy.

## Features

- **Organize Your Belongings:** Save items with their specific location (Place, Room, Container, Exact Spot), along with optional photos and private notes.
- **Fast Local Search:** Quickly find items by searching names, categories, places, or notes.
- **Private, Offline-First Sync:** No SafeSpot account and no tracking SDKs. SwiftData stores data locally and synchronizes it through the user's private CloudKit database.
- **Face ID & Passcode Gate:** Lock the app behind biometric authentication (Face ID/Touch ID) or your device passcode for an extra layer of security.
- **Discreet Mode:** Hide sensitive items and notifications so prying eyes can't see your private entries.
- **Local Reminders:** Set custom, discreet local notifications to remind you to check on your stored items.

## Tech Stack

SafeSpot is built exclusively with modern Apple native frameworks and has no third-party dependencies.

- **Language:** Swift
- **UI:** SwiftUI
- **Persistence:** SwiftData
- **Synchronization:** CloudKit private database through SwiftData
- **Media:** PhotosUI
- **Security:** LocalAuthentication
- **Notifications:** UserNotifications

## Privacy and Security Principles

SafeSpot was designed with absolute privacy in mind:
- **No Developer Backend:** Saved content synchronizes only through the user's private iCloud database; SafeSpot does not operate a content server.
- **No Analytics or Trackers:** What you store is your business alone.
- **Layered Protection:** Offline local storage, CloudKit encrypted fields for item details, and encrypted CloudKit assets for photos.

## Project Structure

- `SafeSpot/Features/`: Contains the main UI modules (Home, Item Detail, Item Editor, Lock, Onboarding, Settings).
- `SafeSpot/Models/`: SwiftData models representing `StoredItem`, categories, and sensitivity levels.
- `SafeSpot/Services/`: Core business logic managers (`AuthenticationService`, `PhotoStorageService`, `ReminderScheduler`, etc.).
- `SafeSpot/Design/`: Application colors, spacing, and reusable SwiftUI components.
- `website/`: Source code for the SafeSpot product landing page and legal documentation.

## Requirements

- iOS 17.0+
- Xcode 15.0+

## Getting Started

1. Clone or download the repository.
2. Open `SafeSpot.xcodeproj` in Xcode.
3. Select your target device or simulator.
4. Build and run (⌘R).

---
*SafeSpot - Remember where you keep what matters.*
