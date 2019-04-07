//
//  TodoModalPresenter.swift
//  ThreeToDo
//
//  Created by Yoki Higashihara on 2019/02/14.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation

protocol TodoModalPresenterInput {
    func inProgressTodo()
    func didTapFinish()
    func didTapClear()
}

protocol TodoModalPresenterOutput: AnyObject {
    func setUpView(todo: TodoItemObj)
    // TODO: ここのescaping要検討、大丈夫な気がする、これがあるからviewはweakかも
    func showAlert(title: String, message: String, isEnableOutsideScreenTouch: Bool, action: @escaping () -> Void)
    func showTwoBtnAlert(title: String, message: String, positiceAction: @escaping () -> Void, negativeAction: @escaping () -> Void)
    func presentNextTodo(todo: TodoItemObj)
    func close()
}

final class TodoModalPresenter: TodoModalPresenterInput {
    private weak var view: TodoModalPresenterOutput!
    private var model: TodoModalModelInput
    let center = NotificationCenter.default

    var todo: TodoItemObj
    
    init(todo: TodoItemObj, view: TodoModalPresenterOutput, model: TodoModalModelInput) {
        self.todo = todo
        self.view = view
        self.model = model
    }
    
    // TODO: これviewDidLoadとかでいいかもね
    func inProgressTodo() {
        view.setUpView(todo: todo)
    }
    
    func didTapFinish() {
        model.finishTodo(todo: todo)
        // 終わってないTodoを取得
        if let nextTodo = model.fetchNotFinishTodo() {
            // 次のTodoを表示
            view.showAlert(title: "このTODOを完了にしますか?", message: "「OK」を押すとこのTodoを完了にします", isEnableOutsideScreenTouch: true, action: { [weak self] in
                self?.todo = nextTodo
                self?.model.setTodoStatus(isInProgress: true, todo: nextTodo)
                self?.view.presentNextTodo(todo: nextTodo)
            })
        } else {
            // 最後のTodo
            view.showAlert(title: "素晴らしい！最後のTODOです😆", message: "このTodoを完了にしますか？🎉", isEnableOutsideScreenTouch: false, action: {
                self.model.clearTodo()
                self.view.close()
                self.center.post(name: .finishedThreeTodos,object: nil)
            })
        }
    }
    
    func didTapClear() {
        view.showTwoBtnAlert(title: "おっと😌", message: "Todoを取り消しますか？（Todoの設定から再度開始します😉）", positiceAction: {
            self.model.clearTodo()
            self.view.close()
        }, negativeAction: {})
    }
}
