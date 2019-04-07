//
//  UserDefaultManager.swift
//  ThreeToDo
//
//  Created by Yoki Higashihara on 2019/03/23.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation

struct UserDefaultsConstants {
    static let startUpCount = "startUpCount"
    static let isFirstLaunch = "isFirstLaunch"
}

class UserDefaultManager {
    static let shareInstance = UserDefaultManager()
    
    func fetchStartUpCount() -> Int{
        return UserDefaults.standard.integer(forKey: UserDefaultsConstants.startUpCount)
    }
    
    func addStartUpCount() {
        UserDefaults.standard.set(fetchStartUpCount() + 1, forKey: UserDefaultsConstants.startUpCount)
    }
    
    func fetchIsFirst() -> Bool{
        UserDefaults.standard.register(defaults: [UserDefaultsConstants.isFirstLaunch: true])
        return UserDefaults.standard.bool(forKey: UserDefaultsConstants.isFirstLaunch)
    }
    
    func setNotFirstLaunch() {
        UserDefaults.standard.set(false, forKey: UserDefaultsConstants.isFirstLaunch)
    }
}
