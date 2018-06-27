//
//  DataModel.swift
//  ToDoList
//
//  Created by Станислав Тищенко on 27.06.2018.
//  Copyright © 2018 Станислав Тищенко. All rights reserved.
//

import Foundation
import UIKit

class DataModel {
    var tasks = [Task]()
    init() {
        loadTasks()
    }

    func documentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func dataFilePath() -> URL {
        return documentDirectory().appendingPathComponent("Tasks.plist")
    }

    func saveTasks() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(tasks)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding")
        }
    }

    func loadTasks() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                tasks = try decoder.decode([Task].self, from: data)
                sortTasks()
            } catch {
                print("Error decoding")
            }
        }
    }

    func sortTasks() {
        tasks.sort(by: { task1, task2 in
            return task1.name.localizedStandardCompare(task2.name) == .orderedAscending })
    }

    class func nextTask() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "TaskID")
        userDefaults.set(itemID+1, forKey: "TaskID")
        userDefaults.synchronize()
        return itemID
    }
}
