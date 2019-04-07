//
//  SplashVC.swift
//  ThreeToDo
//
//  Created by Yoki Higashihara on 2019/03/31.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sleep(3)
        if UserDefaultManager.shareInstance.fetchIsFirst() {
            let howToVC = UIStoryboard(name: "HowTo", bundle: nil).instantiateInitialViewController() as! HowToViewController
            present(howToVC, animated: true, completion: nil)
        } else {
            
        }
    }
}
