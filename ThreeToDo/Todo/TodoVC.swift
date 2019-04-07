//
//  TodoVC.swift
//  ThreeToDo
//
//  Created by Yoki Higashihara on 2019/02/11.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit

// 1Viewに対して1Presenterが原則？ならこれは微妙。1対2
class TodoVC: UIViewController {
    let contentView = TodoView()
    private var presenter: TodoPresenterInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        presenter.viewDidLoad()
    }
    
    func inject(presenter: TodoPresenterInput) {
        self.presenter = presenter
        contentView.inject(presenter: presenter)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.frame = CGRect(x: (view.bounds.width - view.bounds.width * 0.9) / 2, y: 50, width: view.bounds.width * 0.9, height: view.bounds.height * 0.8)
    }
    
    func back() {
        dismiss(animated: true, completion: nil)
    }
}

extension TodoVC: TodoPresenterOutput {
    func setUpView(order: Order, todo: TodoItemObj?) {
        contentView.setUpView(order: order, todo: todo)
    }
    
    func close() {
        back()
    }
}
