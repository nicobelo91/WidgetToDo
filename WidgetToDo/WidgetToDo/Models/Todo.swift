//
//  Todo.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 19/07/2024.
//

import SwiftUI
import SwiftData

@Model
class Todo {
    
    ///Used to update the to-do state of the widgets
    private(set) var id: String = UUID().uuidString
    var task: String
    var isCompleted: Bool = false
    var dueDate: Date = Date.now
    var priority: Priority = Priority.normal
    var lastUpdated: Date = Date.now
    
    init(task: String, dueDate: Date, priority: Priority) {
        self.task = task
        self.dueDate = dueDate
        self.priority = priority
    }
    
    var isDueToday: Bool {
        let dateRange = Date.now ... Date.now.endOfDay()
        return dateRange.contains(dueDate)
    }
    
    var isExpired: Bool {
        dueDate < .now
    }
}

enum Priority: String, Codable, CaseIterable {
    case normal, medium, high
    
    var color: Color {
        switch self {
        case .normal:
            return .green
        case .medium:
            return .yellow
        case .high:
            return .red
        }
    }
}

extension Todo {
    static let example = Todo(task: "Brush teeth", dueDate: .now, priority: .normal)
}
