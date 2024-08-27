//
//  TodoRowView.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 19/07/2024.
//

import SwiftUI
import WidgetKit

struct TodoRowView: View {
    @Bindable var todo: Todo
    /// View Properties

    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var phase
    @State private var showDetail = false
    var body: some View {
        HStack(spacing: 8) {
            Button(action: {
                todo.isCompleted.toggle()
                todo.lastUpdated = .now
                WidgetCenter.shared.reloadAllTimelines()
            }) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .padding(3)
                    .contentShape(.rect)
                    .foregroundStyle(todo.isCompleted ? .gray : .accentColor)
                    .contentTransition(.symbolEffect(.replace))
            }
            .opacity(todo.isExpired ? 0 : 1)
            .disabled(todo.isExpired)
            .buttonStyle(.borderless)
            
            VStack(alignment: .leading) {
                Text(todo.task)
                    .font(.title3)
                    .foregroundStyle(textColor)
                Text(DateHelper.Formatter.longDateWithTime.string(from: todo.dueDate))
                    .font(.caption)
                    .foregroundStyle(textColor)
            }
            .strikethrough(todo.isCompleted)
            .containerShape(.rect)
            .onTapGesture {
                showDetail = true
            }
            
            Spacer()
            // Priority Menu for Button for updating
            if !todo.isExpired {
                Menu {
                    ForEach(Priority.allCases, id: \.rawValue) { priority in
                        Button(action: { todo.priority = priority }) {
                            HStack {
                                Text(priority.rawValue.capitalized)
                                
                                if todo.priority == priority { Image(systemName: "checkmark") }
                            }
                        }
                    }
                } label: {
                    Image(systemName: "circle.fill")
                        .font(.title2)
                        .padding(3)
                        .contentShape(.rect)
                        .foregroundStyle(todo.priority.color.gradient)
                }
            }
        }
        .sheet(isPresented: $showDetail) {
            TodoDetailView(todo: todo)
        }
        .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button("", systemImage: "trash") {
                context.delete(todo)
                WidgetCenter.shared.reloadAllTimelines()
            }
            .tint(.red)
        }
        .task {
            todo.isCompleted = todo.isCompleted
        }
    }
    
    private var textColor: Color {
        if todo.isCompleted {
            return .gray
        } else if todo.isExpired {
            return .red
        } else {
            return .primary
        }
    }
}

#Preview {
    ContentView()
}
