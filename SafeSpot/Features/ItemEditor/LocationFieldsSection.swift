import SwiftUI

struct LocationFieldsSection: View {
    @Bindable var viewModel: ItemEditorViewModel

    var body: some View {
        SectionCard(title: "Location", systemImage: "mappin.and.ellipse") {
            EditorTextField(
                label: "Place",
                placeholder: "Home, office, parents' house...",
                text: $viewModel.place
            )
            EditorTextField(
                label: "Room",
                placeholder: "Bedroom, garage, study...",
                text: $viewModel.room
            )
            EditorTextField(
                label: "Container",
                placeholder: "Wardrobe, drawer, safe, box...",
                text: $viewModel.container
            )
            EditorTextField(
                label: "Exact Spot",
                placeholder: "Top shelf, blue folder, behind documents...",
                text: $viewModel.exactSpot
            )
        }
    }
}

