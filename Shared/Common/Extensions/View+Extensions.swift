//
//  View+Extensions.swift
//  HabitTracker
//
//  Created by Ali Mert Özhayta on 19.05.2022.
//

import protocol SwiftUI.View

public extension View {
    
    // MARK: Vertical Center
    func vCenter() -> some View {
        self
            .frame(maxHeight: . infinity, alignment: .center)
    }
    
    // MARK: Vertical Top
    func vTop() -> some View {
        self
            .frame(maxHeight: . infinity, alignment: .top)
    }
    // MARK: Vertical Bottom
    func vBottom() -> some View {
        self
            .frame(maxHeight: . infinity, alignment: .bottom)
    }
    
    // MARK: Horizontal Center
    func hCenter() -> some View {
        self
            .frame(maxWidth: . infinity, alignment: .center)
    }
    
    // MARK: Horizontal Leading
    func hLeading() -> some View {
        self
            .frame(maxWidth: . infinity, alignment: .leading)
    }
    
    // MARK: Horizontal Trailing
    func hTrailing() -> some View {
        self
            .frame(maxWidth: . infinity, alignment: .trailing)
    }

    // MARK: Max Width
    func maxWidth() -> some View {
        self
            .frame(maxWidth: . infinity)
    }

    // MARK: Max Height
    func maxHeight() -> some View {
        self
            .frame(maxHeight: . infinity)
    }
}

