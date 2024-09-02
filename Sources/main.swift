import Foundation

// * Create the `Todo` struct.
// * Ensure it has properties: id (UUID), title (String), and isCompleted (Bool).
struct Todo: Identifiable, Codable {
    var id = UUID()
    var title: String = ""
    var bool: Bool = false

    init(title: String){
        self.title = title
    }
}

var list: [Todo] = [
    Todo(title: "clean room"),
    Todo(title: "clean car"),
    Todo(title: "clean backpack"),
    Todo(title: "Cut Grass"),
    Todo(title: "Buy cleaning supply")
]


protocol Cache {
    func load() -> [Todo]
    func save(todos: [Todo])
}

// `FileSystemCache`: This implementation should utilize the file system
// to persist and retrieve the list of todos.
// Utilize Swift's `FileManager` to handle file operations.
final class JSONFileManagerCache: Cache {
    private let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    private let doucumentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("output.txt")
   
    private let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
    private let cacheDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("output.txt")
    private var docString: String
    let fileURL: URL
    
    
    init() {
        docString = doucumentDir?.path ?? ""
        fileURL = URL(fileURLWithPath: docString, relativeTo: directoryURL.first)
    }
        
    func load() -> [Todo]{
        do {
            let loadSaveDate = try Data(contentsOf: fileURL)
            
            let decoder = JSONDecoder()
            var listOfTodo = try decoder.decode([Todo].self, from: loadSaveDate)
            print(listOfTodo)
            
            return listOfTodo
        } catch {
        //    Errors
            print("Error reading file")
            return []
        }
    }
    
    func save(todos: [Todo]) {
        var tempArr = todos
        
        if todos.isEmpty {
            return
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(todos)
            try data.write(to: fileURL)
            
        } catch {
        //    Errors
            print("Error reading file")
        }
    }

}

// `InMemoryCache`: : Keeps todos in an array or similar structure during the session.
// This won't retain todos across different app launches,
// but serves as a quick in-session cache.
final class InMemoryCache: Cache {
    var jsonFileManager = JSONFileManagerCache()
    
    func load() -> [Todo] {
        return jsonFileManager.load()
    }
    
    func save(todos: [Todo]) {
        jsonFileManager.save(todos: todos)
    }
    

}

// The `TodosManager` class should have:
// * A function `func listTodos()` to display all todos.
// * A function named `func addTodo(with title: String)` to insert a new todo.
// * A function named `func toggleCompletion(forTodoAtIndex index: Int)`
//   to alter the completion status of a specific todo using its index.
// * A function named `func deleteTodo(atIndex index: Int)` to remove a todo using its index.
final class TodoManager {
    
    private var todoList: [Todo] = []

    func listTodos(){
        for todo in 0..<todoList.count {
            let currentIndex = todo + 1
            print("\(currentIndex). \(todoList[todo])")
        }
    }

    func addTodo(title: String){
        todoList.append(Todo(title: title))
    }
    
    func toggleCompletion(forTodoAtIndex index: Int){
        let selectedIndex = index - 1
        if selectedIndex < todoList.count {
            todoList[selectedIndex].bool = !todoList[selectedIndex].bool
        }
    }
    
    func deleteToDo(atIndex index: Int){
        let removeIndex = index - 1
        if removeIndex < todoList.count {
            todoList.remove(at: removeIndex)
        }
    }

}


// * The `App` class should have a `func run()` method, this method should perpetually
//   await user input and execute commands.
//  * Implement a `Command` enum to specify user commands. Include cases
//    such as `add`, `list`, `toggle`, `delete`, and `exit`.
//  * The enum should be nested inside the definition of the `App` class
final class App {
    
    func run(){
        print("Add Select a option")
        var temp = Int(readLine()!)!
        
        print(temp)
    }

    run()

}


// TODO: Write code to set up and run the app.
App()
