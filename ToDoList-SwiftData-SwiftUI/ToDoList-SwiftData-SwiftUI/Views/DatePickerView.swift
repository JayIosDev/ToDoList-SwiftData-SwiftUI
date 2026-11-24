//
//  DatePickerView.swift
//  ToDoList-SwiftData-SwiftUI
//
//  Created by Jayaram G on 24/11/26.
//
import SwiftUI

struct DatePickerView: View {
    @Binding var selectedDate:Date
    var body: some View {
        // Date Picker
        DatePicker("Select Date", selection: $selectedDate, in: Date()...)
    }
}
