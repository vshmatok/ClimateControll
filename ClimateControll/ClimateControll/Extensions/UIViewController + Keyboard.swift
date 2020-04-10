//
//  UIViewController + Keyboard.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 20.03.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    //MARK - Register keyboard notifications
    func registerForKeyboardNotificationsUser() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.view.transform = CGAffineTransform.identity
        })
    }
    
    //MARK: - Hide keyboard
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
