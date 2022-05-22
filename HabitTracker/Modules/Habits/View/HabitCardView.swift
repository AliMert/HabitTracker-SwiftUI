//
//  HabitCardView.swift
//  HabitTracker
//
//  Created by Ali Mert Özhayta on 21.05.2022.
//

import SwiftUI

struct HabitCardView: View {

    @Binding private var habit: Habit
    @State private var editHabit = false

    init(habit: Habit) {
        self._habit = .constant(habit)
    }

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text(habit.title ?? "")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                Image(systemName: "bell.badge.fill")
                    .font(.callout)
                    .foregroundColor(Color(habit.color ?? "Card-1"))
                    .scaleEffect(0.8)
                    .offset(x: -3, y: -3)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: -0.1)
                    .opacity(habit.isReminderOn ? 1 : 0)

                Spacer()

                let count = habit.weekdays?.count ?? 0
                Text(count == 7 ? "Everyday" : "\(count) times a week")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 10)

            // MARK: Displaying Current Week and Marking Active Dates of Habit
            let activePlot = getActivePlot()

            HStack {
                ForEach(activePlot.indices, id: \.self) { index in
                    let item = activePlot[index]

                    VStack(spacing: 6) {
                        Text(item.dayName.prefix(3))
                            .font(.caption)
                            .foregroundColor(.gray)

                        let status = (habit.weekdays ?? []).contains { $0 == item.dayName }

                        Text(formatDate(date: item.date))
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .shadow(color: Color(.systemBackground), radius: 0.4, x: 0.3, y: 0.3)
                            .padding(8)
                            .background {
                                Circle()
                                    .fill(Color(habit.color ?? "Card-1" ))
                                    .opacity(status ? 1 : 0)
                            }
                    }
                    .maxWidth()
                }
            }
            .padding(.top, 15)
        }
        .padding()
        .background( Color("TFBG").opacity(0.35), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .padding(.horizontal)
        .frame(maxWidth: 600)
        .onTapGesture {
            editHabit.toggle()
        }
        .sheet(isPresented: $editHabit) {
            AddHabitView(editHabit: habit)
        }
    }

    private func getActivePlot() -> [(dayName: String, date: Date)] {
        let calendar = Calendar.current
        let currentWeek = calendar.dateInterval(of: .weekOfMonth, for: Date())
        let weekdaySymbols = calendar.weekdaySymbols
        let startDate = currentWeek?.start ?? Date()

        return weekdaySymbols.indices.compactMap { index -> (String, Date)? in
            guard let currentDate = calendar.date(byAdding: .day, value: index, to: startDate) else {
                return nil
            }
            return (weekdaySymbols[index], currentDate)
        }
    }

    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: date)
    }
}

struct HabitCardView_Previews: PreviewProvider {
    static let habit: Habit = {
        let habit = Habit(context: CoreDataHabitManager.context)
        habit.title = "Workout"
        return habit
    }()

    static var previews: some View {
        HabitCardView(habit: habit)
    }
}
