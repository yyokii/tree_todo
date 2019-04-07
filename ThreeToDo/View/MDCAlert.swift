//
//  MDCAlert.swift
//  ThreeToDo
//
//  Created by Yoki Higashihara on 2019/02/19.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import MaterialComponents

final class MDCAlert {
    
    /// アラートを表示（「ok」ボタン）
    ///
    /// - Parameters:
    ///   - vc: 表示するvc
    ///   - title: タイトル
    ///   - message: メッセージ
    static func showAlert(vc: UIViewController, title: String, message: String, isEnableOutsideScreenTouch: Bool, positiveAction: @escaping () -> Void) {
        let alertController = MDCAlertController(title: title, message: message)
        let action = MDCAlertAction(title:"OK 🎉") { _ in
            positiveAction()
        }
        alertController.addAction(action)
        alertController.view.subviews[0].isUserInteractionEnabled = false
        vc.present(alertController, animated: true, completion: nil)
    }
    
    /// アラートを表示（「ok」,「no」ボタン）
    ///
    /// - Parameters:
    ///   - vc: 表示するvc
    ///   - title: タイトル
    ///   - message: メッセージ
    static func showTwoBtnAlert(vc: UIViewController, title: String, message: String, positiveAction: @escaping () -> Void, negativeAction: @escaping () -> Void) {
        let alertController = MDCAlertController(title: title, message: message)
        let posiAction = MDCAlertAction(title:"OK ✅") { _ in
            positiveAction()
        }
        let negaAction = MDCAlertAction(title:"NO ❎") { _ in
            negativeAction()
        }
        
        alertController.addAction(posiAction)
        alertController.addAction(negaAction)
        vc.present(alertController, animated: true, completion: {
            alertController.view.subviews[0].isUserInteractionEnabled = false
        })
    }
    
}
