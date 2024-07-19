//
//  ActiveList.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 19/07/2024.
//

import SwiftUI
import SwiftData

struct ActiveList: View {
    @Query(todoDescriptor, animation: .snappy) private var activeList: [Todo]
    
    var body: some View {
        Section(activeSectionTitle) {
            ForEach(filteredTodos) { todo in
                TodoRowView(todo: todo)
            }
        }
    }
    
    static var todoDescriptor: FetchDescriptor<Todo> {
        let predicate = #Predicate<Todo> { !$0.isCompleted }
        let sort = [SortDescriptor(\Todo.dueDate, order: .forward)]
        let descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        return descriptor
    }
    
    /// Since date isn't yet available to be used on the #Predicate macro, in the meantime, the following workaround can be used:
    var filteredTodos: [Todo] {
        activeList.filter({ $0.dueDate > .now.endOfDay()})
    }
    
    var activeSectionTitle: String {
        let count = filteredTodos.count
        return count == 0 ? "Active" : "Active (\(count))"
    }
}

#Preview {
    ActiveList()
}
