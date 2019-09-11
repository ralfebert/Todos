// © 2019 Ralf Ebert — TodosApp

import Foundation

extension FileManager {

    var documentsDirectoryUrl: URL {
        return self.urls(for: .documentDirectory, in: .userDomainMask).last!
    }

}
