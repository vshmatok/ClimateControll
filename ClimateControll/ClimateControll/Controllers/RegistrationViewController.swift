//
//  RegistrationViewController.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 11.03.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet private weak var loginField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var fieldsStackView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var yCoorinateForMovingView:CGFloat!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        registerForKeyboardNotificationsUser()
    }
    
    //MARK: - IBActions
    @IBAction private func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func register(_ sender: UIButton) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        guard loginField.text != "", passwordField.text != "" else {
            createAlert(title: "Error", message: "Enter all fields")
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            return 
        }
        let userModel = User(login: loginField.text!, password: passwordField.text!)
        FirebaseManager.shared.checkIfUsernameIsTaken(login: userModel.login) { isFree in
            if isFree {
                FirebaseManager.shared.register(model: userModel) {
                    self.createAlert(title: "Registration", message: "Succesfully registered") { _ in
                        _ =
                        self.dismiss(animated: true, completion: nil)
                    }
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            } else {
                self.createAlert(title: "Error", message: "This username is taken")
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
    }
}

//MARK: - Extensions
//MARK: - UITextFieldDelegate
extension RegistrationViewController:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case loginField:
            yCoorinateForMovingView = loginField.frame.origin.y + fieldsStackView.frame.origin.y
        case passwordField:
            yCoorinateForMovingView = passwordField.frame.origin.y + fieldsStackView.frame.origin.y
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
        case loginField:
            passwordField.becomeFirstResponder()
        case passwordField:
            view.endEditing(true)
        default:
            break
        }
        return true
    }
}
