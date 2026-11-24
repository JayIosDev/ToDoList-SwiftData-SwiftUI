//
//  ToggleViews.swift
//  ToDoList-SwiftData-SwiftUI
//
//  Created by Jayaram G on 24/11/26.
//
import SwiftUI

struct ToggleViews: View {
    
    @Binding var showCompletedTodos: Bool
    @Binding var showTodaysTodos: Bool
    
    var body: some View {
        Toggle("Show Completed Only", isOn: $showCompletedTodos).padding()
                        
        Toggle("Show Today's Todos", isOn: $showTodaysTodos).padding()
        
    }
    
}

