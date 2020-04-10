//
//  TroublesTableViewCell.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 11.04.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import UIKit

class TroublesTableViewCell: UITableViewCell {

    //MARK: - Properties
    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var sensorName: UILabel!
    
    //MARK: - Configurations
    func configure(with model: Sensor) {
        self.roomName.text = model.room
        self.sensorName.text = model.name
    }
}
