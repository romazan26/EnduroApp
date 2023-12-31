//
//  TaskMotoTableViewController.swift
//  EnduroApp
//
//  Created by Роман on 10.07.2023.
//

import UIKit
import RealmSwift

class TaskMotoTableViewController: UITableViewController {

    var user: User!
    
    private var currentTasks: Results<TaskOfMoto>!
    private var completedTasks: Results<TaskOfMoto>!
    private let storageManager = StorageManager.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = user.userName
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonPressed)
        )
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
        
        currentTasks = user.userData[0].taskOfMoto.filter("isComplete = false")
        completedTasks = user.userData[0].taskOfMoto.filter("isComplete = true")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? currentTasks.count : completedTasks.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "CURRENT TASKS" : "COMPLETED TASKS"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let task = indexPath.section == 0
            ? currentTasks[indexPath.row]
            : completedTasks[indexPath.row]
        content.text = task.taskTitle
        content.secondaryText = task.engineHours
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let task = indexPath.section == 0
            ? currentTasks[indexPath.row]
            : completedTasks[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, _ in
            storageManager.delete(task)
            //tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [unowned self] _, _, isDone in
            showAlert(with: task) {
            tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        
        let doneAction = UIContextualAction(style: .normal, title: "Done") { [unowned self] _, _, isDone in
            storageManager.done(task)
            //tableView.reloadRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
            isDone(true)
        }
        
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [doneAction, editAction, deleteAction])
    }
    @objc private func addButtonPressed() {
        showAlert()
    }
}
extension TaskMotoTableViewController {
    private func showAlert(with task: TaskOfMoto? = nil, completion: (() -> Void)? = nil) {
           let alertBuilder = AlertControllerBuilder(
               title: task != nil ? "Edit Task" : "New Task",
               message: "What do you want to do?"
           )
           
           alertBuilder
            .setTextFields(task: task?.taskTitle, engineHours: task?.engineHours)
               .addAction(
                   title: task != nil ? "Update Task" : "Save Task",
                   style: .default
               ) { [weak self] taskTitle, engineHours in
                   if let task, let completion {
                       self?.storageManager.edit(
                        task,
                        newValue: taskTitle,
                        newEngineHours: engineHours
                       )
                       
                       completion()
                       return
                   }
                   self?.save(task: taskTitle, withEngineHours: engineHours)
               }
               .addAction(title: "Cancel", style: .destructive)
           
           let alertController = alertBuilder.build()
           present(alertController, animated: true)
       }
    
    private func save(task: String, withEngineHours engineHours: String) {
        storageManager.save(task, withEngineHours: engineHours, to: user.userData[0]) { moto in
            let rowIndex = IndexPath(row: currentTasks.index(of: moto) ?? 0, section: 0)
            tableView.insertRows(at: [rowIndex], with: .automatic)
        }
        }
    
    
    
}
