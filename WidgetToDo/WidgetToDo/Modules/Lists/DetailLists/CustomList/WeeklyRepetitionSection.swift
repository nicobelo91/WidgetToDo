//
//  WeeklyRepetitionSection.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 03/09/2024.
//

import SwiftUI

struct WeeklyRepetitionSection: View {
    @Binding var selectedDaysOfWeek: [String]
    var body: some View {
        Section {
            ForEach(DateFormatter().weekdaySymbols, id: \.self) { day in
                MultipleSelectionRow(title: day, isSelected: selectedDaysOfWeek.contains(day)) {
                    if selectedDaysOfWeek.contains(day) {
                        guard selectedDaysOfWeek.count > 1 else { return }
                        selectedDaysOfWeek.removeAll(where: { $0 == day })
                    }
                    else {
                        selectedDaysOfWeek.append(day)
                    }
                }
                
            }
        }
    }
}

#Preview {
    WeeklyRepetitionSection(selectedDaysOfWeek: .constant([]))
}
