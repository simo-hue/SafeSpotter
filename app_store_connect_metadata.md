# App Store Connect Upload Metadata

**App:** SafeSpot  
**Platform:** iOS  
**Primary Language:** English (U.S.)  
**Document purpose:** Copy/paste-ready App Store Connect metadata and submission checklist for the first public release of the app.

> Important: This document assumes the app uses a private CloudKit database for iCloud synchronization, requires no SafeSpot account, has no developer backend, and includes no analytics, advertising, or third-party tracking SDKs. Revalidate the App Privacy answers and Privacy Policy before submitting.

---

## 0. Final App Positioning

### Product Concept
SafeSpot is a private iPhone app that helps users remember where they placed important items, documents, keys, backups, and valuables.

### Core Promise
Remember where you put important things — privately, offline, and without a SafeSpot account.

### Main Differentiators
- Everything remains available offline.
- No account required.
- Private iCloud sync.
- No tracking.
- Face ID protection.
- Designed for important items users do not access every day.

### Target Users
- People who often put important items “somewhere safe” and later forget the exact location.
- Users who want a private, simple way to track where documents, keys, backup drives, cards, or small valuables are stored.
- Users who prefer offline-first apps without subscriptions, app-specific accounts, or developer-operated storage.

---

# 1. App Information

## 1.1 App Name

**Field:** App Name  
**Limit:** Up to 30 characters  
**Recommended value:**

```text
SafeSpot
```

### Alternative Names
Use only if `SafeSpot` is unavailable in App Store Connect.

```text
SafeSpot Private Vault
```

```text
Hidden Place
```

```text
Private Spot
```

```text
Secure Places
```

### Recommendation
Use **SafeSpot** if available. It is short, memorable, international, and clearly connected to the idea of safe places.

---

## 1.2 Subtitle

**Field:** Subtitle  
**Limit:** Up to 30 characters  
**Recommended value:**

```text
Find what you stored safely
```

### Alternative subtitles

```text
Private item locator
```

```text
Remember safe places
```

```text
Your private item memory
```

### Recommendation
Use:

```text
Find what you stored safely
```

This communicates the core use case clearly and does not sound too technical.

---

## 1.3 Bundle ID

**Field:** Bundle ID  
**Recommended value:**

```text
com.simonemattioli.safespot
```

### Notes
- The Bundle ID must match the value configured in Xcode.
- Once a build has been uploaded, this cannot be changed for the app record.
- If your Apple Developer account uses a company/team naming convention, adjust the prefix accordingly.

---

## 1.4 SKU

**Field:** SKU  
**Recommended value:**

```text
SAFESPOT_IOS_001
```

### Notes
- The SKU is for internal tracking only.
- Users do not see it.
- It cannot be changed after the app is created in App Store Connect.

---

## 1.5 Primary Language

**Field:** Primary Language  
**Recommended value:**

```text
English (U.S.)
```

### Notes
The app must be shipped in one language only: English.

Do not add other App Store localizations for the first release.

---

## 1.6 Category

**Field:** Primary Category  
**Recommended value:**

```text
Productivity
```

**Field:** Secondary Category  
**Recommended value:**

```text
Utilities
```

### Rationale
SafeSpot helps users organize and retrieve personal information about physical items. It fits best under Productivity, with Utilities as a secondary category.

---

## 1.7 Content Rights

**Field:** Content Rights  
**Recommended answer:**

```text
No, this app does not contain, show, or access third-party content.
```

### Explanation for internal use
The app does not provide a content feed, media catalog, third-party articles, web content, or licensed materials. Users may add their own photos and notes locally on their device.

---

## 1.8 Made for Kids

**Field:** Made for Kids  
**Recommended answer:**

```text
No
```

### Explanation
SafeSpot is not designed specifically for children and should not be listed in the Kids category.

---

## 1.9 License Agreement

**Field:** License Agreement  
**Recommended value:**

