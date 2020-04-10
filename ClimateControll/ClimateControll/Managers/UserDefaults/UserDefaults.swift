//
//  UserDefaults.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 21.03.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import Foundation
import UIKit

class UserDefaultsManager {
    
    //MARK: - Properties
    static let shared = UserDefaultsManager()
    var isLogined:Bool {
        return checkForAuth()
    }
    
    //MARK: - Lifecycle
    private init() {}
    
    //MARK: - Internal
    //MARK: - Save user autorization
    func saveAuth(id:String) {
        UserDefaults.standard.set(true, forKey: "Logined")
        UserDefaults.standard.set(id, forKey: "UserId")
    }
    
    //MARK: - Remove user autorization
    func logout() {
        UserDefaults.standard.set(false, forKey: "Logined")
        UserDefaults.standard.set("", forKey: "UserId")
    }
    
    //MARK: - Get user ID
    func receiveId() -> String{
        return UserDefaults.standard.value(forKey: "UserId") as! String
    }
    
    //MARK: - Private
    private func checkForAuth() -> Bool {
        guard let auth = UserDefaults.standard.value(forKey: "Logined") as? Bool else { return false }
        if auth {
            return true
        } else {
            return false
        }
    }
}
