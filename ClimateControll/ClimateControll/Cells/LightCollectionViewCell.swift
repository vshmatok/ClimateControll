//
//  LightCollectionViewCell.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 17.04.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import UIKit

class LightCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    @IBOutlet weak var lightImage: UIImageView!
    @IBOutlet weak var lightName: UILabel!
    
    //MARK: - Configure
    func configure(with light:Light) {
        lightName.text = light.name
        lightImage.image = #imageLiteral(resourceName: "light")
        
        switch light.state! {
        case "on":
            backgroundColor = .yellow
        default:
            backgroundColor = .white
        }
    }
}
