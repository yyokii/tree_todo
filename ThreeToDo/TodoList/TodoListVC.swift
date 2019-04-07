//
//  TodoListVC.swift
//  ThreeToDo
//
//  Created by Yoki Higashihara on 2019/02/10.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import AMPopTip
import MaterialComponents
import Hero

class TodoListVC: UIViewController {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var firstShadowView: ShadowView!
    @IBOutlet weak var firstTodoView: TodoItemView!
    
    @IBOutlet weak var secondShadowView: ShadowView!
    @IBOutlet weak var secondTodoView: TodoItemView!
    
    @IBOutlet weak var thirdShadowView: ShadowView!
    @IBOutlet weak var thirdTodoView: TodoItemView!
    
    @IBOutlet weak var startBtn: MDCRaisedButton!
    
    private var presenter: TodoListPresenterInput!
    
    var logoImageView: UIImageView!
    
    // poptip
    private var titlePopTip: PopTip?
    private var todoPopTip: PopTip?
    
    // （todoの設定が完了し）スタートボタンが表示されたかどうか
    var isShownStarButton = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLogoImageView()
        
        startBtn.isHidden = true
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logoAnimate()
        
        print(UserDefaultManager.shareInstance.fetchStartUpCount())
        if UserDefaultManager.shareInstance.fetchStartUpCount() <= 1 {
            // 初回起動の時
            showPopTip()
        }
    }
    
    func inject(presenter: TodoListPresenterInput) {
        self.presenter = presenter
    }
    
    private func setUpLogoImageView() {
        print(UserDefaultManager.shareInstance.fetchStartUpCount())
        // FIXME:ここおかしい、didloadだとcountがまだ更新されてない、要検討 初回以外のみとロゴのアニメーションをさせる
        guard UserDefaultManager.shareInstance.fetchStartUpCount() > 1 else { return }
        
        logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        logoImageView.center = view.center
        logoImageView.image = UIImage(named: "splash_logo")
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)
    }

    // これ、presenterにモデル取得依頼して、outputで描画までつなげる方がきれいかも？
    func setUpView() {
        firstShadowView.setElevation()
        firstTodoView.configure(order: .first, todo: presenter.firstTodo())
        firstTodoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(todoTapped(_:))))
        
        secondShadowView.setElevation()
        secondTodoView.configure(order: .second, todo: presenter.secondTodo())
        secondTodoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(todoTapped(_:))))
        
        thirdShadowView.setElevation()
        thirdTodoView.configure(order: .third, todo: presenter.thirdTodo())
        thirdTodoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(todoTapped(_:))))
    }
    
    @objc func todoTapped(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else {
            return
        }
        view.hero.id = "\(view.tag)"
        presenter.didTapTodo(heroId: view.tag)
    }
    
    @IBAction func startBtnTapped(_ sender: Any) {
        presenter.didTapStart()
    }    
    @IBAction func tapInfoButton(_ sender: Any) {
        guard let sender = sender as? UIButton else { return }
        let aboutAppVC = UIStoryboard(
            name: "AboutApp",
            bundle: nil)
            .instantiateInitialViewController() as! AboutAppVC
        sender.hero.id = "AboutApp"
        aboutAppVC.view.hero.modifiers = [.source(heroID: "AboutApp")]
        aboutAppVC.closeButton.hero.id = "AboutApp"
        aboutAppVC.view.hero.id = "AboutApp"

        present(aboutAppVC, animated: true, completion: nil)
    }
    
    private func logoAnimate() {
        guard let logo = logoImageView else { return }
        //少し縮小するアニメーション
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            logo.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: nil)
        //拡大させて、消えるアニメーション
        UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveEaseOut, animations: {
            logo.transform = CGAffineTransform(scaleX: 2, y: 2)
            logo.alpha = 0
        }) {[weak self] isCompleted in
            logo.removeFromSuperview()
            self?.presenter.viewDidAppear()
        }
    }
    
    func setHeroIdWithCase(order: Order) {
        switch order {
        case .first:
            firstTodoView.orderLabel.hero.id = "order"
            secondTodoView.orderLabel.hero.id = nil
            thirdTodoView.orderLabel.hero.id = nil
        case .second:
            firstTodoView.orderLabel.hero.id = nil
            secondTodoView.orderLabel.hero.id = "order"
            thirdTodoView.orderLabel.hero.id = nil
        case .third:
            firstTodoView.orderLabel.hero.id = nil
            secondTodoView.orderLabel.hero.id = nil
            thirdTodoView.orderLabel.hero.id = "order"
        }
    }
}

