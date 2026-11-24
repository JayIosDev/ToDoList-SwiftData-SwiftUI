//
//  InputView.swift
//  ToDoList-SwiftData-SwiftUI
//
//  Created by Jayaram G on 24/11/26.
//
import SwiftUI
struct InputView: View {
    @Binding var newTitle: String
    var addTodoAction : () -> Void
    var body: some View {
        HStack {
            
            // TextField
            TextField("Todo title", text: $newTitle).textFieldStyle(RoundedBorderTextFieldStyle())
            Button {
                addTodoAction()
            } label: {
                Text("Add").padding().fontWeight(.bold).background(.blue).clipShape(.rect(cornerRadius: 10)).foregroundStyle(.white)
            }
        }.padding()
    }
}
