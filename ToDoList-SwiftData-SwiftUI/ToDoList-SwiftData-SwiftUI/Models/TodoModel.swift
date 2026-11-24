//
//  Todo.swift
//  ToDoList-SwiftData-SwiftUI
//
//  Created by Jayaram G on 23/11/26.
//
import Foundation
import SwiftData
import SwiftUI

@Model
class TodoModel {
    var title: String
    var date: Date
    var isCompleted: Bool
    var tags:Set<Tag>
    
    init(title: String, date: Date = Date(), isCompleted: Bool = false, tags: Set<Tag> = []) {
        self.title = title
        self.date = date
        self.isCompleted = isCompleted
        self.tags = tags
    }
}

enum Tag: String, CaseIterable, Codable {
    case work, home, personal, urgent, shopping, study
    
    var color: Color {
        switch self {
        case .work:
            return .blue
        case .home:
            return .orange
        case .personal:
            return .green
        case .urgent:
            return .red
        case .shopping:
            return .purple
        case .study:
            return .indigo
        }
    }
}
