//
//  DynamicFilteredView.swift
//  HabitTracker
//
//  Created by Ali Mert Özhayta on 19.05.2022.
//

import SwiftUI
import CoreData

struct DynamicFilteredView<Content: View, EContent: View, T>: View where T: NSManagedObject {
    // MARK: Core Data Request
    @FetchRequest private var request: FetchedResults<T>
    private let content: (T)->Content
    private let emptyView: (()->EContent)?

    // MARK: Building Custom ForEach which will give Coredata object to build View
    init(
        entity: NSEntityDescription = T.entity(),
        sortDescriptors: [NSSortDescriptor] = [],
        predicate: NSPredicate? = nil,
        animation: Animation? = nil,
        emptyView: (() ->EContent)? = nil,
        @ViewBuilder content: @escaping (T)->Content
    ) {
        // Intializing Request With NSPredicate
        // Adding Sort
        _request = FetchRequest(
            entity: entity,
            sortDescriptors: sortDescriptors,
            predicate: predicate,
            animation: animation
        )

        self.content = content
        self.emptyView = emptyView
    }

    init(
        fetchRequest: FetchRequest<T>,
        emptyView: (() ->EContent)? = nil,
        @ViewBuilder content: @escaping (T)->Content
    ) {
        _request = fetchRequest
        self.content = content
        self.emptyView = emptyView
    }
    
    var body: some View {
        Group{
            if request.isEmpty {
                if let emptyView = emptyView {
                    emptyView()
                } else {
                    Text("No data found!!!")
                        .font(.system(size: 16))
                        .fontWeight(.light)
                        .offset(y: 100)
                }
            } else{
                ForEach(request, id: \.objectID) { object in
                    content(object)
                }
            }
        }
    }
}
