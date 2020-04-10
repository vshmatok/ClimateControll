//
//  SecurityCollectionViewCell.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 16.04.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import UIKit

class SecurityCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    @IBOutlet weak var securityDeviceImage: UIImageView!
    @IBOutlet weak var securityDeviceName: UILabel!
    
    //MARK: - Configuration
    func configure(with model:Sensor) {
        securityDeviceName.text = model.name!
        
        switch model.type! {
        case "Gas":
            securityDeviceImage.image = #imageLiteral(resourceName: "gas")
        case "Fire":
            securityDeviceImage.image = #imageLiteral(resourceName: "fire")
        default:
            securityDeviceImage.image = #imageLiteral(resourceName: "movement")
        }
        
        switch model.state! {
        case "off":
            backgroundColor = .white
        default:
            backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.4)
        }
    }
}
