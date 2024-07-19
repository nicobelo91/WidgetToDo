//
//  WidgetView.swift
//  TodoListExtension
//
//  Created by Nicolas Cobelo on 19/07/2024.
//

import SwiftUI
import SwiftData

struct WidgetView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        switch widgetFamily {
        case .systemSmall: SmallSizedView()
        case .systemMedium: MediumSizedView(entry: entry)
        case .systemLarge: LargeSizedView()
        default: Text("Not implemented")
        }
    }
}
