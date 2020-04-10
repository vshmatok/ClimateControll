//
//  WindowSettingsViewController.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 17.04.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import UIKit

class WindowSettingsViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var currentWindow: UILabel!
    @IBOutlet weak var temperatureToOpenWindow: UILabel!
    @IBOutlet weak var temperatureSlider: UISlider!
    @IBOutlet weak var windowState: UIButton!
    var window:Window?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        currentWindow.text = window!.name
        temperatureToOpenWindow.text = "30°C"
        configureButton()
    }
    
    //MARK: - IBActions
    @IBAction func didTapCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func changeTemperature(_ sender: UISlider) {
        temperatureToOpenWindow.text = "\(Int(sender.value))0°C"
    }
    @IBAction func didTapDelete(_ sender: UIButton) {
        FirebaseManager.shared.removeWindow(window: window!, roomName: Constants.currentRoom, id: Constants.id)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeState(_ sender: UIButton) {
        FirebaseManager.shared.togleWindow(window: window!, id: Constants.id, room: Constants.currentRoom)
        switch window!.state! {
        case "open":
            window!.state = "closed"
        default:
            window!.state = "open"
        }
        configureButton()
    }
    
    //MARK: - Private
    private func configureButton() {
        switch window!.state! {
        case "open":
            windowState.setTitle("Close", for: .normal)
        default:
            windowState.setTitle("Open", for: .normal)
        }
    }
}
