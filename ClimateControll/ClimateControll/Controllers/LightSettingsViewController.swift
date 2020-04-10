//
//  LightSettingsViewController.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 17.04.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import UIKit

class LightSettingsViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet private weak var lightSourseName: UILabel!
    @IBOutlet private weak var brightness: UILabel!
    @IBOutlet private weak var stateButton: UIButton!
    var currentLight:Light?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lightSourseName.text = currentLight?.name
        brightness.text = "100 %"
        configureButton()
    }
    
    //MARK: - IBActions
    @IBAction private func changeBrightness(_ sender: UISlider) {
        brightness.text = "\(Int(sender.value))0 %"
    }
    
    @IBAction func removeLight(_ sender: UIButton) {
        FirebaseManager.shared.removeLight(light: currentLight!, roomName: Constants.currentRoom, id: Constants.id)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction private func changeState(_ sender: UIButton) {
        FirebaseManager.shared.togleLight(light: currentLight!, id: Constants.id, room: Constants.currentRoom)
        switch currentLight!.state! {
        case "on":
            currentLight?.state = "off"
        default:
            currentLight?.state = "on"
        }
        configureButton()
    }
    
    //MARK: - Private
    private func configureButton() {
        switch currentLight!.state! {
        case "on":
            stateButton.setTitle("Turn Off", for: .normal)
        default:
            stateButton.setTitle("Turn On", for: .normal)
        }
    }
}
