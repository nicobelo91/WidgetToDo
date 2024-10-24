//
//  Date+Extensions.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 19/07/2024.
//

import Foundation

extension Date {

    var startOfDay: Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
      }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.timeZone = TimeZone(secondsFromGMT: 0)
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    func currentHour() -> Date {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: .now)
        let minute = calendar.component(.minute, from: .now)
        
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: self)!
    }
    
    var startOfMonth: Date {
           let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
           return Calendar.current.date(from: components)!
       }
}
