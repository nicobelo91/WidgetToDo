//
//  Date+Extensions.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 19/07/2024.
//

import Foundation

extension Date {

    func endOfDay() -> Date {
        var calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: self)
        
        return calendar.date(byAdding: .day, value: 1, to: startOfDay)!
    }
}
