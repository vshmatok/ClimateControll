//
//  WindowCollectionViewCell.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 17.04.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import UIKit

class WindowCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    @IBOutlet weak var windowImage: UIImageView!
    @IBOutlet weak var windowName: UILabel!
    
    //MARK: - Configure
    func configure(with window:Window) {
        windowName.text = window.name
        windowImage.image = #imageLiteral(resourceName: "window")
        
        switch window.state! {
        case "open":
            backgroundColor = .blue
        default:
            backgroundColor = .white
        }
    }
}
