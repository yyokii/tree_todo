//
//  TodoView.swift
//  ThreeToDo
//
//  Created by Yoki Higashihara on 2019/02/11.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit

class TodoView: UIView {
    
    @IBOutlet var baseView: UIView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    
    private var presenter: TodoPresenterInput!
    private var todo: TodoItemObj?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    private func loadNib() {
        let view = Bundle.main.loadNibNamed("TodoView", owner: self, options: nil)?.first as? UIView
        view?.frame = self.bounds
        view?.layer.cornerRadius = 30
        observeKeyboardEvent()
        self.addSubview(view!)
    }
    
    func inject(presenter: TodoPresenterInput) {
        self.presenter = presenter
    }
    
    func setUpView(order: Order, todo: TodoItemObj?) {
        titleTextField.delegate = self
        
        switch order {
        case .first:
            baseView.backgroundColor = UIColor(hex: "FFCC80")
            orderLabel.text = "1st"
        case .second:
            baseView.backgroundColor = UIColor(hex: "90CAF9")
            orderLabel.text = "2nd"
        case .third:
            baseView.backgroundColor = UIColor(hex: "A5D6A7")
            orderLabel.text = "3rd"
        }
        
        if let item = todo {
            titleTextField.text = item.title
        } else {
            titleTextField.text = ""
        }
    }
    
    func observeKeyboardEvent() {
        // キーボードイベントの監視
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeShown(notification:)),
                                               name: NSNotification.Name.MDCKeyboardWatcherKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden(notification:)),
                                               name: NSNotification.Name.MDCKeyboardWatcherKeyboardWillHide,
                                               object: nil)
    }
    
    @IBAction func close(_ sender: Any) {
        presenter.didTapClose()
    }
    @IBAction func ok(_ sender: Any) {
        guard let title = titleTextField.text else {
            return
        }
        presenter.didTapOk(title: title, memo: "")
    }
    @IBAction func tapContentView(_ sender: Any) {
        self.baseView.endEditing(true)
    }
    @IBAction func tapBaseView(_ sender: Any) {
        self.baseView.endEditing(true)
    }
}

extension TodoView: UITextFieldDelegate {
    // キーボードが表示された時に呼ばれる, テキスト入力時にも反応する
    @objc func keyboardWillBeShown(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {

                // TODO: 重なった時にだけずらすようにしたい
                if self.baseView.frame.origin.y == 0 {
                   self.baseView.frame.origin.y -= keyboardFrame.height/3
                }
            }
        }
    }
    
    // キーボードが閉じられた時に呼ばれる
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        restoreScrollViewSize()
    }
    
    // リターンが押された時
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    
    func restoreScrollViewSize() {
        if self.baseView.frame.origin.y != 0 {
            self.baseView.frame.origin.y = 0
        }
    }
}
