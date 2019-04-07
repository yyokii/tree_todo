//
//  TodoModel.swift
//  ThreeToDo
//
//  Created by Yoki Higashihara on 2019/02/11.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation

protocol TodoModelInput {
    func createTodo(order: Order, title: String, memo: String)
    func editTodo(title: String, memo: String, todo: TodoItemObj)
    func validateTodo(title: String, memo: String) -> Bool
}

final class TodoModel: TodoModelInput {
    func createTodo(order: Order, title: String, memo: String) {
        let todo = TodoItemObj()
        todo.order = order.rawValue
        todo.title = title
        todo.memo = memo
        todo.isFinished = false
        RealmManager.sharedInstance.writeTodo(object: todo)
    }
    
    func editTodo(title: String, memo: String, todo: TodoItemObj) {
        //  realmのデータ修正
        RealmManager.sharedInstance.editTodo(title: title, memo: memo, todo: todo)
    }
    
    /// todo入力内容のバリデーション
    ///
    /// - Parameters:
    ///   - title: タイトル
    ///   - memo: メモ
    /// - Returns: バリデーションに通ったかどうか
    func validateTodo(title: String, memo: String) -> Bool {
        if ( title.count < 1 || title.count > 20) {
            return false
        }
        if ( memo.count < 1 || title.count > 100) {
            return false
        }
        
        return true
    }
}

