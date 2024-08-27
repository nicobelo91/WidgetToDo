//
//  RepetitionList.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 27/08/2024.
//

import SwiftUI

struct RepetitionList: View {
    @Binding var selection: Repetition
    @Environment(\.dismiss) var dismiss
    var body: some View {
        List {
            ForEach(Repetition.allCases, id: \.self) { item in
                HStack {
                    Text(item.rawValue.capitalized)
                    Spacer()
                    Image(systemName: "checkmark")
                        .foregroundStyle(.blue)
                        .opacity(item == selection ? 1 : 0)
                }
                .contentShape(.rect)
                .onTapGesture {
                    selection = item
                    dismiss()
                }
                
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    RepetitionList(selection: .constant(.never))
}
