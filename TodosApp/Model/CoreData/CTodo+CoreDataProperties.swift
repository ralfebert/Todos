// © 2019 Ralf Ebert — TodosApp

import CoreData
import Foundation

extension CTodo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CTodo> {
        return NSFetchRequest<CTodo>(entityName: "CTodo")
    }

    @NSManaged public var text: String?

}
