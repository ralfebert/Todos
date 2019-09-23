// © 2019 Ralf Ebert — TodosApp

import Foundation

struct Todo {
    var id: UUID
    var text: String

    init(id: UUID = UUID(), text: String) {
        self.id = id
        self.text = text
    }
}

class TodosModel {

    private(set) var todos = [Todo(text: "Todo 1"), Todo(text: "Todo 2"), Todo(text: "Todo 3")] {
        didSet {
            self.onChange?()
        }
    }

    var onChange: (() -> Void)?

    func update(todo: Todo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            self.todos[index] = todo
        } else {
            self.todos.append(todo)
        }
    }

    func delete(todo: Todo) {
        self.todos.removeAll { $0.id == todo.id }
    }

}
