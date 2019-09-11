// © 2019 Ralf Ebert — TodosApp

import Foundation

struct JSONDocumentPersistence<T: Codable> {

    let decoder = JSONDecoder()
    let encoder = JSONEncoder()

    var url: URL
    var persistedValue: T? {
        get {
            try! self.load()
        }
        set {
            try! self.save(newValue)
        }
    }

    init(filename: String) {
        self.url = FileManager.default.documentsDirectoryUrl.appendingPathComponent(filename)
    }

    func load() throws -> T? {
        if FileManager.default.fileExists(atPath: self.url.path) {
            let data = try Data(contentsOf: url)
            return try self.decoder.decode(T.self, from: data)
        } else {
            return .none
        }
    }

    func save(_ value: T?) throws {
        if let value = value {
            let data = try encoder.encode(value)
            try data.write(to: self.url, options: .atomicWrite)
        }
    }

}
