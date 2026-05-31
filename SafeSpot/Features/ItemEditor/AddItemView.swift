import SwiftUI

struct AddItemView: View {
    @AppStorage(AppSettingsKey.defaultReminderFrequency) private var defaultReminderRawValue = ReminderFrequency.none.rawValue

    var body: some View {
        ItemEditorView(defaultReminderFrequency: defaultReminderFrequency)
    }

    private var defaultReminderFrequency: ReminderFrequency {
        ReminderFrequency(rawValue: defaultReminderRawValue) ?? .none
    }
}
