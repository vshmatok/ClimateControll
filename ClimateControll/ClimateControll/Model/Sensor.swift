//
//  Sensor.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 03.04.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import Foundation

class Sensor {
    
    //MARK: - Properties
    var name: String?
    var state: String?
    var type: String?
    var room: String?
    var dictionary:[String:String] {
        return  ["state":state!]
    }
    
    //MARK: - Lifecycle
    init() {}
    
    init(name:String, state:String, type:String, room: String) {
        self.name = name
        self.state = state
        self.type = type
        self.room = room
    }
}
