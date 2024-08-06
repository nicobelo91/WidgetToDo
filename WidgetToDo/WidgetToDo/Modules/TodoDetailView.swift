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
    
    var todo: Todo
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Take out trash", text: $taskName)
                } header: {
                    Text("Title")
                }
                
                Section {
                    DatePicker(selection: $dueDate) {
                        Text("Select a date")
                    }
                } header: {
                    Text("Due Date")
                }
                
                Section {
                    Picker("Priority", selection: $priority) {
                        ForEach(Priority.allCases, id: \.self) { priority in
                            Text(priority.rawValue.capitalized)
                        }
                    }.pickerStyle(.segmented)
                } header: {
                    Text("Priority")
                }
            }
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
            }
        }
    }
}

#Preview {
    TodoDetailView(todo: Todo.example)
}
