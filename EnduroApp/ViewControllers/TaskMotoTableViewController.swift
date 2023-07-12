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
    
    private var currentTasks: Results<Moto>!
    private var completedTasks: Results<Moto>!
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
        
        currentTasks = user.userData[0].moto.filter("isComplete = true")
        completedTasks = user.userData[0].moto.filter("isComplete = true")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? currentTasks.count : completedTasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        content.text = task.taskTitle
        content.secondaryText = task.engineСapacity
        cell.contentConfiguration = content
        return cell
    }
    
    @objc private func addButtonPressed() {
        
    }
}
extension TaskMotoTableViewController {
    private func showAlert(with task: Moto? = nil, completion: (() -> Void)? = nil) {
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
                       // TODO: - edit task
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
