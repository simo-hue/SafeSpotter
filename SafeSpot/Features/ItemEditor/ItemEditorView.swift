import SwiftData
import SwiftUI

struct ItemEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: ItemEditorViewModel
    @State private var alert: ItemEditorAlert?

    init(item: StoredItem? = nil) {
        _viewModel = State(initialValue: ItemEditorViewModel(item: item))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.md) {
                    basicInfoSection
                    categorySection
                    LocationFieldsSection(viewModel: viewModel)
                    PhotoPickerSection(viewModel: viewModel)
                    noteSection
                    sensitivitySection

                    PrimaryButton(
                        title: viewModel.isEditing ? "Save Changes" : "Save Item",
                        systemImage: "checkmark",
                        isDisabled: !viewModel.canSave
                    ) {
                        save()
                    }
                    .padding(.top, AppSpacing.sm)
                }
                .padding(AppSpacing.lg)
            }
            .appScreenBackground()
            .navigationTitle(viewModel.isEditing ? "Edit Item" : "Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                    .disabled(!viewModel.canSave)
                }
            }
            .alert(item: $alert) { alert in
                Alert(
                    title: Text(alert.title),
                    message: Text(alert.message),
                    dismissButton: .default(Text("OK")) {
                        if alert.shouldDismissEditor {
                            dismiss()
                        }
                    }
                )
            }
        }
        .tint(AppColors.secondary)
    }

    private var basicInfoSection: some View {
        SectionCard(title: "Basic Info", systemImage: "tag.fill") {
            EditorTextField(
                label: "Item Name",
                placeholder: "Passport, spare keys, USB drive...",
                text: $viewModel.name
            )
        }
    }

    private var categorySection: some View {
        SectionCard(title: "Category", systemImage: "square.grid.2x2.fill") {
            Picker("Category", selection: $viewModel.category) {
                ForEach(ItemCategory.allCases) { category in
                    Label(category.title, systemImage: category.symbolName)
                        .tag(category)
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var noteSection: some View {
        SectionCard(title: "Private Note", systemImage: "note.text") {
            TextField(
                "Anything useful to remember later.",
                text: $viewModel.privateNote,
                axis: .vertical
            )
            .lineLimit(3...7)
            .foregroundStyle(AppColors.textPrimary)
        }
    }

    private var sensitivitySection: some View {
        SectionCard(title: "Sensitivity", systemImage: "lock.shield.fill") {
            Picker("Sensitivity", selection: $viewModel.sensitivity) {
                ForEach(SensitivityLevel.allCases) { sensitivity in
                    Text(sensitivity.title)
                        .tag(sensitivity)
                }
            }
            .pickerStyle(.segmented)

            Text(viewModel.sensitivity.description)
                .font(.caption)
                .foregroundStyle(AppColors.textSecondary)
        }
    }

    private func save() {
        guard viewModel.canSave else { return }

        do {
            let notice = try viewModel.save(in: modelContext)
            HapticService.success()

            if let notice {
                alert = ItemEditorAlert(
                    title: notice.title,
                    message: notice.message,
                    shouldDismissEditor: true
                )
            } else {
                dismiss()
            }
        } catch {
            alert = ItemEditorAlert(
                title: "Could Not Save Item",
                message: "SafeSpot could not save this item. Please try again.",
                shouldDismissEditor: false
            )
        }
    }
}

private struct ItemEditorAlert: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let shouldDismissEditor: Bool
}

struct EditorTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppColors.textSecondary)

            TextField(placeholder, text: $text)
                .foregroundStyle(AppColors.textPrimary)
                .padding(.vertical, AppSpacing.sm)
        }
    }
}
