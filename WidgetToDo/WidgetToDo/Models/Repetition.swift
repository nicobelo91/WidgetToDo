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
    case weekdays
    case weekends
    case weekly
    case biweekly
    case monthly
    case every3Months = "every 3 months"
    case every6Months = "every 6 months"
    case yearly
}
