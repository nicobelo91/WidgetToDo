//
//  Repetition.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 27/08/2024.
//

import Foundation

enum Repetition: String, Codable, CaseIterable {
    case never
    case hourly
    case daily
    case weekly
    case biweekly
    case monthly
    case every3Months = "every 3 months"
    case every6Months = "every 6 months"
    case yearly
    
    var addToDate: (component: Calendar.Component?, value: Int?) {
        switch self {
        case .never: return (nil, nil)
        case .hourly: return (.hour, 1)
        case .daily: return (.day, 1)
        case .weekly: return (.weekOfYear, 1)
        case .biweekly: return (.weekOfYear, 2)
        case .monthly: return (.month, 1)
        case .every3Months: return (.month, 3)
        case .every6Months: return (.month, 6)
        case .yearly: return (.year, 1)
        }
    }
}
