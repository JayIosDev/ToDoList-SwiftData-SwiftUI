import SwiftUI
import Playgrounds
import SwiftData

struct TodoListView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: [SortDescriptor(\TodoModel.date)])
    var dateTodos: [TodoModel]
    
    @Query(sort: [SortDescriptor(\TodoModel.title)])
    var titleTodos : [TodoModel]
    
    @Query(filter: #Predicate <TodoModel>{ todo in
        todo.isCompleted
    }, sort: [SortDescriptor(\TodoModel.date)])
    var completedDateTodos: [TodoModel]
    
    @Query(filter: #Predicate<TodoModel> { todo in
        todo.isCompleted
    }, sort: [SortDescriptor(\TodoModel.title)])
    var completedTitleTodos: [TodoModel]
    
    @State private var showCompletedTodos: Bool = false
    
    @State private var newTitle: String = ""
    
    enum SortOptions: String, CaseIterable {
        case byTitle =  "By Title"
        case byDate = "By Date"
    }
    
    @State private var selectedSortOption: SortOptions = .byTitle
    
    @State private var selectedDate: Date = Date()
    
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    HStack {
                        
                        // TextField
                        TextField("Todo title", text: $newTitle).textFieldStyle(RoundedBorderTextFieldStyle())
                        Button {
                            addTodos()
                        } label: {
                            Text("Add").padding().fontWeight(.bold).background(.blue).clipShape(.rect(cornerRadius: 10)).foregroundStyle(.white)
                        }
                    }
                    
                    // Date Picker
                    DatePicker("Select Date", selection: $selectedDate, in: Date()...)
                    
                    // Segment Picker
                    Picker("Sort Todos", selection: $selectedSortOption) {
                        ForEach(SortOptions.allCases, id: \.self) { option in
                            Text(option.rawValue)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                }.padding()
                
                Toggle("Show Completed Only", isOn: $showCompletedTodos).padding()
                
                // List
                List(sortedTodos, id: \.self) { todo in
                    HStack {
                        Button {
                            toggleTodos(todo)
                        } label: {
                            Image(systemName: todo.isCompleted ? "checkmark.circle": "circle").font(.caption).foregroundStyle(todo.isCompleted ? .green : .gray)
                        }
                        Text(todo.title).foregroundStyle(todo.isCompleted ? .green : .blue).strikethrough(todo.isCompleted)
                        
                        Spacer()
                        VStack(alignment: .leading) {
                            Text(todo.date, style: .date)
                            Text(todo.date, style: .time).font(.caption).foregroundStyle(.secondary)
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
                
                
                
            }.navigationTitle("Todos")
        }
    }
    
    private var sortedTodos: [TodoModel] {
        switch selectedSortOption {
        case .byTitle:
            showCompletedTodos ? completedTitleTodos : titleTodos
        case .byDate:
            showCompletedTodos ? completedDateTodos : dateTodos
        }
    }
    
    func addTodos() {
        guard newTitle.count >= 2 else {
            print("Title Should be more than 2 characters")
            return
        }
        let newTodo = TodoModel(title: newTitle, date: selectedDate)
        modelContext.insert(newTodo)
        
        do {
            try modelContext.save()
        }catch {
            print("Failed to save todo: \(error.localizedDescription)")
        }
        
        newTitle = ""
        selectedDate = Date()
    }
    
    func deleteTodo(_ todo: TodoModel) {
        modelContext.delete(todo)
        try? modelContext.save()
    }
    
    func toggleTodos(_ todo: TodoModel) {
        todo.isCompleted.toggle()
        try? modelContext.save()
    }
}

#Preview {
    TodoListView().modelContainer(for: TodoModel.self)
}

#Playground {
    _ = 1 + 2
}
