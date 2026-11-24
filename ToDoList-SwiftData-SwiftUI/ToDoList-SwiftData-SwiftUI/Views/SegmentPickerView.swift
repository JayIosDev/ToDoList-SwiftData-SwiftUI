//
//  SegmentPickerView.swift
//  ToDoList-SwiftData-SwiftUI
//
//  Created by Jayaram G on 24/11/26.
//

import SwiftUI

struct SegmentPickerView: View {
    
    @Binding var selectedSortOption: SortOptions
    
    var body: some View {
        Picker("Sort Todos", selection: $selectedSortOption) {
            ForEach(SortOptions.allCases, id: \.self) { option in
                Text(option.rawValue)
            }
        }.pickerStyle(SegmentedPickerStyle()).padding()
    }
    
}

#Preview {
    SegmentPickerView(selectedSortOption: .constant(.byTitle))
}
