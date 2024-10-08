//
//  Date+Extensions.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 19/07/2024.
//

import Foundation

extension Date {

    func endOfDay() -> Date {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: self)
        
        return calendar.date(byAdding: .day, value: 1, to: startOfDay)!
    }
    
    func startOfMonth() -> Date {
        let calendar = Calendar.current
        return calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: self)))!
    }
}
