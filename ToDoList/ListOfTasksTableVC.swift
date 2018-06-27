//
//  ListOfTasksTableViewController.swift
//  ToDoList
//
//  Created by Станислав Тищенко on 26.06.2018.
//  Copyright © 2018 Станислав Тищенко. All rights reserved.
//

import UIKit

class ListOfTasksTableVC: UITableViewController, DetailOfTaskDelegate {
    //var listOfTask = [Task]()
    var dataModel: DataModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.tasks.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        //cell.textLabel?.text = listOfTask[indexPath.row].description
        let task = dataModel.tasks[indexPath.row]
        setText(cell: cell, task: task)
        setCheck(cell: cell, task: task)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            dataModel.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let task = dataModel.tasks[indexPath.row]
            task.toggleChecked()
            setCheck(cell: cell, task: task)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditTask" {
            let controller = segue.destination as! DetailOfTaskTableVC
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.currentTask = dataModel.tasks[indexPath.row]
            }
        } else if segue.identifier == "AddTask" {
            let controller = segue.destination as! DetailOfTaskTableVC
            controller.delegate = self
        }
    }


    func setCheck(cell: UITableViewCell, task: Task) {
        let label = cell.viewWithTag(1) as! UILabel
        if task.checked {
            label.text = "✔️"
        } else {
            label.text = ""
        }
    }

    func setText(cell: UITableViewCell, task: Task) {
        let label = cell.viewWithTag(2) as! UILabel
        label.text = task.name
    }

    func editTask(task: Task) {
        if let index = dataModel.tasks.index(of: task) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                setText(cell: cell, task: task)
            }
        }
        navigationController?.popViewController(animated: true)
    }

    func addTask(task: Task) {
        let index = dataModel.tasks.count
        dataModel.tasks.append(task)
        let indexPath = IndexPath(row: index, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        navigationController?.popViewController(animated: true)
    }
}
