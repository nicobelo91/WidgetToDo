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
    var lastsAllDay: Bool = false
    var startDate: Date = Date.now
    var endDate: Date = Date.now
    var priority: Priority = Priority.normal
    var repetition: Repetition = Repetition.never
    var endRepeat: EndRepeat?
    var lastUpdated: Date = Date.now
    
    init(
        task: String,
        dueDate: Date,
        lastsAllDay: Bool,
        startDate: Date,
        endDate: Date,
        priority: Priority,
        repetition: Repetition,
        endRepeat: EndRepeat? = nil
    ) {
        self.task = task
        self.dueDate = dueDate
        self.lastsAllDay = lastsAllDay
        self.startDate = startDate
        self.endDate = endDate
        self.priority = priority
        self.repetition = repetition
        self.endRepeat = endRepeat
    }
    
    var isDueToday: Bool {
        let dateRange = Date.now ... Date.now.endOfDay()
        return dateRange.contains(dueDate)
    }
    
    var isExpired: Bool {
        dueDate < .now
    }
}

extension Todo {
    static let example = Todo(
        task: "Brush teeth",
        dueDate: .now,
        lastsAllDay: false,
        startDate: .now,
        endDate: .now,
        priority: .normal,
        repetition: .never
    )
}
