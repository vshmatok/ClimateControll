//
//  User.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 11.03.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import UIKit

class User: Codable {
    
    //MARK: - Properties
    var id:String?
    var login:String
    var password:String
    var dictionary:[String:String] {
        return  ["login":login, "password":password]
    }

    //MARK: - Lifecycle
    init(login:String, password:String) {
        self.login = login
        self.password = password
    }
    
    init(json:[String:Any]){
        self.login = json["login"] as! String
        self.password = json["password"] as! String
    }
}
