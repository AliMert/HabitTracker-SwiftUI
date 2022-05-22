//
//  HabitsView.swift
//  HabitTracker (iOS)
//
//  Created by Ali Mert Özhayta on 19.05.2022.
//

import SwiftUI

struct HabitsView: View {

    @State private var addNewHabit: Bool = false
    @State private var draggedHabit: Habit?
    @Environment(\.self) private var env

    @FetchRequest<Habit>(
        sortDescriptors: [NSSortDescriptor(keyPath: \Habit.rowID, ascending: false)],
        animation: .interactiveSpring().speed(0.5)
    ) private var habits

    var body: some View {
        VStack(spacing: 0) {
            Text("Habits")
                .font(.title2.bold())
                .maxWidth()
                .overlay(alignment: .trailing) {
                    Button {

                    } label: {
                        Image(systemName: "gearshape")
                            .font(.title3)
                            .foregroundColor(Color(.label))
                    }
                    .padding(.trailing)
                }
                .padding(.bottom)

            ScrollView(habits.isEmpty ? .init() : .vertical) {
                VStack(spacing: 15) {
                    // MARK: HabitCardView
                    DynamicFilteredView(
                        fetchRequest: _habits,
                        emptyView: { EmptyView() }
                    ) {   (habit: Habit) in
                        HabitCardView(habit: habit)
                            .onDelete(style: .init(radius: 10, corners: [.topRight, .bottomRight])) {
                                CoreDataHabitManager.delete(habit, from: env.managedObjectContext)
                            }
                            .onDrag {
                                draggedHabit = habit
                                return NSItemProvider(item: nil, typeIdentifier: "\(habit.rowID)")
                            }
                            .onDrop(of: [.data], delegate: HabitDropDelegate(draggedHabit: $draggedHabit, habit: habit))
                    }

                    // MARK: Add Habit Button
                    VStack {
                        Button {
                            addNewHabit.toggle()
                        } label: {
                            Label {
                                Text("New Habit")
                            } icon: {
                                Image(systemName: "plus.circle")
                            }
                            .font(.callout.bold())
                            .foregroundColor(.white)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color(.darkGray).opacity(env.colorScheme == .dark ? 1 : 0.6))
                        }
                    }
                    .padding(.top, 15)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                .padding(.vertical)
            }
        }
        .padding(.bottom, 0.1)
        .frame(maxHeight: .infinity, alignment: .top)

        .sheet(isPresented: $addNewHabit) {
            AddHabitView()
        }
    }
}

struct HabitsView_Previews: PreviewProvider {
    static var previews: some View {
        HabitsView()
            .preferredColorScheme(.dark)
            .environment(\.managedObjectContext, CoreDataHabitManager.preview.container.viewContext)
    }
}
