// © 2019 Ralf Ebert — TodosApp

import UIKit

private let cellReuseIdentifier = "LabelCell"

class TodosTableViewController: UITableViewController {

    let todosService = TodosService.shared
    var todos = [Todo]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Todos"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

        self.setupRefreshControl()
        self.setupAddButton()
        self.loadTodos()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadTodos()
    }

    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.loadTodos), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }

    private func setupAddButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.add))
    }

    @objc private func loadTodos() {
        self.todosService.todos { result in
            self.todos = result
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }

    @objc private func add() {
        self.edit(todo: Todo(title: "", url: nil))
    }

    fileprivate func edit(todo: Todo) {
        let alertController = UIAlertController(title: "Todo", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = todo.title
        }
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
            var editedTodo = todo
            editedTodo.title = alertController.textFields?.first?.text ?? ""
            self?.todosService.updateOrCreate(todo: editedTodo, completionHandler: { [weak self] _ in
                self?.loadTodos()
            })
        }))
        self.present(alertController, animated: true)
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)

        let todo = self.todos[indexPath.row]
        cell.textLabel?.text = todo.title

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = self.todos[indexPath.row]
            self.todosService.delete(todo: item) {
                self.loadTodos()
            }
        }
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = self.todos[indexPath.row]
        self.edit(todo: todo)
    }

}
