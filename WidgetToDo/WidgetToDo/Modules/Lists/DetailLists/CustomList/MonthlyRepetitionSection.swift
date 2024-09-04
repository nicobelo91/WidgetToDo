//
//  MonthlyRepetitionSection.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 03/09/2024.
//

import SwiftUI

struct MonthlyRepetitionSection: View {
    enum MonthlySelection: String, CaseIterable {
        case each = "Each"
        case onThe = "On The..."
    }
    
    @Binding var selectedDaysOfMonth: [Int]
    @State private var selection: MonthlySelection = .each
    @State private var ordinal: Ordinal = .first
    @State private var weekday: String = DateFormatter().weekdaySymbols.first!
    
    var columns: [GridItem] = [
           GridItem(.flexible(), spacing: 0),
           GridItem(.flexible(), spacing: 0),
           GridItem(.flexible(), spacing: 0),
           GridItem(.flexible(), spacing: 0),
           GridItem(.flexible(), spacing: 0),
           GridItem(.flexible(), spacing: 0),
           GridItem(.flexible(), spacing: 0)
       ]
    
    var body: some View {
        Section {
            ForEach(MonthlySelection.allCases, id: \.self) { item in
                    HStack {
                        Text(item.rawValue)
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundStyle(.blue)
                            .opacity(selection == item ? 1 : 0)
                    }
                    .contentShape(.rect)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            selection = item
                        }
                    }
                
            }
                switch selection {
                case .each:
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(1...31, id: \.self) { i in
                            MultipleSelectionCell(title: "\(i)", isSelected: selectedDaysOfMonth.contains(i)) {
                                if selectedDaysOfMonth.contains(i) {
                                    guard selectedDaysOfMonth.count > 1 else { return }
                                    selectedDaysOfMonth.removeAll(where: { $0 == i })
                                }
                                else {
                                    selectedDaysOfMonth.append(i)
                                }
                            }
                        }
                     }
                    .padding(.vertical, -11)
                    .padding(.horizontal, -20)
                case .onThe:
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
    MonthlyRepetitionSection(selectedDaysOfMonth: .constant([1]))
}
