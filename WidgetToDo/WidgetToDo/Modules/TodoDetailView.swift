//
//  TodoDetailView.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 19/07/2024.
//

import SwiftUI
import WidgetKit

struct TodoDetailView: View {
    
    @State private var taskName: String = ""
    @State private var dueDate: Date = .now
    @State private var priority: Priority = .normal
    @State private var completed: Bool = false
    @State private var repetition: Repetition = .never
    @State private var endRepeat: EndRepeat?
    @State private var customRepetition: CustomRepetition = .initialValue
    
    var todo: Todo
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            FormView(
                taskName: $taskName,
                dueDate: $dueDate,
                priority: $priority,
                repetition: $repetition,
                endRepeat: $endRepeat,
                customRepetition: $customRepetition
            )
            .navigationTitle("Todo Detail")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        todo.task = taskName
                        todo.dueDate = dueDate
                        todo.priority = priority
                        todo.repetition = repetition
                        todo.endRepeat = endRepeat
                        do {
                            try context.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                        
                        // Manually update Widget
                        WidgetCenter.shared.reloadAllTimelines()
                        dismiss()
                    }.disabled(taskName.isEmpty)
                }
            }
            .onAppear {
                taskName = todo.task
                dueDate = todo.dueDate
                priority = todo.priority
                completed = todo.isCompleted
                repetition = todo.repetition
                endRepeat = todo.endRepeat
                // Show value for custom repetition
                //customRepetion = todo.customRepetion
            }
        }
    }
}

#Preview {
    TodoDetailView(todo: Todo.example)
}
