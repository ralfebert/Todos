// © 2019 Ralf Ebert — TodosApp

import UIKit

private let cellReuseIdentifier = "LabelCell"

class TodosTableViewController: UITableViewController {

    let service = TodosService()
    var todos = [Todo]()

    @objc private func loadTodos() {
        self.service.todos { result in
            switch result {
                case let .success(list):
                    self.todos = list
                    OperationQueue.main.addOperation {
                        self.tableView.reloadData()
                    }
                case let .failure(error):
                    fatalError(String(describing: error))
            }
        }

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.loadTodos), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Todos"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.loadTodos()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)

        let item = self.todos[indexPath.row]
        cell.textLabel?.text = item.title

        return cell
    }

}
