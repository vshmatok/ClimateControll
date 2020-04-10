//
//  UIViewController + Alert.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 20.03.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    //MARK: - Create simple Alert
    func createAlert(title: String, message: String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Create alert with completion
    func createAlert(title: String, message: String, competion:((UIAlertAction) -> Void)?){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: competion))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Create delete alert
    func createDeleteAlert(title: String, message: String, completion:((UIAlertAction) -> Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: completion))
            self.present(alert, animated: true, completion: nil)
        }
    }

    //MARK: - Create choose aletrt
    func createChooseAlert(title: String, message: String, togleCompletion:((UIAlertAction) -> Void)?, deleteCompletion:((UIAlertAction) -> Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: deleteCompletion))
            alert.addAction(UIAlertAction(title: "Togle", style: .default, handler: togleCompletion))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Create alert with textField and completion
    func createAlertWithField(title: String, message: String, competion: @escaping (String) -> Void) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message:message, preferredStyle: .alert)
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter name"
            }
            let saveAction = UIAlertAction(title: "OK", style: .default, handler: { alert -> Void in
                guard let roomTextField = alertController.textFields![0].text, roomTextField != "" else {
                    self.createAlert(title: "Error", message: "Enter all fields")
                    return
                }
                competion(roomTextField)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
