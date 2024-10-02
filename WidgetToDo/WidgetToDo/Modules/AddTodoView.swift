//
//  AddTodoView.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 19/07/2024.
//

import SwiftUI
import WidgetKit

struct AddTodoView: View {
    
    @State private var taskName: String = ""
    @State private var dueDate: Date = .now
    @State private var priority: Priority = .normal
    @State private var repetition: Repetition = .never
    @State private var endRepeat: EndRepeat?
    @State private var customRepetition: CustomRepetition = .initialValue
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        NavigationStack {
            FormView(
                taskName: $taskName,
                dueDate: $dueDate,
                priority: $priority,
                repetition: $repetition,
                endRepeat: $endRepeat,
                customRepetition: $customRepetition
            )
            .navigationTitle("Add todo item")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let dueDates = generateDates()
                        
                        for date in dueDates {
                            let todo = Todo(task: taskName, dueDate: date, priority: priority, repetition: repetition, endRepeat: endRepeat)
                            context.insert(todo)
                        }
                        
                        do {
                            try context.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                        
                        // Manually update Widget
                        WidgetCenter.shared.reloadAllTimelines()
                        dismiss()
                    }.disabled(taskName.isEmpty)
                }
                
                
            }
        }
    }
    
    private func generateDates() -> [Date] {
        guard let component = repetition.addToDate.component, let value = repetition.addToDate.value else { return [dueDate] }
        
        var startDate = dueDate
        var endDate: Date?
        
        var dates: [Date] = [dueDate]
        
        switch endRepeat {
        case .repeatForever:
            endDate = Calendar.current.date(byAdding: .year, value: 10, to: startDate)!
        case .endRepeatDate(let date):
            endDate = date
        default:
            endDate = nil
        }
        
        guard let endDate else {
            return [dueDate]
        }
        let calendar = Calendar.current
        
        // Start date has already been set,
        // Now we would have to add a value to get (for example) all mondays of the week, or all Februaries in a year
        // So we can repeat a task every week on Mondays, or every year in February
        if let dateComponents = getDateComponents(from: component) {
            // The user can select to have a task repeated.
            // For explaining purposes, let's assume they decided to repeat the task every week on mondays and wednesdays,
            // so we are going to first get the mondays of every week until endDate,
            // and then we would get the wednesdays of every week until endDate.
            for dateComponent in dateComponents {
                // Set the startDate to its initial value
                startDate = dueDate
                
                // In order to get the first monday of every week, first we have to get the first monday of the array
                if let nextDay = calendar.nextDate(after: startDate, matching: dateComponent, matchingPolicy: .strict) {
                    startDate = nextDay
                    dates.append(startDate)
                    
                    // After getting the first monday, we then add a week to it, to retrieve the second monday of the array
                    while startDate < endDate {
                        startDate = calendar.date(byAdding: component, value: value, to: startDate)!
                        if startDate < endDate {
                            dates.append(newDate(basedOn: startDate, endDate: endDate))
                        }
                    }
                }
            }
        } else {
            // If the user didn't select the custom repetition, we simply get the dates repeated the way the user chose
            while startDate < endDate {
                startDate = Calendar.current.date(byAdding: component, value: value, to: startDate)!
                if startDate < endDate {
                    dates.append(startDate)
                }
            }
        }
        return dates
    }
    
    /// Returns a date based on the user's decision to select a specific day of the week
    /// E.g.: the second Thursday of the month
    private func newDate(basedOn currentDate: Date, endDate: Date) -> Date {
        var date = currentDate
        if currentDate < endDate {
            if customRepetition.isDayOfWeekSelected {
                let componenets = Calendar.current.dateComponents([.hour, .minute], from: dueDate)
                let dateComponents = DateComponents(
                    hour: componenets.hour,
                    minute: componenets.minute,
                    weekday: DateHelper.weekdayInt(from: customRepetition.weekday),
                    weekdayOrdinal: customRepetition.ordinal.rawValue
                )
                // We set the currentDate to the first day of the month,
                // so that we can fetch the the desired day of the selected week using Calendar.current.nextDate
                if let updatedDate = Calendar.current.nextDate(after: currentDate.startOfMonth(), matching: dateComponents, matchingPolicy: .strict) {
                    date = updatedDate
                }
            }
        }
        return date
    }
    
    /// If custom repetition is chosen, the user can select on which day the task should be repeated
    /// E.g. Repeat weekly on Wednesdays.
    /// So in that example,  we would need to fetch the first Wednesday after the startDate
    private func getDateComponents(from component: Calendar.Component) -> [DateComponents]? {
        guard case .custom = repetition else { return nil }

        switch component {
        case .year:
            return getYearlyDateComponents()
        case .month:
            return getMonthlyDateComponents()
        case .weekOfYear:
            return getWeeklyDateComponents()
        default:
            return nil
        }
    }
    
    /// Handles the logic for retrieving the date componenets for the weekly custom selection
    private func getWeeklyDateComponents() -> [DateComponents] {
        var dateComponents = [DateComponents]()
        let componenets = Calendar.current.dateComponents([.hour, .minute], from: dueDate)
        for dayOfWeek in customRepetition.selectedDaysOfWeek {
            let weekdayInt = DateComponents(
                hour: componenets.hour,
                minute: componenets.minute,
                weekday: DateHelper.weekdayInt(from: dayOfWeek)
            )
            dateComponents.append(weekdayInt)
        }
        return dateComponents
    }
    
    /// Handles the logic for retrieving the date componenets for the monthly custom selection
    private func getMonthlyDateComponents() -> [DateComponents] {
        var dateComponents = [DateComponents]()
        let componenets = Calendar.current.dateComponents([.hour, .minute], from: dueDate)

        // Enter monthly logic
        if customRepetition.isDayOfWeekSelected {
            let dayComponents = DateComponents(
                hour: componenets.hour,
                minute: componenets.minute,
                weekday: DateHelper.weekdayInt(from: customRepetition.weekday),
                weekdayOrdinal: customRepetition.ordinal.rawValue
            )
            dateComponents.append(dayComponents)
        } else {
            for day in customRepetition.selectedDaysOfMonth {
                let dayComponents = DateComponents(
                    day: day,
                    hour: componenets.hour,
                    minute: componenets.minute
                )
                dateComponents.append(dayComponents)
            }
        }

        return dateComponents
    }
    
    /// Handles the logic for retrieving the date componenets for the yearly custom selection
    private func getYearlyDateComponents() -> [DateComponents] {
        var dateComponents = [DateComponents]()
        var monthComponents: DateComponents
        for month in customRepetition.selectedMonthsOfYear {
            monthComponents = getMonthComponents(for: month)
            dateComponents.append(monthComponents)
        }
        return dateComponents
    }
    
    /// Fetches the necessary components to get the desired date in the selected month
    private func getMonthComponents(for month: String) -> DateComponents {
        let componenets = Calendar.current.dateComponents([.day, .hour, .minute], from: dueDate)
        // If the user selected a specific day of the week
        // E.g: the second Thursday of the month
        if customRepetition.isDayOfWeekSelected {
            return DateComponents(
                month: DateHelper.monthInt(from: month),
                hour: componenets.hour,
                minute: componenets.minute,
                weekday: DateHelper.weekdayInt(from: customRepetition.weekday),
                weekdayOrdinal: customRepetition.ordinal.rawValue
            )
        } else {
            // We simply fetch the same day of the month for every year
            // E.g. Every October 2nd
            return DateComponents(
                month: DateHelper.monthInt(from: month),
                day: componenets.day,
                hour: componenets.hour,
                minute: componenets.minute
            )
        }
    }
}

#Preview {
    AddTodoView()
}
