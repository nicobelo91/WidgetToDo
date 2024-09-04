//
//  YearlyRepetitionSection.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 03/09/2024.
//

import SwiftUI

struct YearlyRepetitionSection: View {
    @Binding var selectedMonthsOfYear: [String]
    @State private var ordinal: Ordinal = .first
    @State private var weekday: String = DateFormatter().weekdaySymbols.first!
    @State private var showDatePicker = false
    
    var columns: [GridItem] = [
           GridItem(.flexible(), spacing: 0),
           GridItem(.flexible(), spacing: 0),
           GridItem(.flexible(), spacing: 0),
           GridItem(.flexible(), spacing: 0)
       ]
    
    var body: some View {
        Section {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(DateFormatter().shortMonthSymbols, id: \.self) { month in
                    MultipleSelectionCell(title: month, isSelected: selectedMonthsOfYear.contains(month)) {
                        if selectedMonthsOfYear.contains(month) {
                            guard selectedMonthsOfYear.count > 1 else { return }
                            selectedMonthsOfYear.removeAll(where: { $0 == month })
                        }
                        else {
                            selectedMonthsOfYear.append(month)
                        }
                    }
                }
             }
            .padding(.vertical, -11)
            .padding(.horizontal, -20)
        }
        
        Section {
            Toggle(isOn: $showDatePicker.animation(.easeInOut)) {
                Text("Days of Week")
            }
            if showDatePicker {
                HStack(spacing: 0) {
                    Picker("Ordinal", selection: $ordinal) {
                        ForEach(Ordinal.allCases, id: \.self) {
                            Text($0.title)
                        }
                    }
                    .pickerStyle(.wheel)
                    .padding(.trailing, -15)
                    .clipped()

                    Picker("Day", selection: $weekday) {
                        ForEach(DateFormatter().weekdaySymbols, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.wheel)
                    .padding(.leading, -15)
                                .clipped()
                }
            }
        }
    }
}

#Preview {
    YearlyRepetitionSection(selectedMonthsOfYear: .constant(["Jan"]))
}
