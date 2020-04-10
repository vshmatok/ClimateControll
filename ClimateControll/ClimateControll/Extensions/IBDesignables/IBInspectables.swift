//
//  IBInspectables.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 10.04.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        } set {
            layer.cornerRadius = newValue
        }
    }
}