```text
Apple Standard License Agreement
```

### Notes
Use Apple’s standard EULA unless you have a custom legal agreement prepared.

---

# 2. App Store Version Information

## 2.1 Version Number

**Field:** Version Number  
**Recommended value:**

```text
1.0.0
```

---

## 2.2 Copyright

**Field:** Copyright  
**Recommended value:**

```text
2026 Simone Mattioli
```

### Notes
- App Store Connect automatically adds the copyright symbol.
- If publishing through a company, replace with the legal entity name.

Example:

```text
2026 [Company Name]
```

---

## 2.3 Promotional Text

**Field:** Promotional Text  
**Limit:** Up to 170 characters  
**Recommended value:**

```text
Save where you keep important items, protect them with Face ID, and sync privately with iCloud. No SafeSpot account or tracking.
```

### Character count
130 characters approximately.

### Alternative promotional text

```text
A private place to remember where your important things are stored. Face ID protected, local-first, and simple by design.
```

---

## 2.4 Description

**Field:** Description  
**Limit:** Up to 4000 characters  
**Recommended value:**

```text
SafeSpot helps you remember where you placed important things — privately, securely, and without an account.

We all do it: we put something important in a “safe place” and months later we cannot remember exactly where it is. A spare key, passport, backup drive, document, card, folder, small valuable, or emergency item can disappear simply because the location was never written down clearly.

SafeSpot gives you a simple private memory for those important places.

Add an item, describe where it is stored, attach an optional photo, protect everything with Face ID, and find it instantly when you need it.

WHY SAFESPOT

• Remember where important items are stored
• Save the exact place: room, container, drawer, box, shelf, or custom note
• Add optional photos for visual memory
• Search items quickly by name, category, location, or note
• Protect access with Face ID or device passcode
• Use Private Mode for sensitive items
• Set local reminders to check important items periodically
• Keep everything available offline
• No account required
• Private iCloud sync
• No tracking
• No ads

PRIVATE BY DESIGN

SafeSpot is built for personal information that should stay personal. Your saved items, notes, photos, and locations remain available offline and synchronize through your private iCloud database. The app does not require a SafeSpot account or upload content to a developer server.

PERFECT FOR

• Passports and identity documents
• Spare keys
• Backup drives and USB sticks
• Important folders and papers
• Warranty documents
• Emergency items
• Small valuables
• Travel documents
• SIM cards and cards
• Items stored in boxes, drawers, closets, safes, or hidden places

SIMPLE AND FAST

SafeSpot is intentionally focused. It is not a password manager, not a cloud inventory system, and not a complicated database. It is a clean, modern, private app for one very common problem: remembering where you put something important.

Your important things deserve a place you can trust.
```

---

## 2.5 Short Description for Internal Marketing Use

This is not always a direct App Store Connect field, but it is useful for screenshots, landing pages, press kits, or social posts.

```text
SafeSpot is a private iPhone app that helps you remember where you stored important items, documents, keys, and valuables, with Face ID protection and private iCloud sync.
```

---

## 2.6 Keywords

**Field:** Keywords  
**Limit:** Up to 100 bytes  
**Recommended value:**

```text
items,keys,passport,documents,storage,organizer,reminders,privacy,home,drawer,backup
```

### Notes
- Do not repeat the app name in the keyword field.
- Do not include competitor names.
- Do not include trademarked terms that are not yours.
- Keep keywords comma-separated without spaces to save bytes.

### Alternative keyword set

```text
items,keys,documents,storage,organizer,private,reminder,home,drawer,folder,valuables
```

---

## 2.7 Support URL

**Field:** Support URL  
**Required:** Yes  
**Recommended value:**

```text
https://[YOUR-DOMAIN]/safespot/support
```

### Minimum content required on the support page
The support page should include:

- App name
- Contact email
- Basic FAQ
- Bug report instructions
- Feature request instructions
- Privacy Policy link

### Suggested support email

