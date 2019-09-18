// © 2019 Ralf Ebert — TodosApp

import CoreData

extension NSManagedObjectContext {

    func object(with url: URL) -> NSManagedObject {
        self.object(with: self.persistentStoreCoordinator!.managedObjectID(forURIRepresentation: url)!)
    }

}
