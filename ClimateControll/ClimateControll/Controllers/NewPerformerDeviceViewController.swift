//
//  NewPerformerDeviceViewController.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 17.04.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import UIKit

class NewPerformerDeviceViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet private weak var performerNameField: UITextField!
    @IBOutlet private weak var performerType: UISegmentedControl!
    @IBOutlet private weak var activityIndivator: UIActivityIndicatorView!
    private var yCoorinateForMovingView:CGFloat!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        registerForKeyboardNotificationsUser()
    }
    
    //MARK: - IBActions
    @IBAction private func didTapCreateNewPerformer(_ sender: UIButton) {
        activityIndivator.isHidden = false
        activityIndivator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        guard performerNameField.text != "" else {
            createAlert(title: "Error", message: "Enter all fields")
            activityIndivator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            return
        }
        
        switch getDeviceType() {
        case "Window":
            createWindow(name: performerNameField.text!)
            activityIndivator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        default:
            createLigh(name: performerNameField.text!)
            activityIndivator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()

        }
    }
    @IBAction private func didTapCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Private
    private func getDeviceType() -> String{
        switch performerType.selectedSegmentIndex {
        case 0: return "Window"
        default: return "Light"
        }
    }
    
    private func createWindow(name: String) {
        let window = Window()
        window.name = name
        window.state = "off"
        FirebaseManager.shared.checkWindow(window: window, id: Constants.id, roomName: Constants.currentRoom) { isCreated in
            if isCreated {
                self.createAlert(title: "Error", message: "Device with such name already exists")
            } else {
                FirebaseManager.shared.createWindow(window: window, roomName: Constants.currentRoom, id: Constants.id)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func createLigh(name: String) {
        let light = Light()
        light.name = name
        light.state = "off"
        FirebaseManager.shared.checkLight(light: light, id: Constants.id, roomName: Constants.currentRoom) { isCreated in
            if isCreated {
                self.createAlert(title: "Error", message: "Device with such name already exists")
            } else {
                FirebaseManager.shared.createLight(light: light, roomName: Constants.currentRoom, id: Constants.id)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

//MARK: - Extensions
//MARK: - UITextFieldDelegate
extension NewPerformerDeviceViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case performerNameField:
            yCoorinateForMovingView = performerNameField.frame.origin.y
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
        case performerNameField:
            view.endEditing(true)
        default:
            break
        }
        return true
    }
}
