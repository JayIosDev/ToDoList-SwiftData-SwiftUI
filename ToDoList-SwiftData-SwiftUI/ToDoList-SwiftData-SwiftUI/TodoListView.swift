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
    
    @State private var selectedTags: Set<Tag> = []
    @State private var tagCount:Int = 0
    
    /*
     // Fetch Descriptor for all todos from now up until
     // at most seven. (Seven days into the future)
     static var sevenDaysFetchDescriptor: FetchDescriptor<TodoModel> {
     let date = Date()
     
     let aWeek = Calendar.current.date(byAdding: .day, value: 7, to: date)!
     
     let fetchDescriptor = FetchDescriptor<TodoModel>(predicate: #Predicate {
     $0.date <= aWeek
     }, sortBy: [SortDescriptor(\.date)])
     
     return fetchDescriptor
     }
     
     @Query(TodoListView.sevenDaysFetchDescriptor)
     private var sevenDaysTodos: [TodoModel]
     */
    
    
    
    // Today Todos
    static var todayFetchDescriptor: FetchDescriptor<TodoModel> {
        let date = Date()
        
        let beginningOfTheDay = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
        let endOfTheDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date)!
        
        let descriptor = FetchDescriptor<TodoModel>(predicate: #Predicate{
            $0.date >= beginningOfTheDay && $0.date <= endOfTheDay
        }, sortBy: [SortDescriptor(\.date)])
        return descriptor
    }
    
    @Query(TodoListView.todayFetchDescriptor)
    private var todayTodos: [TodoModel]
    
    @State private var showTodaysTodos: Bool = false
    
    
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
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(Tag.allCases, id: \.self) { tag in
                                Button {
                                    //TODO: Toggle
                                    toggelTag(tag)
                                } label: {
                                    Text(tag.rawValue.capitalized).padding(.horizontal, 10).padding(.vertical, 10).background(selectedTags.contains(tag) ? tag.color.opacity(0.8) : .gray.opacity(0.3)).foregroundStyle(.white).clipShape(Capsule())
                                }
                                
                            }
                        }
                    }.scrollIndicators(.hidden)
                    
                    // Segment Picker
                    Picker("Sort Todos", selection: $selectedSortOption) {
                        ForEach(SortOptions.allCases, id: \.self) { option in
                            Text(option.rawValue)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                }.padding()
                
                Toggle("Show Completed Only", isOn: $showCompletedTodos).padding()
                
                Toggle("Show Today's Todos", isOn: $showTodaysTodos).padding()
                
                // List
                List(showTodaysTodos ? todayTodos : sortedTodos, id: \.self) { todo in
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
        let newTodo = TodoModel(title: newTitle, date: selectedDate, tags: selectedTags)
        modelContext.insert(newTodo)
        
        do {
            try modelContext.save()
        }catch {
            print("Failed to save todo: \(error.localizedDescription)")
        }
        
        newTitle = ""
        selectedTags = []
        selectedDate = Date()
        tagCount = 0
    }
    
    func deleteTodo(_ todo: TodoModel) {
        modelContext.delete(todo)
        try? modelContext.save()
    }
    
    func toggleTodos(_ todo: TodoModel) {
        todo.isCompleted.toggle()
        try? modelContext.save()
    }
    
    func toggelTag(_ tag: Tag) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
            tagCount -= 1
        }else {
            if tagCount < 3 {
                selectedTags.insert(tag)
                tagCount += 1
            }
        }
    }
}

#Preview {
    TodoListView().modelContainer(for: TodoModel.self)
}

#Playground {
    _ = 1 + 2
}
