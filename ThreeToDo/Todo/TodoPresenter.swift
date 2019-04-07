//
//  TodoPresenter.swift
//  ThreeToDo
//
//  Created by Yoki Higashihara on 2019/02/11.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation

protocol TodoPresenterInput {
    func viewDidLoad()
    func todo() -> TodoItemObj?
    func didTapClose()
    func didTapOk(title: String, memo: String)
}

protocol TodoPresenterOutput: AnyObject {
    func setUpView(order: Order, todo: TodoItemObj?)
    func close()
}

final class TodoPresenter: TodoPresenterInput {
    let order: Order?
    let displayTodo: TodoItemObj?
    
    func viewDidLoad() {
        guard let order = self.order else {
            return
        }
        view.setUpView(order: order, todo: displayTodo)
    }
    
    func todo() -> TodoItemObj? {
        return displayTodo
    }
    
    func didTapClose() {
        view.close()
    }
    
    func didTapOk(title: String, memo: String) {
        if let todo = displayTodo {
            // 更新
            model.editTodo(title: title.isEmpty ? "no title" : title, memo: memo, todo: todo)
        } else {
            guard let order = self.order else{
                return
            }
            // 新規作成
            model.createTodo(order: order, title: title.isEmpty ? "no title" : title, memo: memo)
        }
        view.close()
    }
    
    private weak var view: TodoPresenterOutput!
    private var model: TodoModelInput
    
    init(order: Order?, todo: TodoItemObj?, view: TodoPresenterOutput, model: TodoModelInput) {
        self.order = order
        self.displayTodo = todo
        self.view = view
        self.model = model
    }
}
