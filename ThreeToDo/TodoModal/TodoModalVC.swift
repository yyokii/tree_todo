//
//  TodoModalVC.swift
//  ThreeToDo
//
//  Created by Yoki Higashihara on 2019/02/14.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import MaterialComponents

class TodoModalVC: UIViewController {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var blobTopImageView: UIImageView!
    @IBOutlet weak var blobBottomImageView: UIImageView!
    @IBOutlet weak var finishButton: MDCFloatingButton!
    
    private var presenter: TodoModalPresenterInput!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.inProgressTodo()
        // todoみてアニメーション変更
    }
    
    override func viewDidLayoutSubviews() {
        blobTopImageView.hero.modifiers = [.delay(TimeInterval.init(exactly: 0.3)!), .translate(x: -view.frame.width), .scale(0.1)]
        blobBottomImageView.hero.modifiers = [.delay(TimeInterval.init(exactly: 0.5)!), .translate(y: view.frame.height), .scale(0.1)]
        titleLbl.hero.modifiers = [.delay(TimeInterval.init(exactly: 0.7)!), .fade]
    }
    
    func inject(presenter: TodoModalPresenterInput) {
        self.presenter = presenter
    }
    
    @IBAction func finish(_ sender: Any) {
        presenter.didTapFinish()
    }
    
    @IBAction func clear(_ sender: Any) {
        presenter.didTapClear()
    }
}

extension TodoModalVC: TodoModalPresenterOutput {
    func presentNextTodo(todo: TodoItemObj) {
        // 次のTodoを表示
        let todoModalVC = UIStoryboard(name: "TodoModal", bundle: nil).instantiateViewController(withIdentifier: "TodoModalVC") as! TodoModalVC
        let model = TodoModalModel()
        let presenter = TodoModalPresenter(todo: todo, view: todoModalVC, model: model)
        todoModalVC.inject(presenter: presenter)
        
        navigationController?.hero.isEnabled = true
        navigationController?.pushViewController(todoModalVC, animated: true)
    }
    
    func showAlert(title: String, message: String, isEnableOutsideScreenTouch: Bool, action: @escaping () -> Void) {
        MDCAlert.showAlert(vc: self, title: title, message: message, isEnableOutsideScreenTouch: isEnableOutsideScreenTouch, positiveAction: action)
    }
    
    func showTwoBtnAlert(title: String, message: String, positiceAction: @escaping () -> Void, negativeAction: @escaping () -> Void) {
        MDCAlert.showTwoBtnAlert(vc: self, title: title, message: message, positiveAction: positiceAction, negativeAction: negativeAction)
    }
    
    func setUpView(todo: TodoItemObj) {
        guard let order = todo.orderType else {
            return
        }

        switch order {
        case .first:
            blobTopImageView.image = UIImage(named: "blob_top_orange")
            blobBottomImageView.image = UIImage(named: "blob_bottom_light_blue")
        case .second:
            blobTopImageView.image = UIImage(named: "blob_top_pink")
            blobBottomImageView.image = UIImage(named: "blob_bottom_green")
        case .third:
            blobTopImageView.image = UIImage(named: "blob_top_yellow")
            blobBottomImageView.image = UIImage(named: "blob_bottom_purple")
        }
        
        self.titleLbl.text = todo.title
    }
    
    func close() {
        navigationController?.hero.isEnabled = false
        dismiss(animated: true, completion: nil)
    }
}
