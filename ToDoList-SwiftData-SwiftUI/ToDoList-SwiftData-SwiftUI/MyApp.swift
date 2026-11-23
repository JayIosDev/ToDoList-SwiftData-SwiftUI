import SwiftUI
import SwiftData
@main struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            TodoListView().modelContainer(for: TodoModel.self)
        }
    }
}
