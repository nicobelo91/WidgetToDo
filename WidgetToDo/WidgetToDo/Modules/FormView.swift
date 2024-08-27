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
    @Binding var priority: Priority
    @Binding var repetition: Repetition
    @Binding var endRepeat: EndRepeat?
    
    var body: some View {
        Form {
            Section {
                TextField("Take out trash", text: $taskName)
            } header: {
                Text("Title")
            }
            
            Section {
                DatePicker(selection: $dueDate) {
                    Text("Select a date")
                }
                NavigationLink(destination: { RepetitionList(selection: $repetition) }) {
                    HStack {
                        Text("Repeat")
                        Spacer()
                        Text(repetition.rawValue.capitalized)
                            .foregroundStyle(.placeholder)
                    }
                    .onChange(of: repetition) { oldValue, newValue in
                        if oldValue == .never, newValue != .never {
                            endRepeat = .repeatForever
                        }
                    }
                }
                
                if let endRepeat, repetition != .never {
                    NavigationLink(destination: { EndRepeatList(selection: Binding<EndRepeat>(
                        get: {
                            self.endRepeat ?? .repeatForever
                        },
                        set: {
                            self.endRepeat = $0
                        }
                    )) }) {
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
}

#Preview {
    FormView(taskName: .constant(""), dueDate: .constant(.now), priority: .constant(.medium), repetition: .constant(.never), endRepeat: .constant(nil))
}
