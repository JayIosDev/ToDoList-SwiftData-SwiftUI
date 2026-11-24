import SwiftUI
import SwiftData
@main struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            TodosView().modelContainer(for: TodoModel.self)
        }
    }
}
