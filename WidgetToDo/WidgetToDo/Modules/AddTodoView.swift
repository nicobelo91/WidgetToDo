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
    @State private var repetition: Repetition = .never
    @State private var endRepeat: EndRepeat?
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        NavigationStack {
            FormView(
                taskName: $taskName,
                dueDate: $dueDate,
                priority: $priority,
                repetition: $repetition,
                endRepeat: $endRepeat
            )
            .navigationTitle("Add todo item")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let dueDates = generateDates()
                        
                        for date in dueDates {
                            let todo = Todo(task: taskName, dueDate: date, priority: priority, repetition: repetition, endRepeat: endRepeat)
                            context.insert(todo)
                        }
                        
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
    
    func generateDates() -> [Date] {
        guard let component = repetition.addToDate.component, let value = repetition.addToDate.value else { return [dueDate] }
        
        var startDate = dueDate
        var endDate: Date?
        
        var dates: [Date] = [dueDate]
        
        switch endRepeat {
        case .repeatForever:
            endDate = Calendar.current.date(byAdding: .year, value: 10, to: startDate)!
        case .endRepeatDate(let date):
            endDate = date
        default:
            endDate = nil
        }
        guard let endDate else {
            return [dueDate]
        }
        
        while startDate < endDate {
            startDate = Calendar.current.date(byAdding: component, value: value, to: startDate)!
            dates.append(startDate)
        }
        return dates
    }
}

#Preview {
    AddTodoView()
}
