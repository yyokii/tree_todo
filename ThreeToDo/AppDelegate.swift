//
//  AppDelegate.swift
//  ThreeToDo
//
//  Created by Yoki Higashihara on 2019/01/28.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let startUpCount = UserDefaultManager.shareInstance.fetchStartUpCount()

        var firstVC: UIViewController?
        if startUpCount == 0 {
            let howToVC = UIStoryboard(name: "HowTo", bundle: nil).instantiateInitialViewController() as! HowToViewController
            firstVC = howToVC
        } else {
            let todoListVC = UIStoryboard(name: "TodoList", bundle: nil).instantiateInitialViewController() as! TodoListVC
            let model = TodoListModel()
            let presenter = TodoListPresenter(view: todoListVC, model: model)
            todoListVC.inject(presenter: presenter)
            
            firstVC = todoListVC
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = firstVC
        window?.makeKeyAndVisible()
        
        // レビュー依頼画面表示判定
        if startUpCount == 2 || startUpCount == 5 || startUpCount == 10 {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            }
        }
        UserDefaultManager.shareInstance.addStartUpCount()
        
        return true
    }
}

