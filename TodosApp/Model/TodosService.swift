// © 2019 Ralf Ebert — TodosApp

import Foundation

struct Todo: Codable {
    let id: Int
    let title: String
    let url: URL
}

enum RequestError: Error {
    case noData
}

class TodosService {

    let baseURL: URL
    let urlSession = URLSession.shared
    let jsonDecoder = JSONDecoder()

    init(baseURL: URL = URL(string: "https://todos-3knzoatf.herokuapp.com/")!) {
        self.baseURL = baseURL
    }

    func todos(completionHandler: @escaping (Result<[Todo], Error>) -> Void) {
        let url = URL(string: "todos.json", relativeTo: baseURL)!
        let task = self.urlSession.dataTask(with: url) { data, _, error in
            if let error = error {
                completionHandler(Result.failure(error))
            }
            guard let data = data else {
                completionHandler(Result.failure(RequestError.noData))
                return
            }
            // TODO: handle http status codes
            do {
                let result = try self.jsonDecoder.decode([Todo].self, from: data)
                completionHandler(Result.success(result))
            } catch {
                completionHandler(Result.failure(error))
            }
        }
        task.resume()
    }

}
