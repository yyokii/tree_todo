//
//  TodoListPresenter.swift
//  ThreeToDo
//
//  Created by Yoki Higashihara on 2019/02/10.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import RealmSwift

protocol TodoListPresenterInput {
    func viewDidLoad()
    func viewDidAppear()
    func firstTodo() -> TodoItemObj?
    func secondTodo() -> TodoItemObj?
    func thirdTodo() -> TodoItemObj?
    func didTapStart()
    // TODO: ここでidもらうのはいいが、outputの時はモデル的なもの渡す方がpresenterぽいよね
    func didTapTodo(heroId: Int)
}

protocol TodoListPresenterOutput: AnyObject {
    func showAlert(title: String, message: String, action: @escaping () -> Void)
    func showHowTo()
    func showPopTip()
    func showStartBtn()
    func hideStartBtn()
    func showTodoModal(todo: TodoItemObj)
    func titleLbl(text: String)
    func transitionToTodo(heroId: Int, todo: TodoItemObj?)
}

final class TodoListPresenter: TodoListPresenterInput {
    private weak var view: TodoListPresenterOutput!
    private var model: TodoListModelInput
    let center = NotificationCenter.default

    // モデルから取得した各Todoを保持
    private(set) var first: TodoItemObj?
    private(set) var second: TodoItemObj?
    private(set) var third: TodoItemObj?
    
    init(view: TodoListPresenterOutput, model: TodoListModelInput) {
        self.view = view
        self.model = model
    }
    
    func viewDidLoad() {
        addObserver()
    }
    
    func addObserver() {
        center.addObserver(self,
                           selector: #selector(type(of: self).finishedThreeTodos(notification:)),
                           name: .finishedThreeTodos,
                           object: nil)
    }
    
    @objc private func finishedThreeTodos(notification: Notification) {
        // 達成ダイアログ
        view.showAlert(title: "天才", message: "3つすべてのTODOを達成しました😆") {}
    }
    
    func viewDidAppear() {
        userStatus()
    }
    
    func userStatus() {
        let result = model.fetchUserStatus()
        switch result.status {
        case .notSetTodo:
            view.titleLbl(text: "Todoを3つ設定しましょう😆")
            view.hideStartBtn()
            return
        case .setTodo:
            view.titleLbl(text: "Todoをスタートしよう🏃‍♂️🏃‍♀️")
            self.view.showStartBtn()
            return
        case .inPrograss:
            view.titleLbl(text: "3 TODO")
            guard let todo = result.todo else {
                return
            }
            view.showTodoModal(todo: todo)
            view.hideStartBtn()
        }
    }
    
    // ここ、todo取得してoutputで描画処理呼び出す方が自然かもねと
    func firstTodo() -> TodoItemObj? {
        first = model.fetchFirstTodo()
        return first
    }
    
    func secondTodo() -> TodoItemObj? {
        second = model.fetchSecondTodo()
        return second
    }
    
    func thirdTodo() -> TodoItemObj? {
        third = model.fetchThirdTodo()
        return third
    }
    
    func didTapStart() {
        guard let displayTodo = model.fetchNotFinishTodo() else {
            return
        }
        model.setTodoStatus(isInProgress: true, todo: displayTodo)
        view.showTodoModal(todo: displayTodo)
    }
    
    /// Todoを選択した時の処理
    ///
    /// - Parameter heroId: TODO: これ、heroIdとして使う以外に選択したtodo判別にも使用しているので、命名変えた方がいいかも
    func didTapTodo(heroId: Int) {
        var selectedTodo: TodoItemObj?
        
        switch heroId {
        case 1:
            selectedTodo = first
        case 2:
            selectedTodo = second
        case 3:
            selectedTodo = third
        default:
            selectedTodo = nil
        }
        
        view.transitionToTodo(heroId: heroId, todo: selectedTodo)
    }
}
