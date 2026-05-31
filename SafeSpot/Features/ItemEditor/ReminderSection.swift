import SwiftUI

struct ReminderSection: View {
    @Bindable var viewModel: ItemEditorViewModel

    var body: some View {
        SectionCard(title: "Reminder", systemImage: "bell.fill") {
            Picker("Default Reminder", selection: $viewModel.reminderFrequency) {
                ForEach(ReminderFrequency.allCases) { frequency in
                    Text(frequency.title)
                        .tag(frequency)
                }
            }
            .pickerStyle(.menu)

            if viewModel.reminderFrequency == .custom {
                DatePicker(
                    "Reminder Date",
                    selection: $viewModel.customReminderDate,
                    in: Date.now...,
                    displayedComponents: [.date, .hourAndMinute]
                )
            } else if let reminderDate = viewModel.resolvedReminderDate {
                Text("Next reminder: \(DateFormatters.displayWithTime(reminderDate))")
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }

            Text("Local notification only. Item names are never included.")
                .font(.caption)
                .foregroundStyle(AppColors.textSecondary)
        }
    }
}

