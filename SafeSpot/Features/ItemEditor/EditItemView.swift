import SwiftUI

struct EditItemView: View {
    let item: StoredItem

    var body: some View {
        ItemEditorView(item: item)
    }
}

