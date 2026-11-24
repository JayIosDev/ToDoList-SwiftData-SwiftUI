//
//  TodosListView.swift
//  ToDoList-SwiftData-SwiftUI
//
//  Created by Jayaram G on 24/11/26.
//

import SwiftUI

struct TodosListView: View {
    @Binding var showTodaysTodos: Bool
     var sortedTodos: [TodoModel]
     var todayTodos: [TodoModel]
//     var sevenDaysTodos: [TodoModel]
    
    var toggleTodos:(TodoModel) -> Void
    var deleteTodo: (TodoModel) -> Void
    
    var body: some View {
        
        LazyVStack(spacing: 10) {
            ForEach(showTodaysTodos ? todayTodos : sortedTodos, id: \.self) { todo in
                //List(sevenDaysTodos, id: \.self) { todo in
                HStack {
                    Button {
                        toggleTodos(todo)
                    } label: {
                        Image(systemName: todo.isCompleted ? "checkmark.circle": "circle").font(.caption).foregroundStyle(todo.isCompleted ? .green : .gray)
                    }
                    Text(todo.title).foregroundStyle(todo.isCompleted ? .green : .blue).strikethrough(todo.isCompleted)
                    
                    Spacer()
                    VStack(alignment: .trailing) {
                        VStack(alignment: .leading) {
                            Text(todo.date, style: .date)
                            Text(todo.date, style: .time).font(.caption).foregroundStyle(.secondary)
                        }
                        HStack {
                            let tagsSorted = todo.tags.sorted(by: {$0.rawValue < $1.rawValue})
                            
                            ForEach(tagsSorted, id: \.self) { tag in
                                Text(tag.rawValue.capitalized).padding(.horizontal, 8).padding(.vertical, 4).background(tag.color).foregroundStyle(.white).font(.caption).clipShape(Capsule())
                                
                            }
                        }
                        
                    }
                }.listStyle(PlainListStyle()).swipeActions {
                    Button(role: .destructive) {
                        deleteTodo(todo)
                    } label: {
                        Label {
                            Text("Delete")
                        } icon: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
        }.padding()
        
    }
}

#Preview {
    TodosListView(showTodaysTodos: .constant(false), sortedTodos: [], todayTodos: [], /*sevenDaysTodos: [],*/ toggleTodos: { _ in }, deleteTodo: { _ in })
}