```text
support@[YOUR-DOMAIN]
```

If you do not have a custom domain yet, create one before submission. A real support URL is required and should lead to actual contact information.

---

## 2.8 Marketing URL

**Field:** Marketing URL  
**Required:** No  
**Recommended value:**

```text
https://[YOUR-DOMAIN]/safespot
```

### Notes
Optional, but recommended for credibility.

---

## 2.9 Privacy Policy URL

**Field:** Privacy Policy URL  
**Required:** Yes for iOS apps  
**Recommended value:**

```text
https://[YOUR-DOMAIN]/safespot/privacy
```

Use the Privacy Policy text in Section 11 of this document to create the webpage.

---

# 3. Screenshots and App Preview

## 3.1 Screenshot Requirements

Prepare App Store screenshots for the iPhone sizes requested by App Store Connect.

### Recommended screenshot count
Use 6 screenshots for the first release.

### Visual style
- Modern iOS design
- Dark premium background
- Soft gradients
- Rounded cards
- Clean typography
- High contrast
- Minimal copy
- English only
- No exaggerated claims
- No fake device functionality

---

## 3.2 Screenshot Copy

### Screenshot 1

**Title:**

```text
Remember where it is
```

**Subtitle:**

```text
Save the exact place where you keep important items.
```

---

### Screenshot 2

**Title:**

```text
Store every detail
```

**Subtitle:**

```text
Add a room, drawer, box, note, and optional photo.
```

---

### Screenshot 3

**Title:**

```text
Find it fast
```

**Subtitle:**

```text
Search by item, location, category, or note.
```

---

### Screenshot 4

**Title:**

```text
Protected with Face ID
```

**Subtitle:**

```text
Keep private item locations away from curious eyes.
```

---

### Screenshot 5

**Title:**

```text
Private Mode
```

**Subtitle:**

```text
Hide sensitive names until you unlock them.
```

---

### Screenshot 6

**Title:**

```text
Private by design
```

**Subtitle:**

```text
No SafeSpot account. Private iCloud sync. No tracking.
```

---

## 3.3 Optional App Preview Video

**Field:** App Preview  
**Required:** No  
**Recommendation:** Skip for version 1.0 unless you already have a polished 15–30 second video.

### Optional 30-second script

```text
0–3s: Show the app icon and tagline: “Remember where it is.”
3–8s: Add a new item: “Spare keys”.
8–13s: Fill location details: “Home > Bedroom > Top drawer”.
13–17s: Attach an optional photo.
17–22s: Search for “keys” and open the saved item.
22–26s: Show Face ID / privacy screen.
26–30s: End screen: “No SafeSpot account. Private iCloud sync. No tracking.”
```

---

# 4. Pricing and Monetization

## 4.1 Recommended Model

**Model:** Free app with optional one-time lifetime unlock.

### Free version

```text
Free to download, limited to 10 saved items.
```

### Paid unlock

```text
One-time purchase to unlock unlimited saved items and premium privacy features.
```

---

## 4.2 App Price

**Field:** App Price  
**Recommended value:**

```text
Free
```

---

## 4.3 In-App Purchase

**Type:** Non-Consumable  
**Recommended Product ID:**

```text
safespot.pro.lifetime
```

**Reference Name:**

```text
SafeSpot Pro Lifetime
```

**Display Name:**

```text
SafeSpot Pro
```

**Description:**

```text
Unlock unlimited saved items and premium privacy features with one lifetime purchase.
```

**Recommended price:**

```text
[Choose a local price point, for example USD 4.99–9.99 / EUR 5.99–9.99]
```

### Notes
- Use a non-consumable purchase, not a subscription.
- Do not mention specific prices inside the App Store description because prices can vary by region.
- Make sure the app remains useful before purchase.

---

## 4.4 Subscription

**Recommended answer:**

```text
No subscription.
```

---

## 4.5 Advertising

**Recommended answer:**

