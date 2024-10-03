//
//  FormView.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 27/08/2024.
//

import SwiftUI

struct FormView: View {
    @Binding var taskName: String
    @Binding var dueDate: Date
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
                DatePicker(selection: $dueDate) {
                    Text("Select a date")
                }
                DatePicker("Starts", selection: $startDate, displayedComponents: datePickerComponents)
                DatePicker("Ends", selection: $endDate, displayedComponents: datePickerComponents)
                
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
}

#Preview {
    FormView(
        taskName: .constant(""),
        dueDate: .constant(.now),
        lastsAllDay: .constant(false),
        startDate: .constant(.now),
        endDate: .constant(.now),
        priority: .constant(.medium),
        repetition: .constant(.never),
        endRepeat: .constant(nil),
        customRepetition: .constant(.initialValue)
    )
}
