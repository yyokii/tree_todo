//
//  RealmManager.swift
//  ThreeToDo
//
//  Created by Yoki Higashihara on 2019/02/10.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import RealmSwift

class RealmManager {
    static let sharedInstance = RealmManager()
    private var database: Realm?
    
    private init() {
        database = try? Realm()
        print("--------------")
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        print("--------------")
    }
    
    /// Todoデータ書き込み
    ///
    /// - Parameter object: 追加するtodo
    func writeTodo(object: TodoItemObj) {
        try? database?.write {
            database?.add(object)
        }
    }
    
    /// Todoデータ編集
    ///
    /// - Parameters:
    ///   - title: タイトル
    ///   - memo: メモ
    ///   - todo: 編集対象のTodo
    func editTodo(title: String, memo: String, todo: TodoItemObj) {
        try? database?.write {
            todo.title = title
            todo.memo = memo
        }
    }
    
    /// TodoのinProgress状態を更新する
    ///
    /// - Parameters:
    ///   - inProgress: true:対応中 false:まだ or 終わっている
    ///   - todo: 編集対象のTodo
    func updateTodoState(isInProgress: Bool, todo: TodoItemObj) {
        try? database?.write {
            todo.isInProgress = isInProgress
        }
    }
    
    /// Todoを達成状態にする
    ///
    /// - Parameter todo: 達成したTodo
    func finishTodo(todo: TodoItemObj) {
        try? database?.write {
            todo.isInProgress = false
            todo.isFinished = true
        }
    }
    
    /// Realmデータを全て削除
    func deleteAll() {
        try? database?.write {
            database?.deleteAll()
        }
    }
    
    /// Todoを全て取得
    ///
    /// - Returns: 全てのTodo
    func readTodos() -> Results<TodoItemObj>? {
        let results = database!.objects(TodoItemObj.self)
        return results
    }
    
    func readFirstTodo() -> TodoItemObj? {
        let results = database!.objects(TodoItemObj.self).filter("order == '1st'")
        return results.count > 0 ? results.first : nil
    }
    
    func readSecondTodo() -> TodoItemObj? {
        let results = database!.objects(TodoItemObj.self).filter("order == '2nd'")
        return results.count > 0 ? results.first : nil
    }
    
    func readThirdTodo() -> TodoItemObj? {
        let results = database!.objects(TodoItemObj.self).filter("order == '3rd'")
        return results.count > 0 ? results.first : nil
    }
    
    func deleteTodo(object: TodoItemObj) {
        try? database?.write {
            database?.delete(object)
        }
    }
    
    /// 未終了のTodoを取得
    ///
    /// - Returns: 未終了のTodo
    func readNotFinishTodo() -> TodoItemObj? {
        let results = database!.objects(TodoItemObj.self).filter("isFinished == false")
        return results.count > 0 ? results.sorted(byKeyPath: "order", ascending: true).first : nil
    }
    
//    /// 未終了かつ未実行のTodoを取得
//    ///
//    /// - Returns: 未終了のTodo
//    func readNotInProgressNotFinisTodo() -> TodoItemObj? {
//        let results = database!.objects(TodoItemObj.self).filter("isFinished == false && isInProgress == false")
//        return results.count > 0 ? results.first : nil
//    }
}
