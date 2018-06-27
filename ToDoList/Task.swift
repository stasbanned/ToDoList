//
//  Item.swift
//  ToDoList
//
//  Created by Станислав Тищенко on 27.06.2018.
//  Copyright © 2018 Станислав Тищенко. All rights reserved.
//

import Foundation
import UIKit

class Task: NSObject, Codable {
    var priority = ""
    var date = Date()
    var descript = ""
    var name = ""
    var checked = false
    var remind = false
    var itemID: Int

    func toggleChecked() {
        checked = !checked
    }

    override init() {
        itemID = DataModel.nextTask()
        super.init()
    }
}