```text
No ads.
```

---

# 5. App Privacy

## 5.1 Privacy Assumptions for This Submission

Use the following answers only if the shipped build matches all these conditions:

- No user account
- No login
- No backend
- Private CloudKit synchronization
- No analytics SDK
- No crash reporting SDK controlled by the developer
- No advertising SDK
- No tracking SDK
- No third-party data sharing
- Private CloudKit database only
- No developer-accessible user content
- Photos, notes, and item data remain available offline and sync through the user's private iCloud database
- Reminder alerts are local; CloudKit uses silent remote notifications for synchronization
- Face ID/passcode is handled locally by iOS

---

## 5.2 App Privacy: Data Collection

**Question:** Do you or your third-party partners collect data from this app?  
**Recommended answer:**

```text
No, we do not collect data from this app.
```

### Internal explanation
The app stores user-created content locally and in the user's private CloudKit database. Apple documents that private-database records are not visible to the app developer through the Developer Portal.

If you add analytics, remote crash reporting, ads, a developer backend, support chat, email capture, remote logging, or any third-party SDK that collects data, this answer must be changed.

---

## 5.3 App Privacy: Tracking

**Recommended answer:**

```text
No tracking.
```

### IDFA

```text
The app does not use IDFA.
```

### App Tracking Transparency

```text
The app does not request App Tracking Transparency permission.
```

---

## 5.4 Data Linked to User

**Recommended answer:**

```text
None.
```

---

## 5.5 Data Not Linked to User

**Recommended answer:**

```text
None.
```

---

## 5.6 Permission Usage Summary

These are not App Store privacy labels by themselves, but they should match your app behavior and Info.plist permission strings.

### Face ID

```text
Used locally to protect access to saved items. Face ID data is handled by iOS and is not accessed, collected, or stored by SafeSpot.
```

### Camera

```text
Used only when the user chooses to take a photo of an item or storage location.
```

### Photos

```text
Used only when the user chooses to attach an existing photo to a saved item.
```

### Notifications

```text
Used only to schedule local reminders selected by the user.
```

---

# 6. Age Rating

## 6.1 Recommended Age Rating Inputs

Use these answers if the app does not include any mature, web, social, medical, gambling, or user-shared content.

### Violence

```text
None
```

### Cartoon or Fantasy Violence

```text
None
```

### Realistic Violence

```text
None
```

### Sexual Content or Nudity

```text
None
```

### Profanity or Crude Humor

```text
None
```

### Alcohol, Tobacco, Drug Use, or References

```text
None
```

### Mature or Suggestive Themes

```text
None
```

### Horror or Fear Themes

```text
None
```

### Medical or Treatment Information

```text
None
```

### Gambling and Contests

```text
None
```

### Simulated Gambling

```text
None
```

### Unrestricted Web Access

```text
No
```

### User-Generated Content Shared Online

```text
No
```

### Messaging or Chat

```text
No
```

### Location Sharing

```text
No
```

### Expected age rating

```text
4+ / All Ages, depending on the App Store Connect questionnaire result.
```

### Important note
The final rating is determined by App Store Connect based on the questionnaire. Do not manually claim a rating that differs from Apple’s generated result.

---

# 7. App Review Information

## 7.1 Contact Information

**Field:** First Name / Last Name  
**Value:**

```text
[YOUR FIRST NAME] [YOUR LAST NAME]
```

**Field:** Phone Number  
**Value:**

```text
[YOUR PHONE NUMBER WITH COUNTRY CODE]
```

**Field:** Email  
**Value:**

```text
[YOUR REVIEW CONTACT EMAIL]
```

---

## 7.2 Sign-In Required

**Field:** Sign-in Required  
**Recommended answer:**

```text
No
```

### Explanation
SafeSpot does not require an account or login.

---

## 7.3 Demo Account

**Recommended value:**

```text
Not applicable. The app does not require sign-in.
```

---

