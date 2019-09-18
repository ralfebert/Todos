// © 2019 Ralf Ebert — TodosApp

import CoreData

class NSFetchRequestObserver<ResultType: NSFetchRequestResult>: NSObject, NSFetchedResultsControllerDelegate {

    typealias Observer = () -> Void

    let fetchRequest: NSFetchRequest<ResultType>
    let fetchedResultsController: NSFetchedResultsController<ResultType>
    var onChange: Observer?
    var fetchedObjects: [ResultType] {
        return self.fetchedResultsController.fetchedObjects!
    }

    init(fetchRequest: NSFetchRequest<ResultType>, managedObjectContext: NSManagedObjectContext) {
        self.fetchRequest = fetchRequest
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        self.fetchedResultsController.delegate = self
        try! self.fetchedResultsController.performFetch()
    }

    func controllerDidChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
        self.onChange?()
    }

}
