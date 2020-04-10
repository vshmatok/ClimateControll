//
//  PerformersViewController.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 16.04.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import UIKit

class PerformersViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var deviceColletion: UICollectionView!
    private let sections = ["Windows", "Lights"]
    private var windows = [Window]() {
        didSet{
            configure()
            deviceColletion.reloadData()
        }
    }
    private var light = [Light]() {
        didSet{
            configure()
            deviceColletion.reloadData()
        }
    }
    private var devices: [[Any]] {
        var tmpArray = [[Any]]()
        tmpArray.append(windows)
        tmpArray.append(light)
        return tmpArray
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        receiveInfoFromDevices()
    }
    
    //MARK: - IBActions
    @IBAction func didTapCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lightSettings" {
            let viewController = segue.destination as! LightSettingsViewController
            let indexPath = deviceColletion.indexPathsForSelectedItems?.first
            viewController.currentLight = devices[1][indexPath!.row] as? Light
        } else if segue.identifier == "windowSettings" {
            let viewController = segue.destination as! WindowSettingsViewController
            let indexPath = deviceColletion.indexPathsForSelectedItems?.first
            viewController.window = devices[0][indexPath!.row] as? Window
        }
    }
    
    //MARK: - Private
    private func receiveInfoFromDevices() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        FirebaseManager.shared.updateLight(id: Constants.id, roomName: Constants.currentRoom) { light in
            self.light = light
        }
        FirebaseManager.shared.updateWindow(id: Constants.id, roomName: Constants.currentRoom) { window in
            self.windows = window
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    private func configure(){
        if windows.isEmpty, light.isEmpty {
            deviceColletion.isHidden = true
        } else {
            deviceColletion.isHidden = false
        }
    }
}

//MARK: - Extensions
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension PerformersViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if devices.count > 0 {
            return devices[section].count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath) as? PerformersCollectionReusableView{
            sectionHeader.headerLabel.text = sections[indexPath.section]
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "windowCell", for: indexPath) as! WindowCollectionViewCell
            cell.configure(with: devices[0][indexPath.row] as! Window)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lightCell", for: indexPath) as! LightCollectionViewCell
            cell.configure(with: devices[1][indexPath.row] as! Light)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            performSegue(withIdentifier: "windowSettings", sender: self)
        default:
            performSegue(withIdentifier: "lightSettings", sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3 - 15, height: collectionView.frame.size.width/3 - 15)
    }
}
