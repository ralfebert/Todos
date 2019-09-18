// © 2019 Ralf Ebert — TodosApp

import CoreData

struct Todo: Identifiable, Codable {

    static let idNew = URL(string: "todo:new")!

    var id: URL
    var text: String
}

extension Todo {

    fileprivate init(coreDataTodo todo: CTodo) {
        self.init(id: todo.objectID.uriRepresentation(), text: todo.text!)
    }

}

class TodosModel {

    var todos: [Todo] {
        self.todosObserver.fetchedObjects.map(Todo.init(coreDataTodo:))
    }

    private var persistentContainer: NSPersistentContainer
    private var todosObserver: NSFetchRequestObserver<CTodo>

    init() {
        precondition(Thread.isMainThread)

        self.persistentContainer = NSPersistentCloudKitContainer(defaultContainerWithName: "CTodo")

        let fetchRequest: NSFetchRequest<CTodo> = CTodo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "text", ascending: true)]
        self.todosObserver = NSFetchRequestObserver(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext)

        self.viewContext.automaticallyMergesChangesFromParent = true
    }

    var onChange: (() -> Void)? {
        get { return self.todosObserver.onChange }
        set { self.todosObserver.onChange = newValue }
    }

    private var viewContext: NSManagedObjectContext {
        self.persistentContainer.viewContext
    }

    private func fetchTodo(id: URL) -> CTodo {
        guard id != Todo.idNew else {
            return NSEntityDescription.insertNewObject(forEntityName: CTodo.entityName, into: self.viewContext) as! CTodo
        }

        return self.viewContext.object(with: id) as! CTodo
    }

    func update(todo: Todo) {
        let ctodo = self.fetchTodo(id: todo.id)
        ctodo.text = todo.text
        try! self.viewContext.save()
    }

    func delete(todo: Todo) {
        self.viewContext.delete(self.fetchTodo(id: todo.id))
        try! self.viewContext.save()
    }

}