extension TodoListVC: TodoListPresenterOutput {
    func showHowTo() {
        let howToVC = UIStoryboard(name: "HowTo", bundle: nil).instantiateInitialViewController() as! HowToViewController
        howToVC.hero.isEnabled = true
        howToVC.view.hero.modifiers = [.delay(0.5) , .fade]
        present(howToVC, animated: true, completion: nil)
    }
    
    func showPopTip() {
        if titlePopTip == nil {
            let titlePopTip = PopTipView.standardPoptip(offset: 10)
            titlePopTip.show(text: "ステータスがここに表示されます👀", direction: .down, maxWidth: 300, in: view, from: titleLbl.frame)
        }
        if todoPopTip == nil {
            let todoPopTip = PopTipView.standardPoptip(offset: firstTodoView.frame.height * 0.6)
            todoPopTip.show(text: "タップ🖐するとTodoを設定できます", direction: .down, maxWidth: 200, in: view, from: firstTodoView.frame)
        }
    }
    
    func showAlert(title: String, message: String, action: @escaping () -> Void) {
        MDCAlert.showAlert(vc: self, title: title, message: message, isEnableOutsideScreenTouch: true, positiveAction: action)
    }
    
    func titleLbl(text: String) {
        titleLbl.text = text
    }
    
    func showStartBtn() {
        guard !isShownStarButton else { return }
        startBtn.isHidden = false
        
        startBtn.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 5, options: .allowUserInteraction, animations: {
            self.startBtn.transform = .identity
        }, completion: nil)
        isShownStarButton = true
    }
    
    func hideStartBtn() {
        startBtn.isHidden = true
        isShownStarButton = false
    }
    
    func showTodoModal(todo: TodoItemObj) {
        
        let nav = UIStoryboard(name: "TodoModal", bundle: nil).instantiateInitialViewController() as! UINavigationController
        
        let todoModalVC = nav.viewControllers.first as! TodoModalVC
        let model = TodoModalModel()
        let presenter = TodoModalPresenter(todo: todo, view: todoModalVC, model: model)
        todoModalVC.inject(presenter: presenter)
      
        // （メモ）画面遷移参考
//        todoModalVC.hero.modalAnimationType = .selectBy(presenting: .cover(direction: .left), dismissing: .pageOut(direction: .down))
        
//        todoModalVC.hero.modalAnimationType = .selectBy(presenting: .cover(direction: .up), dismissing: .pageOut(direction: .down))
        
        // 画面遷移アニメーション
        nav.hero.isEnabled = false
        present(nav, animated: true, completion: nil)
    }
    
    // heroIdはorderに依存すると捉えて、heroIDをorderに変えた方がいいかも？、いや、結局orderとidに変えないといけないのか
    func transitionToTodo(heroId: Int, todo: TodoItemObj?) {
        let todoVC = UIStoryboard(
            name: "Todo",
            bundle: nil)
            .instantiateInitialViewController() as! TodoVC
        let model = TodoModel()
        let order: Order?
        switch heroId {
        case 1:
            order = Order.first
        case 2:
            order = Order.second
        case 3:
            order = Order.third
        default:
            order = nil
        }
        guard let orderValue = order else { return }

        let presenter = TodoPresenter(
            order: orderValue,
            todo: todo,
            view: todoVC,
            model: model)
        todoVC.inject(presenter: presenter)
        //（メモ） id、アイテム、が動的に変わる
        // 全体的なアニメーション
        todoVC.hero.isEnabled = true
        todoVC.contentView.hero.id = "\(heroId)"
        todoVC.contentView.titleTextField.hero.id = "\(heroId)"
        // ラベルアニメーション
        setHeroIdWithCase(order: orderValue)
        todoVC.contentView.orderLabel.hero.id = "order"
        
        present(todoVC, animated: true, completion: nil)
    }
}
