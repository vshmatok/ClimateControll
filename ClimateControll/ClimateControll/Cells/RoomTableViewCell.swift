//
//  RoomTableViewCell.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 11.04.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import UIKit

class RoomTableViewCell: UITableViewCell {
    //MARK: - Properties
    @IBOutlet weak var roomName: UILabel!
    
    //MARK: - Configuration
    func configure(with room: Room) {
        roomName.text = room.roomName
    }
}
