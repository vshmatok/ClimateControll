//
//  Light.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 02.04.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import Foundation

class Light {
    
    //MARK: - Properties
    var name: String?
    var state: String?
    var dictionary:[String:String] {
        return  ["state":state!]
    }
    
    //MARK: - Lifecycle
    init() {}
    
    init(name:String, state:String) {
        self.name = name
        self.state = state
    }
}
