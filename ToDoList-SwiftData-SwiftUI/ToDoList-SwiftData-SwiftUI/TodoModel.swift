//
//  Todo.swift
//  ToDoList-SwiftData-SwiftUI
//
//  Created by Jayaram G on 23/11/26.
//
import Foundation
import SwiftData

@Model
class TodoModel {
    var title: String
    var date: Date
    var isCompleted: Bool
    
    init(title: String, date: Date = Date(), isCompleted: Bool = false) {
        self.title = title
        self.date = date
        self.isCompleted = isCompleted
    }
    
}
