// © 2019 Ralf Ebert — TodosApp

import Foundation

struct Todo: Codable {
    var title: String?
    let url: URL?
}

struct TodoBody: Codable {
    let todo: Todo
}

class TodosService {

    let baseURL: URL
    let urlSession = URLSession.shared
    let jsonDecoder = JSONDecoder()
    let jsonEncoder = JSONEncoder()

    static let shared = TodosService()

    private init(baseURL: URL = URL(string: "https://todos-3knzoatf.herokuapp.com/")!) {
        self.baseURL = baseURL
    }

    func todos(completionHandler: @escaping ([Todo]) -> Void) {
        let url = URL(string: "todos.json", relativeTo: baseURL)!
        let task = self.urlSession.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                // TODO: Fehler-Handling implementieren
                fatalError(error!.localizedDescription)
            }
            let code = (response as! HTTPURLResponse).statusCode
            // TODO: Fehler-Handling implementieren
            assert(code >= 200 && code < 300)
            let result = try! self.jsonDecoder.decode([Todo].self, from: data)
            completionHandler(result)
        }
        task.resume()
    }

    func updateOrCreate(todo: Todo, completionHandler: @escaping (Todo) -> Void) {
        var request: URLRequest
        if let url = todo.url {
            // update
            request = URLRequest(url: url)
            request.httpMethod = "PUT"
        } else {
            // create
            let url = URL(string: "todos.json", relativeTo: baseURL)!
            request = URLRequest(url: url)
            request.httpMethod = "POST"
        }
        request.httpBody = try! self.jsonEncoder.encode(TodoBody(todo: todo))
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = self.urlSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                // TODO: Fehler-Handling implementieren
                fatalError(error!.localizedDescription)
            }
            let code = (response as! HTTPURLResponse).statusCode
            // TODO: Fehler-Handling implementieren
            assert(code >= 200 && code < 300)
            let result = try! self.jsonDecoder.decode(Todo.self, from: data)
            completionHandler(result)
        }
        task.resume()
    }

    func delete(todo: Todo, completionHandler: @escaping () -> Void) {
        if let url = todo.url {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            let task = self.urlSession.dataTask(with: request) { _, response, error in
                guard error == nil else {
                    // TODO: Fehler-Handling implementieren
                    fatalError(error!.localizedDescription)
                }
                let code = (response as! HTTPURLResponse).statusCode
                // TODO: Fehler-Handling implementieren
                assert(code >= 200 && code < 300)
                completionHandler()
            }
            task.resume()
        }
    }

}
