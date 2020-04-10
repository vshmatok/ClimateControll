//
//  CreateNewRoomViewController.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 11.04.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import UIKit

class CreateNewRoomViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet private weak var roomNameTextField: UITextField!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    private var yCoorinateForMovingView:CGFloat!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        registerForKeyboardNotificationsUser()
    }
    
    //MARK: - IBActions
    @IBAction private func createNewRoom(_ sender: UIButton) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        guard roomNameTextField.text != "" else {
            createAlert(title: "Error", message: "Enter all fields")
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            return
        }
        FirebaseManager.shared.checkRoom(id: Constants.id, roomName: roomNameTextField.text!, completion: { isCreated in
            if isCreated {
                self.createAlert(title: "Error", message: "Room with such name already exists")
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            } else {
                FirebaseManager.shared.createRoom(roomName: self.roomNameTextField.text!, id: Constants.id)
                self.dismiss(animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        })
    }
    
    @IBAction private func didTapCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - Extensions
//MARK: - UITextFieldDelegate
extension CreateNewRoomViewController:UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case roomNameTextField:
            yCoorinateForMovingView = roomNameTextField.frame.origin.y
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
        case roomNameTextField:
            view.endEditing(true)
        default:
            break
        }
        return true
    }
}