## 7.4 Review Notes

**Field:** Notes  
**Limit:** Up to 4000 bytes  
**Recommended value:**

```text
SafeSpot is a local-first iOS app that helps users remember where they stored important personal items.

No sign-in is required. No demo account is needed.

To test the app:
1. Launch the app.
2. Complete the short onboarding.
3. Add a sample item, such as “Spare keys”.
4. Enter a sample location, such as “Home > Bedroom > Top drawer”.
5. Optionally attach a photo.
6. Use search to find the item.
7. Enable Face ID protection in Settings if prompted.
8. Optionally create a local reminder for the item.

Saved item data remains available offline and synchronizes through the review device's private iCloud database when iCloud is available. The app does not require a SafeSpot account, does not include advertising, and does not use third-party tracking.

If Face ID is unavailable on the review device, the app should fall back to the device passcode through iOS LocalAuthentication.
```

---

# 8. Version Release Settings

## 8.1 Release Option

**Recommended value:**

```text
Manual release after approval
```

### Rationale
This gives you control over the exact launch timing after App Review approves the build.

---

## 8.2 Phased Release

**Recommended value for version 1.0:**

```text
Disabled
```

### Rationale
For the first public release, use a normal release. Enable phased release later for updates if needed.

---

## 8.3 What’s New

**First version:** Not available / not required.  
**For future updates, use this template:**

```text
Thank you for using SafeSpot.

This update includes:
• [Feature or improvement]
• [Bug fix]
• [Performance or design improvement]

Everything remains private, local, and account-free.
```

---

# 9. Export Compliance

## 9.1 Recommended Export Compliance Notes

Answer based on the actual shipped build.

### If the app does not implement custom encryption
Recommended internal answer:

```text
The app does not implement custom encryption and does not transmit data over a network. It uses standard Apple system frameworks only.
```

### If the app uses encrypted export, custom CryptoKit encryption, encrypted backup files, or custom cryptography
Do not use the answer above. Complete the export compliance questionnaire according to the actual encryption implementation.

### Important
Face ID / LocalAuthentication by itself does not mean the app implements custom encryption. However, if you add encrypted export or custom data encryption, update this section before submission.

---

# 10. Digital Services Act / EU Trader Status

## 10.1 EU Trader Status

**Field:** Trader status under the EU Digital Services Act  
**Recommended value:**

```text
[SELECT BASED ON YOUR LEGAL/COMMERCIAL STATUS]
```

### Notes
If you distribute in the European Union, App Store Connect may ask whether you are a trader. This depends on your legal and commercial status, not the app’s functionality.

If you are selling an app or in-app purchase as a commercial activity, review Apple’s DSA requirements carefully and provide the required contact details if needed.

---

# 11. Privacy Policy Page Text

Use this text for:

```text
https://[YOUR-DOMAIN]/safespot/privacy
```

Replace placeholders before publishing.

---

# Privacy Policy for SafeSpot

**Effective date:** [MONTH DAY, 2026]

SafeSpot is designed to be private, offline-first, and simple. This Privacy Policy explains how the SafeSpot iOS app handles information.

## 1. Overview

SafeSpot helps you save where you keep important items, documents, keys, backups, and valuables. The app stores an offline copy on your device and synchronizes through your private iCloud database.

We do not require a SafeSpot account or operate a developer backend for your saved content. We do not sell your data. We do not use advertising or third-party tracking.

## 2. Data We Collect

SafeSpot does not collect personal data from the app.

The information you enter in the app, including item names, locations, notes, categories, photos, and reminders, is stored locally and synchronized through Apple's CloudKit service in your private iCloud database. It is not sent to SafeSpot servers.

## 3. Local Storage

SafeSpot stores your saved items on your iPhone. This may include:

- Item names
- Categories
- Location details
- Notes
- Optional photos
- Reminder settings
- App preferences

This information remains available offline and may synchronize to your other devices signed in to the same iCloud account.

