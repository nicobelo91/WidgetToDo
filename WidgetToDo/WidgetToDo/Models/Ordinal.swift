//
//  Ordinal.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 03/09/2024.
//

import Foundation

enum Ordinal: Int, CaseIterable {
    case first = 1
    case second
    case third
    case fourth
    case fifth
    case last
    
    var title: String {
        switch self {
        case .first: return "first"
        case .second: return "second"
        case .third: return "third"
        case .fourth: return "fourth"
        case .fifth: return "fifth"
        case .last: return "last"
        }
    }
}
