//
//  CustomRepetitionFrequency.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 29/08/2024.
//

import Foundation

enum CustomRepetitionFrequency: Codable, CaseIterable {
    case hourly
    case daily
    case weekly
    case monthly
    case yearly
    
    var description: String {
        switch self {
        case .hourly: return "Hourly"
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        case .monthly: return "Monthly"
        case .yearly: return "Yearly"
        }
    }
}
