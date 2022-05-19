//
//  HabitsView.swift
//  HabitTracker (iOS)
//
//  Created by Ali Mert Özhayta on 19.05.2022.
//

import SwiftUI

struct HabitsView: View {
    @StateObject private var viewModel: HabitsViewModel = .init()

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
                }


            // Making 'Add Button' Centered When "Habits" is empty
            ScrollView(viewModel.habits.isEmpty ? .init() : .vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    // MARK: Add Habit Button
                    Button {

                    } label: {
                        Label {
                            Text("New Habit")
                        } icon: {
                            Image(systemName: "plus.circle")
                        }
                        .font(.callout.bold())
                        .foregroundColor(.init(.label))
                    }
                    .padding(.top, 15)
                }
                .padding(.vertical)
                .maxWidth()
                .maxHeight()
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .preferredColorScheme(.dark)
    }
}

struct HabitsView_Previews: PreviewProvider {
    static var previews: some View {
        HabitsView()
    }
}
