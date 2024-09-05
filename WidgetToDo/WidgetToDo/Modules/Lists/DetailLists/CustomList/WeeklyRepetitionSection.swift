//
//  WeeklyRepetitionSection.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 03/09/2024.
//

import SwiftUI

struct WeeklyRepetitionSection: View {
    @Binding var customRepetition: CustomRepetition
    var body: some View {
        Section {
            ForEach(DateFormatter().weekdaySymbols, id: \.self) { day in
                MultipleSelectionRow(title: day, isSelected: customRepetition.selectedDaysOfWeek.contains(day)) {
                    if customRepetition.selectedDaysOfWeek.contains(day) {
                        guard customRepetition.selectedDaysOfWeek.count > 1 else { return }
                        customRepetition.selectedDaysOfWeek.removeAll(where: { $0 == day })
                    }
                    else {
                        customRepetition.selectedDaysOfWeek.append(day)
                    }
                }
                
            }
        }
    }
}

#Preview {
    WeeklyRepetitionSection(customRepetition: .constant(.initialValue))
}
