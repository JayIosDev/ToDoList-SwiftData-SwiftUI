import SwiftUI
import Playgrounds
import SwiftData

struct TodoListView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: [SortDescriptor(\TodoModel.date)])
    var dateTodos: [TodoModel]
    
    @Query(sort: [SortDescriptor(\TodoModel.title)])
    var titleTodos : [TodoModel]
    
    @State private var newTitle: String = ""
    
    enum SortOptions: String, CaseIterable {
        case byTitle =  "By Title"
        case byDate = "By Date"
    }
    
    @State private var selectedSortOption: SortOptions = .byTitle
    
    @State private var datePicker: Date = Date()
    
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    HStack {
                        // TextField
                        TextField("Todo title", text: $newTitle).textFieldStyle(RoundedBorderTextFieldStyle())
                        Button {
                            
                        } label: {
                            Text("Add").padding().fontWeight(.bold).background(.blue).clipShape(.rect(cornerRadius: 10)).foregroundStyle(.white)
                        }
                    }
                    
                    // Date Picker
                    DatePicker("Date", selection: $datePicker, in: Date()...)
                    
                    // Segment Picker
                    Picker("Sort Todos", selection: $selectedSortOption) {
                        ForEach(SortOptions.allCases, id: \.self) { option in
                            Text(option.rawValue)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                }.padding()
                
                // List
                List(sortedTodos, id: \.self) { todo in
                    HStack {
                        Text(todo.title)
                        Spacer()
                        VStack(alignment: .leading) {
                            Text(todo.title)
                            
                            Text(todo.date, style: .date)
                        }
                        
                    }.listStyle(PlainListStyle())
                    
                }
                
            }.navigationTitle("Todos")
        }
    }
    
    private var sortedTodos: [TodoModel] {
        switch selectedSortOption {
        case .byTitle:
            return titleTodos
        case .byDate:
            return dateTodos
        }
    }
    
    func addTodos() {
        
    }
    
    func deleteTodo(_ todo: TodoModel) {
        
    }
}

#Preview {
    TodoListView().modelContainer(for: TodoModel.self)
}

#Playground {
    _ = 1 + 2
}
