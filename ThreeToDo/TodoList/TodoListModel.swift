//
//  TodoListModel.swift
//  ThreeToDo
//
//  Created by Yoki Higashihara on 2019/02/10.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import RealmSwift

enum UserStatus {
    // todo未設定（3つ設定していない）
    case notSetTodo
    // todo設定済み（3つ設定している、スタートしていない）
    case setTodo
    // todo実行中（3つ設定している、スタートしている）
    case inPrograss
}

protocol TodoListModelInput {
    // TODO: ステータスで必要なtodo一覧をわたす方が綺麗かもね
    func fetchUserStatus() -> (status: UserStatus, todo: TodoItemObj?)
    func fetchFirstTodo() -> TodoItemObj?
    func fetchSecondTodo() -> TodoItemObj?
    func fetchThirdTodo() -> TodoItemObj?
    func fetchNotFinishTodo() -> TodoItemObj?
    // func fetchNotInProgressNotFinisTodo() -> TodoItemObj?
    func setTodoStatus(isInProgress: Bool, todo: TodoItemObj)
}

final class TodoListModel: TodoListModelInput {
    func fetchUserStatus() -> (status: UserStatus, todo: TodoItemObj?) {
        let results = RealmManager.sharedInstance.readTodos()
        if let todos = results, todos.count >= 3 {
            let inProgressTodos = todos.filter { $0.isInProgress == true }
            if inProgressTodos.count > 0 {
                return (UserStatus.inPrograss, inProgressTodos.first)
            } else {
                return (UserStatus.setTodo, nil)
            }
        } else {
            return (UserStatus.notSetTodo, nil)
        }
    }
    
    func fetchFirstTodo() -> TodoItemObj? {
        return RealmManager.sharedInstance.readFirstTodo()
    }
    
    func fetchSecondTodo() -> TodoItemObj? {
        return RealmManager.sharedInstance.readSecondTodo()
    }
    
    func fetchThirdTodo() -> TodoItemObj? {
        return RealmManager.sharedInstance.readThirdTodo()
    }
    
    func fetchNotFinishTodo() -> TodoItemObj? {
        return RealmManager.sharedInstance.readNotFinishTodo()
    }
    
    func setTodoStatus(isInProgress: Bool, todo: TodoItemObj) {
        RealmManager.sharedInstance.updateTodoState(isInProgress: isInProgress, todo: todo)
    }
}
