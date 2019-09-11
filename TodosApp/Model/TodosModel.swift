// © 2019 Ralf Ebert — TodosApp

import Foundation

struct TodoDocument: Codable {
    var todos: [Todo]
}

struct Todo: Identifiable, Codable {
    var id: UUID
    var text: String
}

class TodosModel {

    var persistence = JSONDocumentPersistence<TodoDocument>(filename: "todos.json")
    private(set) var todos = [Todo]() {
        didSet {
            self.persistence.persistedValue = TodoDocument(todos: self.todos)
            self.onChange?()
        }
    }

    init() {
        self.todos = self.persistence.persistedValue?.todos ?? []
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
