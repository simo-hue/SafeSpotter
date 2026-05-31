import PhotosUI
import SwiftUI
import UIKit

struct PhotoPickerSection: View {
    @Bindable var viewModel: ItemEditorViewModel
    @State private var selectedPickerItem: PhotosPickerItem?

    var body: some View {
        let hasDisplayedImage = viewModel.displayedImage != nil

        SectionCard(title: "Photo", systemImage: "photo.fill") {
            if let image = viewModel.displayedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 190)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: AppCorners.field, style: .continuous))
                    .accessibilityLabel("Attached item photo")
            }

            Text("Optional, stored only on this iPhone.")
                .font(.caption)
                .foregroundStyle(AppColors.textSecondary)

            HStack(spacing: AppSpacing.sm) {
                PhotosPicker(selection: $selectedPickerItem, matching: .images) {
                    Label(hasDisplayedImage ? "Replace Photo" : "Add Photo", systemImage: "photo.badge.plus")
                        .font(.subheadline.weight(.semibold))
                }
                .buttonStyle(.borderedProminent)
                .tint(AppColors.primary)

                if viewModel.displayedImage != nil {
                    Button(role: .destructive) {
                        viewModel.removePhoto()
                        selectedPickerItem = nil
                    } label: {
                        Label("Remove", systemImage: "trash")
                            .font(.subheadline.weight(.semibold))
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .onChange(of: selectedPickerItem) { _, newItem in
            guard let newItem else { return }

            Task {
                guard let data = try? await newItem.loadTransferable(type: Data.self),
                      let image = UIImage(data: data) else {
                    return
                }

                viewModel.selectPhoto(image)
            }
        }
    }
}
