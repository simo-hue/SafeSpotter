# SafeSpot
> **Find your important things fast. No account. Optional private iCloud sync.**

[<img src=".github/assets/app-store-badge.png" alt="Download SafeSpotter on the App Store" height="54">](https://apps.apple.com/us/app/safespotter/id6775203521)

**[App Store](https://apps.apple.com/us/app/safespotter/id6775203521)** · **[Website](https://simo-hue.github.io/SafeSpotter/)** · **[Privacy](https://simo-hue.github.io/SafeSpotter/privacy.html)** · **[Support](https://simo-hue.github.io/SafeSpotter/support.html)** · Free · iPhone · iOS 17.0+

SafeSpot is a native, local-first iOS "memory vault" designed to help you remember where you placed important physical items, documents, and small valuables. From passports to spare keys and emergency cash, SafeSpot keeps track of your most important belongings with maximum privacy.

> Published on the App Store as **SafeSpotter**.

## Features

- **Organize Your Belongings:** Save items with their specific location (Place, Room, Container, Exact Spot), along with optional photos and private notes.
- **Fast Local Search:** Quickly find items by searching names, categories, places, or notes.
- **Private, Offline-First Storage:** No SafeSpot account and no tracking SDKs. Keep data only on one device or synchronize it through the user's private CloudKit database.
- **Face ID & Passcode Gate:** Lock the app behind biometric authentication (Face ID/Touch ID) or your device passcode for an extra layer of security.
- **Discreet Mode:** Hide sensitive items and notifications so prying eyes can't see your private entries.
- **Local Reminders:** Set custom, discreet local notifications to remind you to check on your stored items.

## Tech Stack

SafeSpot is built exclusively with modern Apple native frameworks and has no third-party dependencies.

- **Language:** Swift
- **UI:** SwiftUI
- **Persistence:** SwiftData
- **Synchronization:** Optional CloudKit private database through SwiftData
- **Media:** PhotosUI
- **Security:** LocalAuthentication
- **Notifications:** UserNotifications

## Privacy and Security Principles

SafeSpot was designed with absolute privacy in mind:
- **No Developer Backend:** When enabled, saved content synchronizes only through the user's private iCloud database; SafeSpot does not operate a content server.
- **No Analytics or Trackers:** What you store is your business alone.
- **Layered Protection:** Local-only storage is available; iCloud mode adds CloudKit encrypted fields for item details and encrypted CloudKit assets for photos.

## Project Structure

- `SafeSpot/Features/`: Contains the main UI modules (Home, Item Detail, Item Editor, Lock, Onboarding, Settings).
- `SafeSpot/Models/`: SwiftData models representing `StoredItem`, categories, and sensitivity levels.
- `SafeSpot/Services/`: Core business logic managers (`AuthenticationService`, `PhotoStorageService`, `ReminderScheduler`, etc.).
- `SafeSpot/Design/`: Application colors, spacing, and reusable SwiftUI components.
- `website/`: Source of the public site — landing page, privacy policy, terms and support.
- `docs/`: Built site published by GitHub Pages at https://simo-hue.github.io/SafeSpotter/ (generated; do not edit by hand).

## Install

The app is free on the App Store, with no in-app purchases and no ads.

**[→ Get SafeSpotter on the App Store](https://apps.apple.com/us/app/safespotter/id6775203521)**

Requires an iPhone on iOS 17.0 or later (it also runs on Apple Silicon Macs and Apple Vision Pro). Questions and bug reports: [support page](https://simo-hue.github.io/SafeSpotter/support.html) or [mattioli.simone.10@gmail.com](mailto:mattioli.simone.10@gmail.com).

## Requirements

- iOS 17.0+
- Xcode 15.0+

## Building from source

1. Clone or download the repository.
2. Open `SafeSpot.xcodeproj` in Xcode.
3. Select your target device or simulator.
4. Build and run (⌘R).

## Website

The site is a static Vite multi-page build with no framework and no third-party requests — fonts, icons and screenshots are all served from the site itself.

```bash
npm --prefix website install   # once
npm --prefix website run dev   # local preview at /SafeSpotter/
npm --prefix website run build # writes the published site into /docs
```

Pushing the regenerated `docs/` folder to `main` publishes it.

---
*SafeSpot — remember where you keep what matters. [Download on the App Store](https://apps.apple.com/us/app/safespotter/id6775203521).*
