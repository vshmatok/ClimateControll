//
//  Room.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 30.03.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import Foundation

class Room {
    
    //MARK: - Properties
    var roomName:String?
    
    //MARK: - Lifecycle
    init() {}
    
    init(roomName: String) {
        self.roomName = roomName
    }
}
