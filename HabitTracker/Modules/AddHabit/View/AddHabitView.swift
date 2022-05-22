//
//  AddHabitView.swift
//  HabitTracker
//
//  Created by Ali Mert Özhayta on 19.05.2022.
//

import SwiftUI

struct AddHabitView: View {
    @StateObject private var viewModel: AddHabitViewModel
    @Environment(\.self) private var env

    init(editHabit: Habit? = nil) {
        _viewModel = StateObject(wrappedValue: AddHabitViewModel(editHabit: editHabit))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 15) {

                // MARK: TextField - Title
                TextField("Title", text: $viewModel.title)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color("TFBG").opacity(0.4), in: RoundedRectangle(cornerRadius: 6, style: .continuous))

                // MARK: Habit Color Picker
                HStack(spacing: 0) {
                    ForEach(1...7, id: \.self) { index in
                        let color = "Card-\(index)"
                        Circle()
                            .fill(Color(color))
                            .frame(width: 30, height: 30)
                            .maxWidth()
                            .overlay {
                                if color == viewModel.habitColor {
                                    Image(systemName: "checkmark")
                                        .font(.caption.bold())
                                        .foregroundColor(.white)
                                        .shadow(color: .black, radius: 0.5, x: 0.5, y: 0.5)
                                }
                            }
                            .onTapGesture {
                                withAnimation {
                                    viewModel.habitColor = color
                                }
                            }
                    }
                }
                .padding(.vertical)

                Divider()

                // MARK: Frequency Selection (weekdays)
                VStack(alignment: .leading, spacing: 6) {
                    Text("Frequency")
                    HStack(spacing: 10) {
                        let weekdays = Calendar.current.weekdaySymbols
                        ForEach(weekdays, id: \.self) { day in
                            let index = viewModel.weekdays.firstIndex(where: { $0 == day })
                            // MARK: Limiting to First 2 Letters
                            Text(day.prefix(3))
                                .font(.callout)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                                .maxWidth()
                                .padding(.vertical, 12)
                                .padding(.horizontal, 3)
                                .background {
                                    let color = index == nil ? Color("TFBG") : Color(viewModel.habitColor)
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(color.opacity(0.4))
                                }
                                .onTapGesture {
                                    withAnimation {
                                        if let index = index {
                                            viewModel.weekdays.remove(at: index)
                                        } else {
                                            viewModel.weekdays.append(day)
                                        }
                                    }
                                }
                        }
                    }
                    .padding(.vertical, 15)
                }
                .padding(.vertical, 10)

                if viewModel.notificationAccess {
                    Divider()

                    // MARK: Reminder Toggle
                    // Hiding If Notification access is rejected
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Reminder")
                                .fontWeight(.semibold)

                            Text("Just notification")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Toggle(isOn: $viewModel.isReminderOn, label: {})
                            .labelsHidden()
                    }

                    // MARK: Reminder Date and TextField
                    // Hiding If Notification access is rejected
                    HStack(spacing: 12) {
                        Label {
                            Text(viewModel.reminderDate.formatted(date: .omitted, time: .shortened))
                        } icon: {
                            Image(systemName: "clock")
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        .background {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color("TFBG").opacity(0.4))
                        }
                        .onTapGesture {
                            withAnimation {
                                viewModel.showTimePicker.toggle()
                            }
                        }

                        TextField("Reminder Text...", text: $viewModel.reminderText)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color("TFBG").opacity(0.4))
                            }
                    }
                    .animation(.easeInOut, value: viewModel.isReminderOn)
                    .frame(height: viewModel.isReminderOn ? nil : 0)
                    .opacity(viewModel.isReminderOn ? 1 : 0)
                }

            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(viewModel.editHabit != nil ? "Update Habit" : "Add Habit")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        env.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                    }
                    .tint(.init(.label))
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        if viewModel.upsertHabbit(context: env.managedObjectContext) {
                            env.dismiss()
                        }
                    }
                    .tint(.init(.label))
                    .disabled(!viewModel.doneStatus())
                    .opacity(viewModel.doneStatus() ? 1 : 0.6)
                }
            }
        }
        .overlay {
            if viewModel.showTimePicker {
                ZStack {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                viewModel.showTimePicker.toggle()
                            }
                        }

                    DatePicker("", selection: $viewModel.reminderDate, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("TFBG"))
                        }
                        .padding()
                }
            }
        }
    }
}

struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView()
            .preferredColorScheme(.dark)
            .environment(\.managedObjectContext, CoreDataHabitManager.preview.container.viewContext)
    }
}
