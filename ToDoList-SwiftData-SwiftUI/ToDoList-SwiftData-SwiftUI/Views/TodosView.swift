import SwiftUI
import Playgrounds
import SwiftData

struct TodosView: View {
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
    
    private var sortedTodos: [TodoModel] {
        switch selectedSortOption {
        case .byTitle:
            showCompletedTodos ? completedTitleTodos : titleTodos
        case .byDate:
            showCompletedTodos ? completedDateTodos : dateTodos
        }
    }
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
    
    @Query(TodosView.todayFetchDescriptor)
    private var todayTodos: [TodoModel]
    
    @State private var showTodaysTodos: Bool = false
    
    @State private var selectedSortOption: SortOptions = .byTitle
    
    @State private var selectedDate: Date = Date()
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack {
                        // TextField View
                        InputView(newTitle: $newTitle) {
                            addTodos()
                        }
                        // Date Picker
                        DatePickerView(selectedDate: $selectedDate).padding()
                        // Select Tag View
                        ColorTagsView(selectedTags: $selectedTags) { tag in
                            toggelTag(tag)
                        }.padding()
                        
                        // Segment Picker
                        SegmentPickerView(selectedSortOption: $selectedSortOption)
                        
                        // Toggle Completed and Todays todos
                        ToggleViews(showCompletedTodos: $showCompletedTodos, showTodaysTodos: $showTodaysTodos)
                        
                        // List View
                        TodosListView(showTodaysTodos: $showTodaysTodos, sortedTodos: sortedTodos, todayTodos: todayTodos, /*sevenDaysTodos: sevenDaysTodos*/) { todo in
                            toggleTodos(todo)
                        } deleteTodo: { todo in
                            deleteTodo(todo)
                        }
                        
                    }.navigationTitle("Todos")
                }
            }
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
    TodosView().modelContainer(for: TodoModel.self)
}

#Playground {
    _ = 1 + 2
}
