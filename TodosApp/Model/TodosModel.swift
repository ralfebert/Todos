// © 2019 Ralf Ebert — TodosApp

import CoreData

struct Todo: Identifiable, Codable {

    static let idNew = URL(string: "todo:new")!

    var id: URL
    var text: String
}

class TodosModel: NSObject {

    private var persistentContainer: NSPersistentContainer
    private var todosFetchedResultsController: NSFetchedResultsController<CTodo>

    var todos: [Todo] {
        todosFetchedResultsController.fetchedObjects!.map {
            Todo(id: $0.objectID.uriRepresentation(), text: $0.text!)
        }
    }

    override init() {
        precondition(Thread.isMainThread)
        self.persistentContainer = NSPersistentContainer(defaultContainerWithName: "CTodo")

        let fetchRequest: NSFetchRequest<CTodo> = CTodo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "text", ascending: true)]
        self.todosFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)

        super.init()

        try! self.todosFetchedResultsController.performFetch()
        self.todosFetchedResultsController.delegate = self
    }

    var onChange: (() -> Void)?

    private var viewContext: NSManagedObjectContext {
        self.persistentContainer.viewContext
    }

    private func fetchTodo(id: URL) -> CTodo {
        return self.viewContext.object(with: self.viewContext.persistentStoreCoordinator!.managedObjectID(forURIRepresentation: id)!) as! CTodo
    }

    func update(todo: Todo) {
        let ctodo: CTodo
        if todo.id == Todo.idNew {
            ctodo = NSEntityDescription.insertNewObject(forEntityName: CTodo.entityName, into: self.viewContext) as! CTodo
        } else {
            ctodo = self.fetchTodo(id: todo.id)
        }
        ctodo.text = todo.text
        try! self.viewContext.save()
    }

    func delete(todo: Todo) {
        self.viewContext.delete(self.fetchTodo(id: todo.id))
        try! self.viewContext.save()
    }

}

extension TodosModel: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
        self.onChange?()
    }

}
