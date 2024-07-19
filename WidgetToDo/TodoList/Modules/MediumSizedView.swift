//
//  MediumSizedView.swift
//  TodoListExtension
//
//  Created by Nicolas Cobelo on 19/07/2024.
//

import SwiftUI
import SwiftData

struct MediumSizedView: View {
    var entry: Provider.Entry
    // Query that will fetch only three active todos at a time
    @Query(todoDescriptor, animation: .snappy) private var activeList: [Todo]
    var body: some View {
        VStack {
            ForEach(activeList) { todo in
                HStack(spacing: 10) {
                    // Intent Action Button
                    Button(intent: ToggleButtonIntent(id: todo.id)) {
                        Image(systemName: "circle")
                    }
                    .font(.callout)
                    .tint(todo.priority.color.gradient)
                    .buttonBorderShape(.circle)
                    
                    Text(todo.task)
                        .font(.callout)
                        .lineLimit(1)
                    
                    Spacer(minLength: 0)
                }
                .transition(.push(from: .bottom))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay {
            if activeList.isEmpty {
                Text("No Tasks 🎉🎉")
                    .font(.callout)
                    .transition(.push(from: .bottom))
            }
        }
    }
    
    static var todoDescriptor: FetchDescriptor<Todo> {
        let predicate = #Predicate<Todo> { !$0.isCompleted }
        let sort = [SortDescriptor(\Todo.dueDate, order: .forward)]
        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        descriptor.fetchLimit = 3
        return descriptor
    }
}

#Preview {
    MediumSizedView(entry: .init(date: .now))
}
