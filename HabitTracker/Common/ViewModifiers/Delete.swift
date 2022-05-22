//
//  Delete.swift
//  HabitTracker
//
//  Created by Ali Mert Özhayta on 22.05.2022.
//

import SwiftUI

public struct Delete: ViewModifier {
    public struct CornerRadiusStyle {
        let radius: CGFloat
        let corners: UIRectCorner
    }

    //MARK: Constants

    private let deletionDistance = CGFloat(200)
    private let halfDeletionDistance = CGFloat(50)
    private let tappableDeletionWidth = CGFloat(100)

    //MARK: Properties

    private let action: () -> Void
    private let cornerRadiusStyle: CornerRadiusStyle?

    @State private var offset: CGSize = .zero
    @State private var initialOffset: CGSize = .zero
    @State private var contentWidth: CGFloat = 0.0
    @State private var willDeleteIfReleased = false

    //MARK: Init

    init(action: @escaping () -> Void, cornerRadiusStyle: CornerRadiusStyle? = nil) {
        self.action = action
        self.cornerRadiusStyle = cornerRadiusStyle
    }

    //MARK: UI

    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    ZStack {
                        Rectangle()
                            .foregroundColor(.red)
                            .cornerRadius(cornerRadiusStyle?.radius ?? .zero, corners: cornerRadiusStyle?.corners ?? [])

                        Image(systemName: "trash")
                            .foregroundColor(.white)
                            .font(.title2.bold())
                            .layoutPriority(-1)
                            .opacity(offset.width < -10 ? 1 : 0)
                    }.frame(width: -offset.width)
                        .offset(x: geometry.size.width)
                        .onAppear {
                            contentWidth = geometry.size.width
                        }
                        .gesture(
                            TapGesture()
                                .onEnded {
                                    delete()
                                }
                        )
                }
            )
            .offset(x: offset.width, y: 0)
            .gesture (
                DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.width + initialOffset.width <= 0 {
                            self.offset.width = gesture.translation.width + initialOffset.width
                        }
                        if self.offset.width < -deletionDistance && !willDeleteIfReleased {
                            hapticFeedback()
                            willDeleteIfReleased.toggle()
                        } else if offset.width > -deletionDistance && willDeleteIfReleased {
                            hapticFeedback()
                            willDeleteIfReleased.toggle()
                        }
                    }
                    .onEnded { _ in
                        if offset.width < -deletionDistance {
                            delete()
                        } else if offset.width < -halfDeletionDistance {
                            offset.width = -tappableDeletionWidth
                            initialOffset.width = -tappableDeletionWidth
                        } else {
                            offset = .zero
                            initialOffset = .zero
                        }
                    }
            )
            .animation(.interactiveSpring(), value: offset)
    }

    //MARK: Methods

    private func delete() {
        offset.width = -contentWidth
        action()
    }

    private func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}