## 4. Photos and Camera

SafeSpot may ask for access to the camera or photo library only when you choose to attach a photo to an item.

Photos you add are used only inside the app, stored locally, and synchronized as encrypted assets through your private iCloud database. They are not uploaded to SafeSpot servers.

## 5. Face ID and Device Passcode

SafeSpot may use Face ID or your device passcode to protect access to the app. Face ID and passcode authentication are handled by iOS. SafeSpot does not receive, store, or access your biometric data.

## 6. Notifications

SafeSpot may ask permission to send notifications if you choose to create reminders. These reminders are local notifications scheduled on your device. Reminder content is not sent to us.

## 7. In-App Purchases

If SafeSpot offers an optional in-app purchase, payments are processed by Apple through the App Store. We do not receive your payment card details.

## 8. Analytics and Tracking

SafeSpot does not use third-party analytics, advertising SDKs, or tracking technologies.

The app does not track you across apps or websites owned by other companies.

## 9. Third-Party Services

SafeSpot does not use a developer-operated backend service to store your saved items. Synchronization is provided by Apple's CloudKit service through the user's private iCloud database.

## 10. Children’s Privacy

SafeSpot is not specifically directed to children. We do not knowingly collect personal information from children.

## 11. Data Deletion

You can delete individual items inside the app, which synchronizes their deletion through iCloud. Deleting the app removes its local copy but may not remove data already synchronized to iCloud.

## 12. Changes to This Policy

We may update this Privacy Policy from time to time. If we make material changes, we will update the effective date above.

## 13. Contact

If you have questions about this Privacy Policy or SafeSpot, contact us at:

```text
[YOUR SUPPORT EMAIL]
```

---

# 12. Support Page Text

Use this text for:

```text
https://[YOUR-DOMAIN]/safespot/support
```

Replace placeholders before publishing.

---

# SafeSpot Support

SafeSpot helps you remember where you stored important items, documents, keys, backups, and valuables.

## Contact

For support, bug reports, or feature requests, contact:

```text
[YOUR SUPPORT EMAIL]
```

## Frequently Asked Questions

### Do I need an account?
No. SafeSpot does not require an account.

### Is my data uploaded to the cloud?
SafeSpot synchronizes saved items, notes, reminder settings, and photos through your private iCloud database so they can appear on your devices. SafeSpot does not operate a developer content server.

### Does SafeSpot track me?
No. SafeSpot does not use tracking or advertising SDKs.

### Can I protect the app with Face ID?
Yes. SafeSpot can use Face ID or the device passcode to protect access to your saved items.

### What happens if I delete the app?
Deleting the app may delete its local data from your device. Make sure you understand your device backup settings before deleting the app.

### How do I report a bug?
Email us at [YOUR SUPPORT EMAIL] with your device model, iOS version, app version, and a short description of the issue.

## Privacy Policy

Read the Privacy Policy here:

```text
https://[YOUR-DOMAIN]/safespot/privacy
```

---

# 13. Marketing Landing Page Text

Use this text for:

```text
https://[YOUR-DOMAIN]/safespot
```

---

# SafeSpot

## Remember where you put important things.

SafeSpot is a private iPhone app that helps you save and find the exact place where you keep important items, documents, keys, backups, and valuables.

No SafeSpot account. Private iCloud sync. No tracking.

## Why SafeSpot?

You put something important in a safe place. Weeks or months later, you need it — but you cannot remember exactly where it is.

SafeSpot gives you a simple private memory for those places.

## Features

- Save important items and their exact locations
- Add rooms, drawers, boxes, shelves, and notes
- Attach optional photos
- Search instantly
- Protect access with Face ID
- Use Private Mode for sensitive items
- Set local reminders
- Keep everything on your iPhone

## Private by design

SafeSpot does not require an account and does not upload your saved items to a server.

## Download

```text
[APP STORE LINK - ADD AFTER RELEASE]
```

