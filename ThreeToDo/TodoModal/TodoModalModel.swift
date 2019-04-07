//
//  TodoModalModel.swift
//  ThreeToDo
//
//  Created by Yoki Higashihara on 2019/02/14.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

protocol TodoModalModelInput {
    func finishTodo(todo: TodoItemObj)
    func fetchNotFinishTodo() -> TodoItemObj?
    func setTodoStatus(isInProgress: Bool, todo: TodoItemObj)
    func clearTodo()
}

final class TodoModalModel: TodoModalModelInput {
    func finishTodo(todo: TodoItemObj) {
        RealmManager.sharedInstance.finishTodo(todo: todo)
    }
    
    func fetchNotFinishTodo() -> TodoItemObj? {
        return RealmManager.sharedInstance.readNotFinishTodo()
    }
    
    func setTodoStatus(isInProgress: Bool, todo: TodoItemObj) {
        RealmManager.sharedInstance.updateTodoState(isInProgress: isInProgress, todo: todo)
    }
    
    func clearTodo() {
        RealmManager.sharedInstance.deleteAll()
    }

}
