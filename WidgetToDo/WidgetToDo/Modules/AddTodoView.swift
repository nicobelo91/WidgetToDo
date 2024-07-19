//
//  AddTodoView.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 19/07/2024.
//

import SwiftUI
import WidgetKit

struct AddTodoView: View {
    
    @State private var taskName: String = ""
    @State private var dueDate: Date = .now
    @State private var priority: Priority = .normal
    
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
            .navigationTitle("Add todo item")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let todo = Todo(task: taskName, dueDate: dueDate, priority: priority)
                        context.insert(todo)
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
        }
    }
}

#Preview {
    AddTodoView()
}
