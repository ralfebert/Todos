// © 2019 Ralf Ebert — TodosApp

import UIKit

private let cellReuseIdentifier = "LabelCell"

class TodosTableViewController: UITableViewController {

    let model = TodosModel()
    var todos = [Todo]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.model.onChange = { [weak self] in
            self?.refresh()
        }

        self.navigationItem.title = "Todos"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(Self.add))
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.refresh()
    }

    private func refresh() {
        self.todos = self.model.todos
        self.tableView.reloadData()
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)

        let todo = self.todos[indexPath.row]
        cell.textLabel?.text = todo.text

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.edit(todo: self.todos[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.model.delete(todo: self.todos[indexPath.row])
        }
    }

    // MARK: - Edit operations

    @objc private func add() {
        self.edit(todo: Todo(id: Todo.idNew, text: ""))
    }

    fileprivate func edit(todo: Todo) {
        let alertController = UIAlertController(title: "Todo", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = todo.text
        }
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
            var editedTodo = todo
            editedTodo.text = alertController.textFields?.first?.text ?? ""
            self?.model.update(todo: editedTodo)
        }))
        self.present(alertController, animated: true)
    }

}