## Support

```text
https://[YOUR-DOMAIN]/safespot/support
```

## Privacy

```text
https://[YOUR-DOMAIN]/safespot/privacy
```

---

# 14. Info.plist Permission Strings

These are not App Store Connect fields, but they must be consistent with the app’s functionality and App Review notes.

## 14.1 Face ID

**Key:** `NSFaceIDUsageDescription`

```text
Use Face ID to protect access to your private saved items.
```

---

## 14.2 Camera

**Key:** `NSCameraUsageDescription`

```text
Take photos of items or storage locations you choose to save.
```

---

## 14.3 Photo Library

**Key:** `NSPhotoLibraryUsageDescription`

```text
Choose photos to attach to your saved items.
```

---

## 14.4 Photo Library Additions

Only include this if the app saves images back to the user’s photo library.

**Key:** `NSPhotoLibraryAddUsageDescription`

```text
Save images you choose to export from SafeSpot to your photo library.
```

---

# 15. App Store Review Compliance Checklist

Before submitting, confirm the following:

- [ ] App is fully in English.
- [ ] No Italian strings remain in the UI.
- [ ] App name in Xcode matches App Store Connect.
- [ ] Bundle ID matches App Store Connect.
- [ ] Version number is `1.0.0` or chosen release version.
- [ ] Build number is incremented correctly.
- [ ] App icon is uploaded in all required sizes.
- [ ] Launch screen looks polished.
- [ ] App does not crash on first launch.
- [ ] App works with a clean install.
- [ ] App works without internet connection.
- [ ] Face ID fallback works with passcode if available.
- [ ] App remains usable if Face ID is not available.
- [ ] Adding an item works.
- [ ] Editing an item works.
- [ ] Deleting an item works.
- [ ] Search works.
- [ ] Private Mode works.
- [ ] Local reminders work.
- [ ] Notification permission request is user-initiated and clear.
- [ ] Camera permission request is user-initiated and clear.
- [ ] Photo picker/photo permission behavior is user-initiated and clear.
- [ ] No analytics SDK is included.
- [ ] No advertising SDK is included.
- [ ] No tracking SDK is included.
- [ ] No backend endpoint is called.
- [ ] Privacy label matches actual app behavior.
- [ ] Privacy Policy is live and accessible.
- [ ] Support URL is live and accessible.
- [ ] In-app purchase, if used, is configured and testable.
- [ ] Restore purchases works if in-app purchase is implemented.
- [ ] App Review notes explain how to test the app.
- [ ] No placeholder text remains in the shipped app.
- [ ] Screenshots are accurate and do not show features not in the build.

---

# 16. App Store Connect Copy/Paste Summary

Use this quick section during upload.

## App Name

```text
SafeSpot
```

## Subtitle

```text
Find what you stored safely
```

## Primary Category

```text
Productivity
```

## Secondary Category

```text
Utilities
```

## Promotional Text

```text
Save where you keep important items, protect them with Face ID, and sync privately with iCloud. No SafeSpot account or tracking.
```

## Description

```text
SafeSpot helps you remember where you placed important things — privately, securely, and without an account.

We all do it: we put something important in a “safe place” and months later we cannot remember exactly where it is. A spare key, passport, backup drive, document, card, folder, small valuable, or emergency item can disappear simply because the location was never written down clearly.

SafeSpot gives you a simple private memory for those important places.

Add an item, describe where it is stored, attach an optional photo, protect everything with Face ID, and find it instantly when you need it.

WHY SAFESPOT

• Remember where important items are stored
• Save the exact place: room, container, drawer, box, shelf, or custom note
• Add optional photos for visual memory
• Search items quickly by name, category, location, or note
• Protect access with Face ID or device passcode
• Use Private Mode for sensitive items
• Set local reminders to check important items periodically
• Keep everything available offline
• No account required
• Private iCloud sync
• No tracking
• No ads

PRIVATE BY DESIGN

SafeSpot is built for personal information that should stay personal. Your saved items, notes, photos, and locations remain available offline and synchronize through your private iCloud database. The app does not require a SafeSpot account or upload content to a developer server.

PERFECT FOR

• Passports and identity documents
• Spare keys
• Backup drives and USB sticks
• Important folders and papers
• Warranty documents
• Emergency items
• Small valuables
• Travel documents
• SIM cards and cards
• Items stored in boxes, drawers, closets, safes, or hidden places

SIMPLE AND FAST

SafeSpot is intentionally focused. It is not a password manager, not a cloud inventory system, and not a complicated database. It is a clean, modern, private app for one very common problem: remembering where you put something important.

Your important things deserve a place you can trust.
```

