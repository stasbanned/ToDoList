//
//  DetailOfTask.swift
//  ToDoList
//
//  Created by Станислав Тищенко on 26.06.2018.
//  Copyright © 2018 Станислав Тищенко. All rights reserved.
//

import UIKit

protocol DetailOfTaskDelegate {
    func addTask(task: Task)
    func editTask(task: Task)
}

class DetailOfTaskTableVC: UITableViewController {
    var currentTask: Task?
    var delegate: DetailOfTaskDelegate?
    var dueDate = Date()
    var datePickerVisible = false
    var priority = ""
    var priorityVisible = false

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var remindSwitch: UISwitch!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var priorityCell: UITableViewCell!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var descriptionTextView: UITextView!

    
    @IBAction func cancelButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        if let currentTask = currentTask {
            currentTask.name = nameText.text!
            currentTask.remind = remindSwitch.isOn
            currentTask.date = dueDate
            currentTask.priority = priority
            currentTask.descript = descriptionTextView.text
            delegate?.editTask(task: currentTask)
        } else {
            let task = Task()
            task.name = nameText.text!
            task.checked = false
            task.remind = remindSwitch.isOn
            task.date = dueDate
            task.priority = priority
            task.descript = descriptionTextView.text
            delegate?.addTask(task: task)
        }
    }

    @IBAction func dateChanged(_ datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }

    @IBAction func priorityChanged(_ sender: Any) {
        priority = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
        updatePriorityLabel()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        if let currentTask = currentTask {
            nameText.text = currentTask.name
            remindSwitch.isOn = currentTask.remind
            dueDate = currentTask.date
            priority = currentTask.priority
            descriptionTextView.text = currentTask.descript
        }
        updateDueDateLabel()
        updatePriorityLabel()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else if indexPath.section == 2 && indexPath.row == 1 {
            return priorityCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3
        } else if section == 2 && priorityVisible {
            return 2
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else if indexPath.section == 2 && indexPath.row == 1 {
            return 44
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        nameText.resignFirstResponder()

        if indexPath.section == 1 && indexPath.row == 1 {
            if !datePickerVisible {
                showDatePicker()
            } else {
                hideDatePicker()
            }
        } else if indexPath.section == 2 && indexPath.row == 0 {
            if !priorityVisible {
                showPriority()
            } else {
                hideSegmentedControl()
            }
        }
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else if indexPath.section == 2 && indexPath.row == 0 {
            return indexPath
        } else {
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2 {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        if indexPath.section == 2 && indexPath.row == 1 {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }

    // MARK: - Table view data source



    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameText.becomeFirstResponder()
    }

    func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dateLabel.text = formatter.string(from: dueDate)
    }

    func showDatePicker() {
        datePickerVisible = true
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        datePicker.setDate(dueDate, animated: false)
    }

    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            let indexPathDateRow = IndexPath(row: 1, section: 1)
            let indexPathDatePicker = IndexPath(row: 2, section: 1)
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPathDateRow], with: .none)
            tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
            tableView.endUpdates()
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
        hideSegmentedControl()
    }

    func updatePriorityLabel() {
        priorityLabel.text = priority
    }

    func showPriority() {
        priorityVisible = true
        let indexPathPriority = IndexPath(row: 1, section: 2)
        tableView.insertRows(at: [indexPathPriority], with: .fade)
        //segmentedControl.
    }

    func hideSegmentedControl() {
        if priorityVisible {
            priorityVisible = false
            let indexPathPriorityRow = IndexPath(row: 0, section: 2)
            let indexPathSegmentedControl = IndexPath(row: 1, section: 2)
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPathPriorityRow], with: .none)
            tableView.deleteRows(at: [indexPathSegmentedControl], with: .fade)
            tableView.endUpdates()
        }
    }
}
