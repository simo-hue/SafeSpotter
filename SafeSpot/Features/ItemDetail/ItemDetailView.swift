import SwiftData
import SwiftUI

struct ItemDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let item: StoredItem
    @State private var isShowingEditItem = false
    @State private var isShowingDeleteConfirmation = false
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.md) {
                hero
                locationSection

                if !item.privateNote.isEmpty {
                    noteSection
                }

                if let reminderDate = item.reminderDate {
                    reminderSection(date: reminderDate)
                }

                metadataSection
                actions
            }
            .padding(AppSpacing.lg)
        }
        .appScreenBackground()
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") {
                    isShowingEditItem = true
                }
            }
        }
        .sheet(isPresented: $isShowingEditItem) {
            EditItemView(item: item)
        }
        .confirmationDialog(
            "Delete Item?",
            isPresented: $isShowingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                deleteItem()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will remove the item and its photo from this iPhone. This action cannot be undone.")
        }
        .alert("Could Not Update Item", isPresented: Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "Please try again.")
        }
        .tint(AppColors.secondary)
    }

    private var hero: some View {
        VStack(spacing: AppSpacing.md) {
            heroImage

            Text(item.name)
                .font(.title.bold())
                .multilineTextAlignment(.center)
                .foregroundStyle(AppColors.textPrimary)

            HStack {
                Label(item.category.title, systemImage: item.category.symbolName)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AppColors.secondary)

                PrivacyBadge(sensitivity: item.sensitivity)
            }
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var heroImage: some View {
        if let image = PhotoStorageService.shared.loadImage(fileName: item.photoFileName) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(height: 230)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: AppCorners.card, style: .continuous))
                .accessibilityLabel("Photo of \(item.name)")
        } else {
            Image(systemName: item.category.symbolName)
                .font(.system(size: 54))
                .foregroundStyle(
                    LinearGradient(
                        colors: [AppColors.secondary, AppColors.primary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 124, height: 124)
                .background(AppColors.elevatedSurface)
                .clipShape(RoundedRectangle(cornerRadius: AppCorners.card, style: .continuous))
                .accessibilityHidden(true)
        }
    }

    private var locationSection: some View {
        SectionCard(title: "Where it is", systemImage: "mappin.circle.fill") {
            Text(item.hasLocation ? item.locationSummary : "No location details saved yet.")
                .foregroundStyle(item.hasLocation ? AppColors.textPrimary : AppColors.textSecondary)
        }
    }

    private var noteSection: some View {
        SectionCard(title: "Private Note", systemImage: "note.text") {
            Text(item.privateNote)
                .foregroundStyle(AppColors.textPrimary)
        }
    }

    private var metadataSection: some View {
        SectionCard(title: "Details", systemImage: "clock.fill") {
            metadataRow(title: "Created", value: DateFormatters.display(item.createdAt))
            metadataRow(title: "Updated", value: DateFormatters.display(item.updatedAt))
            metadataRow(
                title: "Last Checked",
                value: item.lastCheckedAt.map(DateFormatters.displayWithTime) ?? "Never"
            )
        }
    }

    private func reminderSection(date: Date) -> some View {
        SectionCard(title: "Reminder", systemImage: "bell.fill") {
            Text(DateFormatters.displayWithTime(date))
                .foregroundStyle(AppColors.textPrimary)

            Text(item.reminderFrequency.title)
                .font(.caption)
                .foregroundStyle(AppColors.textSecondary)
        }
    }

    private var actions: some View {
        VStack(spacing: AppSpacing.sm) {
            PrimaryButton(title: "Mark as Checked", systemImage: "checkmark.circle.fill") {
                markAsChecked()
            }

            SecondaryButton(title: "Edit", systemImage: "pencil") {
                isShowingEditItem = true
            }

            SecondaryButton(
                title: item.reminderDate == nil ? "Set Reminder" : "Configure Reminder",
                systemImage: "bell"
            ) {
                isShowingEditItem = true
            }

            SecondaryButton(title: "Delete", systemImage: "trash", role: .destructive) {
                HapticService.warning()
                isShowingDeleteConfirmation = true
            }
        }
        .padding(.top, AppSpacing.sm)
    }

    private func metadataRow(title: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(title)
                .foregroundStyle(AppColors.textSecondary)

            Spacer()

            Text(value)
                .multilineTextAlignment(.trailing)
                .foregroundStyle(AppColors.textPrimary)
        }
        .font(.subheadline)
    }

    private func markAsChecked() {
        Task {
            item.lastCheckedAt = .now
            item.updatedAt = .now

            if let nextDate = ReminderDateCalculator.nextDate(frequency: item.reminderFrequency) {
                item.reminderDate = nextDate
            } else if item.reminderFrequency == .custom {
                item.reminderDate = nil
            }

            do {
                try modelContext.save()
                let reminderResult = await ReminderScheduler.shared.updateReminder(for: item)
                if let notice = reminderResult.notice {
                    errorMessage = notice.message
                }
                HapticService.success()
            } catch {
                errorMessage = "SafeSpot could not update this item. Please try again."
            }
        }
    }

    private func deleteItem() {
        let photoFileName = item.photoFileName
        modelContext.delete(item)

        do {
            try modelContext.save()
            PhotoStorageService.shared.deleteImage(fileName: photoFileName)
            ReminderScheduler.shared.cancelReminder(for: item.id)
            HapticService.warning()
            dismiss()
        } catch {
            errorMessage = "SafeSpot could not delete this item. Please try again."
        }
    }
}
