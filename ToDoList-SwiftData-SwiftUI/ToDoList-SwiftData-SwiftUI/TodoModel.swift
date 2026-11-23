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
    
    init(title: String, date: Date) {
        self.title = title
        self.date = date
    }
    
}
