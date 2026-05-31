import SwiftData
import SwiftUI

struct ItemEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: ItemEditorViewModel
    @State private var errorMessage: String?

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
            .alert("Could Not Save Item", isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "Please try again.")
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
            try viewModel.save(in: modelContext)
            HapticService.success()
            dismiss()
        } catch {
            errorMessage = "SafeSpot could not save this item. Please try again."
        }
    }
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