## Keywords

```text
items,keys,passport,documents,storage,organizer,reminders,privacy,home,drawer,backup
```

## Support URL

```text
https://[YOUR-DOMAIN]/safespot/support
```

## Marketing URL

```text
https://[YOUR-DOMAIN]/safespot
```

## Privacy Policy URL

```text
https://[YOUR-DOMAIN]/safespot/privacy
```

## Version

```text
1.0.0
```

## Copyright

```text
2026 Simone Mattioli
```

## Review Notes

```text
SafeSpot is a local-first iOS app that helps users remember where they stored important personal items.

No sign-in is required. No demo account is needed.

To test the app:
1. Launch the app.
2. Complete the short onboarding.
3. Add a sample item, such as “Spare keys”.
4. Enter a sample location, such as “Home > Bedroom > Top drawer”.
5. Optionally attach a photo.
6. Use search to find the item.
7. Enable Face ID protection in Settings if prompted.
8. Optionally create a local reminder for the item.

Saved item data remains available offline and synchronizes through the review device's private iCloud database when an iCloud account is available. The app does not require a SafeSpot account, does not include advertising, and does not use third-party tracking.

If Face ID is unavailable on the review device, the app should fall back to the device passcode through iOS LocalAuthentication.
```

---

# 17. Final Pre-Submission Decisions To Replace

Before upload, replace all placeholders below:

- `[YOUR-DOMAIN]`
- `[YOUR SUPPORT EMAIL]`
- `[YOUR FIRST NAME] [YOUR LAST NAME]`
- `[YOUR PHONE NUMBER WITH COUNTRY CODE]`
- `[YOUR REVIEW CONTACT EMAIL]`
- `[MONTH DAY, 2026]`
- `[APP STORE LINK - ADD AFTER RELEASE]`
- `[SELECT BASED ON YOUR LEGAL/COMMERCIAL STATUS]`
- `[Choose a local price point, for example USD 4.99–9.99 / EUR 5.99–9.99]`

---

# 18. Recommended Launch Setup

## Recommended first release settings

```text
Primary language: English (U.S.)
App price: Free
IAP: Non-consumable lifetime unlock
Release: Manual after approval
App Privacy: No data collected, if the build matches the assumptions in this document
Made for Kids: No
Category: Productivity
Secondary Category: Utilities
Support URL: Required and live before submission
Privacy Policy URL: Required and live before submission
```

## Recommended launch message

```text
SafeSpot is now available for iPhone: a private way to remember where you keep important items. No SafeSpot account. Private iCloud sync. No tracking.
```

---

# 19. Important Accuracy Warning

Do not submit this metadata blindly if the implementation changes.

Update this document before submission if the app adds any of the following:

- Account creation
- Public or shared CloudKit databases
- A developer-operated synchronization service
- Backend APIs
- Email login
- Social login
- Analytics
- Crash reporting SDKs
- Ads
- Tracking
- Support chat SDKs
- Remote config
- Push notifications from a server
- Encrypted export
- Shared family vaults
- Collaboration features
- Web content
- AI features that send data to a model API

Any of these changes may require changes to the privacy label, privacy policy, review notes, export compliance, and App Store description.
