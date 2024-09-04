//
//  CustomRepetitionList.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 29/08/2024.
//

import SwiftUI

struct CustomRepetitionList: View {
    typealias Frequency = CustomRepetitionFrequency
    @Binding var frequency: Frequency
    @Binding var every: Int
    @State private var didTapOnFrequency = false
    @State private var didTapOnEvery = false
    @State private var valuePickerSelection = [String]()
    @State private var selectedDaysOfWeek: [String] = [DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: .now) - 1]]
    @State private var selectedDaysOfMonth: [Int] = [Calendar.current.component(.day, from: .now)]
    @State private var selectedMonthsOfYear: [String] = [DateFormatter().shortMonthSymbols[Calendar.current.component(.month, from: .now) - 1]]
    @Environment(\.dismiss) var dismiss
    var body: some View {
        List {
            Section {
                HStack {
                    Text("Frequency")
                    Spacer()
                    Text(frequency.description)
                        .foregroundStyle(didTapOnFrequency ? .blue : .gray)
                }
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation {
                        didTapOnFrequency.toggle()
                        if didTapOnFrequency {
                            didTapOnEvery = false
                        }
                    }
                }
                if didTapOnFrequency {
                    Picker("Frequency", selection: $frequency) {
                        ForEach(Frequency.allCases, id: \.self) {
                            Text($0.description)
                        }
                    }
                    .pickerStyle(.wheel)
                    
                    .onChange(of: frequency) { _, _ in
                        valuePickerSelection = []
                        valuePickerSelection.append(valuePickerUnit)
                    }
                }
                
                
                HStack {
                    Text("Every")
                    Spacer()
                    Text("\(every) \(valuePickerUnit)")
                        .foregroundStyle(didTapOnEvery ? .blue : .gray)
                }
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation {
                        didTapOnEvery.toggle()
                        if didTapOnEvery {
                            didTapOnFrequency = false
                        }
                    }
                }
                
                if didTapOnEvery {
                    HStack(spacing: 0) {
                        Picker("Value", selection: $every) {
                            ForEach(1...999, id: \.self) {
                                Text(String($0))
                            }
                        }
                        .pickerStyle(.wheel)
                        .padding(.trailing, -15)
                                    .clipped()
                        
                        Picker("Unit", selection: .constant("")) {
                            Text(valuePickerUnit.capitalized)
                        }
                        .pickerStyle(.wheel)
                        .padding(.leading, -15)
                                    .clipped()
                    }
                }
            } footer: {
                Text(footerText)
            }
            
           subSectionView
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private var subSectionView: some View {
        if frequency == .weekly {
            WeeklyRepetitionSection(selectedDaysOfWeek: $selectedDaysOfWeek)
        } else if frequency == .monthly {
            MonthlyRepetitionSection(selectedDaysOfMonth: $selectedDaysOfMonth)
        } else if frequency == .yearly {
            YearlyRepetitionSection(selectedMonthsOfYear: $selectedMonthsOfYear)
        }
    }
    
    private var valuePickerUnit: String {
        var text = ""
        switch frequency {
        case .daily: text = "day"
        case .hourly: text = "hour"
        case .monthly: text = "month"
        case .weekly: text = "week"
        case .yearly: text = "year"
        }
        
        if every > 1 {
            return "\(text)s"
        } else {
            return text
        }
        
    }
    
    private var footerText: String {
        var text: String
        if every != 1 {
            text = "Task will be repeated every \(every) \(valuePickerUnit)"
        } else {
            text = "Task will be repeated every \(valuePickerUnit)"
        }
        
        switch frequency {
        case .weekly:
            text += " on \(selectedDaysOfWeek.formatted())"
        case .monthly:
            text += " on the 5th"
        case .yearly:
            text += " in \(selectedMonthsOfYear.formatted())"
        default: break
        }
        return text
    }
}

#Preview {
    CustomRepetitionList(frequency: .constant(.daily), every: .constant(1))
}
