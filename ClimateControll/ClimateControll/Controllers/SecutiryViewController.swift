//
//  SecutiryViewController.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 16.04.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import UIKit

class SecutiryViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet private weak var securityCollectionView: UICollectionView!
    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private let sections = ["Gas sensors", "Fire sensors", "Movement sensors"]
    private var gasSensor = [Sensor]() {
        didSet{
            configure()
            configreBadge()
            securityCollectionView.reloadData()
        }
    }
    private var fireSensor = [Sensor]() {
        didSet{
            configure()
            configreBadge()
            securityCollectionView.reloadData()
        }
    }
    private var movementSensor = [Sensor]() {
        didSet{
            configure()
            configreBadge()
            securityCollectionView.reloadData()
        }
    }
    
    private var sensors: [[Sensor]] {
        var tmpArray = [[Sensor]]()
        tmpArray.append(gasSensor)
        tmpArray.append(fireSensor)
        tmpArray.append(movementSensor)
        return tmpArray
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        receiveInfoFromSensors()
    }
    
    //MARK: - IBActions
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "deviceSettings" {
            let viewController = segue.destination as! SecurityDeviceSettingsViewController
            let indexPath = securityCollectionView.indexPathsForSelectedItems?.first
            viewController.currentDevice = sensors[indexPath!.section][indexPath!.row]
        }
    }
    
    //MARK: - Private
    private func receiveInfoFromSensors() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        FirebaseManager.shared.updateSensor(id: Constants.id, roomName: Constants.currentRoom, type: "Gas", completion: { sensors in
            self.gasSensor = sensors
        })
        FirebaseManager.shared.updateSensor(id: Constants.id, roomName: Constants.currentRoom, type: "Fire", completion: { sensors in
            self.fireSensor = sensors
        })
        FirebaseManager.shared.updateSensor(id: Constants.id, roomName: Constants.currentRoom, type: "Movement", completion: { sensors in
            self.movementSensor = sensors
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        })
    }
    
    private func configure(){
        if gasSensor.isEmpty, fireSensor.isEmpty, movementSensor.isEmpty {
            securityCollectionView.isHidden = true
        } else {
            securityCollectionView.isHidden = false
        }
    }
    
    private func badgeCount() -> Int {
        var alerts = 0
        for sections in sensors {
            for sensor in sections where sensor.state == "on" {
                alerts += 1
            }
        }
        return alerts
    }
    
    private func configreBadge() {
        if let tabItems = self.tabBarController?.tabBar.items as NSArray!
        {
            if badgeCount() == 0 {
                let tabItem = tabItems[0] as! UITabBarItem
                tabItem.badgeValue = nil
            } else {
                let tabItem = tabItems[0] as! UITabBarItem
                tabItem.badgeValue = "\(badgeCount())"
            }
        }
    }
}

extension SecutiryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sensors.count > 0 {
            return sensors[section].count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath) as? HeaderCollectionReusableView{
            sectionHeader.headerLabel.text = sections[indexPath.section]
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "securityCell", for: indexPath) as! SecurityCollectionViewCell
        cell.configure(with: sensors[indexPath.section][indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "deviceSettings", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3 - 15, height: collectionView.frame.size.width/3 - 15)
    }
}
