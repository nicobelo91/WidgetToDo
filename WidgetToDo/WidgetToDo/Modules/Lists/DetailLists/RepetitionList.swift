//
//  RepetitionList.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 27/08/2024.
//

import SwiftUI

struct RepetitionList: View {
    typealias Frequency = CustomRepetitionFrequency
    
    @Binding var selection: Repetition
    @Environment(\.dismiss) var dismiss
    @State private var didTapOnCustom = false
    @State private var customFrequency: Frequency = .daily
    @State private var customValue: Int = 1
    var body: some View {
        List {
            Section {
                ForEach(Repetition.mainCases, id: \.self) { item in
                    HStack {
                        Text(item.description)
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundStyle(.blue)
                            .opacity(isEqual(to: item) ? 1 : 0)
                    }
                    .contentShape(.rect)
                    .onTapGesture {
                        selection = item
                        dismiss()
                    }
                    
                }
            }

            Section {
                HStack {
                    Text("Custom")
                    Spacer()
                    Image(systemName: isEqualToCustomCase() ? "checkmark" : "chevron.right")
                        .foregroundStyle(isEqualToCustomCase() ? .blue : .gray)
                }
                .contentShape(.rect)
                .onTapGesture {
                    //selection = .custom(frequency: customFrequency, every: customValue)
                    selection = .custom
                    didTapOnCustom = true
                }
            } footer: {
                Text("Task will be repeated every day")
            }
           
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $didTapOnCustom) {
            CustomRepetitionList(frequency: $customFrequency, every: $customValue)
        }
    }
    
    private func isEqual(to item: Repetition) -> Bool {
        switch selection {
//        case .custom:
//            if case .custom = item {
//                return true
//            } else {
//                return false
//            }
        default:
            return selection == item
        }
    }
    
    private func isEqualToCustomCase() -> Bool {
        //isEqual(to: .custom(frequency: customFrequency, every: customValue))
        selection == .custom
    }
}

#Preview {
    RepetitionList(selection: .constant(.never))
}
