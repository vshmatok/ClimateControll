//
//  NewSecurityDeviceViewController.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 16.04.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import UIKit

class NewSecurityDeviceViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet private weak var deviceType: UISegmentedControl!
    @IBOutlet private weak var securityDeviceName: UITextField!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    private var yCoorinateForMovingView:CGFloat!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        registerForKeyboardNotificationsUser()
    }
    
    //MARK: - IBActions
    @IBAction private func didTapCreateDevice(_ sender: UIButton) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        let sensor = Sensor()
        sensor.room = Constants.currentRoom
        sensor.type = getDeviceType()
        sensor.state = "off"
        guard securityDeviceName.text != "" else {
            createAlert(title: "Error", message: "Enter all fields")
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            return
        }
        sensor.name = securityDeviceName.text
        FirebaseManager.shared.checkSensor(sensor: sensor, id: Constants.id, roomName: Constants.currentRoom, completion: { isCreated in
            if isCreated {
                self.createAlert(title: "Error", message: "Device with such name already exists")
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            } else {
                FirebaseManager.shared.createSensor(sensor: sensor, roomName: Constants.currentRoom, id: Constants.id)
                self.dismiss(animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        })
        
    }
    
    @IBAction private func didTapCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Private
    private func getDeviceType() -> String{
        switch deviceType.selectedSegmentIndex {
        case 0: return "Gas"
        case 1: return "Fire"
        default: return "Movement"
        }
    }
    
}

//MARK: - Extensions
//MARK: - UITextFieldDelegate
extension NewSecurityDeviceViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case securityDeviceName:
            yCoorinateForMovingView = securityDeviceName.frame.origin.y
        default:
            break
        }
        UIView.animate(withDuration: 0.1 , animations: { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.view.transform = CGAffineTransform(translationX: 0, y: min(0, (strongSelf.view.frame.height) / 2 - (strongSelf.yCoorinateForMovingView)))
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case securityDeviceName:
            view.endEditing(true)
        default:
            break
        }
        return true
    }
}
