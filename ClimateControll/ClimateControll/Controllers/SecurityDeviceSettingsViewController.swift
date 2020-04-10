//
//  SecurityDeviceSettingsViewController.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 17.04.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import UIKit

class SecurityDeviceSettingsViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var deviceType: UILabel!
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var deviceState: UILabel!
    @IBOutlet weak var deviceStateButton: UIButton!
    var currentDevice:Sensor?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceType.text = currentDevice!.type! + " sensor"
        deviceName.text = currentDevice!.name
        configureButton()
    }
    
    //MARK: - IBActions
    @IBAction func deleteDevice(_ sender: UIButton) {
        FirebaseManager.shared.removeSensor(sensor: currentDevice!, roomName: Constants.currentRoom, id: Constants.id)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func didTapCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func changeState(_ sender: UIButton) {
        FirebaseManager.shared.togleSensor(sensor: currentDevice!, roomName: Constants.currentRoom, id: Constants.id)
        switch currentDevice!.state! {
        case "on":
            currentDevice?.state = "off"
        default:
            currentDevice?.state = "on"
        }
        configureButton()
    }
    
    //MARK: - Private
    private func configureButton() {
        switch currentDevice!.state! {
        case "on":
            deviceStateButton.setTitle("Turn Off", for: .normal)
            deviceState.text = "Trouble"
        default:
            deviceStateButton.setTitle("Turn On", for: .normal)
            deviceState.text = "Peace"
        }
    }
}
