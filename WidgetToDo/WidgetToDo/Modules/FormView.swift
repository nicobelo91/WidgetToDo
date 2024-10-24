//
//  FormView.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 27/08/2024.
//

import SwiftUI

struct FormView: View {
    @Binding var taskName: String
    @Binding var lastsAllDay: Bool
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var priority: Priority
    @Binding var repetition: Repetition
    @Binding var endRepeat: EndRepeat?
    @Binding var customRepetition: CustomRepetition
    
    var body: some View {
        Form {
            Section {
                TextField("Take out trash", text: $taskName)
            } header: {
                Text("Title")
            }
            
            Section {
                Toggle(isOn: $lastsAllDay) {
                    Text("All day")
                }
                .onChange(of: lastsAllDay) { _, newValue in
                   updateStartAndEndDate(basedOn: newValue)
                }
                DatePicker("Starts", selection: $startDate, displayedComponents: datePickerComponents)
                DatePicker("Ends", selection: $endDate, displayedComponents: datePickerComponents)
                    .onChange(of: startDate) { oldValue, newValue in
                        if newValue > endDate {
                            endDate = newValue
                        }
                    }
                
                NavigationLink(destination: { RepetitionList(selection: $repetition, customRepetition: $customRepetition) }) {
                    HStack {
                        Text("Repeat")
                        Spacer()
                        Text(repetition.description)
                            .foregroundStyle(.placeholder)
                    }
                    .onChange(of: repetition) { oldValue, newValue in
                        if oldValue == .never, newValue != .never {
                            endRepeat = .repeatForever
                        }
                    }
                }
                
                if let endRepeat, repetition != .never {
                    NavigationLink(destination: { destinationView }) {
                        HStack {
                            Text("End Repeat")
                            Spacer()
                            Text(endRepeat.description)
                                .foregroundStyle(.placeholder)
                        }
                    }
                }
            } header: {
                Text("Due Date")
            }
            
            Section {
                Picker("Priority", selection: $priority) {
                    ForEach(Priority.allCases, id: \.self) { priority in
                        Text(priority.rawValue.capitalized)
                    }
                }.pickerStyle(.segmented)
            } header: {
                Text("Priority")
            }
        }
    }
    
    private var destinationView: some View {
        EndRepeatList(selection: Binding<EndRepeat>(
            get: {
                self.endRepeat ?? .repeatForever
            },
            set: {
                self.endRepeat = $0
            }
        ))
    }
    
    private var datePickerComponents: DatePicker<Text>.Components {
        if lastsAllDay {
            return .date
        } else {
            return [.date, .hourAndMinute]
        }
    }
    
    private func updateStartAndEndDate(basedOn newValue: Bool) {
        // If user has set lastsAllDay to true
        // We set the starting time to 00:00 and the finish time at 23:59
        if newValue {
            startDate = startDate.startOfDay
            endDate = endDate.endOfDay
        } else {
            // We use the current time for starting and finish time
            startDate = startDate.currentHour()
            endDate = endDate.currentHour()
        }
    }
}

#Preview {
    FormView(
        taskName: .constant(""),
        lastsAllDay: .constant(false),
        startDate: .constant(.now),
        endDate: .constant(.now),
        priority: .constant(.medium),
        repetition: .constant(.never),
        endRepeat: .constant(nil),
        customRepetition: .constant(.initialValue)
    )
}
