//
//  UIViewController + NavigationBar.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 02.04.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    //MARK: - Remove navigation bar back button
    func removeBackButtonTitle() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
