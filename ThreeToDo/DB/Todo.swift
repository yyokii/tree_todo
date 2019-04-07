//
//  Todo.swift
//  ThreeToDo
//
//  Created by Yoki Higashihara on 2019/02/10.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import RealmSwift

enum Order: String {
    case first = "1st"
    case second = "2nd"
    case third = "3rd"
}


class TodoItemObj: Object {
    @objc dynamic var order = ""
    @objc dynamic var title = ""
    @objc dynamic var memo = ""
    @objc dynamic var isInProgress = false
    @objc dynamic var isFinished = false
    
    // https://qiita.com/nohirap/items/3b5e30b505d8808f6ce7
    var orderType: Order? {
        get {
            return Order(rawValue: order)
        }
        set {
            order = newValue?.rawValue ?? ""
        }
    }
}
