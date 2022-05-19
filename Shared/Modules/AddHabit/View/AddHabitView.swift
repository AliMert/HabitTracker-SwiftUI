//
//  AddHabitView.swift
//  HabitTracker
//
//  Created by Ali Mert Özhayta on 19.05.2022.
//

import SwiftUI

struct AddHabitView: View {
    @StateObject private var viewModel: AddHabitViewModel = .init()

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
                                        .shadow(color: .init(.systemBackground), radius: 0.5, x: 0.5, y: 0.5)
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

                // MARK: Frequency Selection
                VStack {
                    
                }
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Add Habit")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {

                    } label: {
                        Image(systemName: "xmark.circle")
                    }
                    .tint(.init(.label))
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {

                    }
                    .tint(.init(.label))
                }
            }
        }
    }
}

struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView()
            .preferredColorScheme(.dark)
    }
}
