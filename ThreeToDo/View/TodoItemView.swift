//
//  TodoView.swift
//  ThreeToDo
//
//  Created by Yoki Higashihara on 2019/02/10.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

// このクラスでMaterialComponentsの影をつけたいが、heroのアニメーションから戻ってきた際に影が消えるので、（影をつける際は）カスタムビューをもう一つ重ねています。

import UIKit

/// Todo一覧画面で表示するあTodoアイテム
class TodoItemView: UIView {
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    private func loadNib() {
        let view = Bundle.main.loadNibNamed("TodoItemView", owner: self, options: nil)?.first as? UIView
        view?.frame = self.bounds
        self.addSubview(view!)
    }
    
    // TODO: 命名の統一（configure or setUpView or 使い分け）
    func configure(order: Order, todo: TodoItemObj?) {
        
        switch order {
        case .first:
            tag = 1
            orderLabel.text = "1st"
            rightImageView.image = UIImage(named: "orange")
        case .second:
            tag = 2
            orderLabel.text = "2nd"
            rightImageView.image = UIImage(named: "blue")
        case .third:
            tag = 3
            orderLabel.text = "3nd"
            rightImageView.image = UIImage(named: "green")
        }
    
        // Todoの情報をViewに反映
        if let item = todo {
            // trim使用してより精緻にしてもよい
            if item.title == "" {
                titleLbl.text = "no title"
            } else {
                titleLbl.text = item.title
            }
        } else {
            switch order {
            case .first:
                titleLbl.text = "1つ目のTodoを設定しましょう😉"
            case .second:
                titleLbl.text = "2つ目のTodoを設定しましょう🏃‍♂️"
            case .third:
                titleLbl.text = "3つ目のTodoを設定しましょう✅"
            }
        }
    }
}
