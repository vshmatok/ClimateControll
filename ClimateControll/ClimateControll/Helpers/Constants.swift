//
//  Constants.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 23.03.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import Foundation

class Constants {
    
    //MARK: - Delegates
    static weak var delegate: UpdateDelegate? = nil
    
    //MARK: - Properties
    static var id: String = ""
    static var currentRoom: String = ""
    static var troubleSensors = [Sensor](){
        didSet{
            delegate?.updateAll()
        }
    }
}
