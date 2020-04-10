//
//  SettingsViewController.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 11.04.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet private weak var indentifierLabel: UILabel!
    @IBOutlet private weak var troublesTableView: UITableView!
    @IBOutlet weak var troubleLabel: UIView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        indentifierLabel.text = Constants.id
        Constants.delegate = self
    }
    
    //MARK: - IBActions
    @IBAction private func didTapCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapLogout(_ sender: UIButton) {
        UserDefaultsManager.shared.logout()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegistrationNavigationController")
            as! UINavigationController
        present(vc, animated: true, completion: nil)
    }
    
    //MARK: - Private
    private func configure() {
        if Constants.troubleSensors.isEmpty {
            troublesTableView.isHidden = true
            troubleLabel.isHidden = true
        } else {
            troublesTableView.isHidden = false
            troubleLabel.isHidden = false
        }
    }
}

//MARK: - Extensions
//MARK: - UITableViewDelegate, UITableViewDataSource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.troubleSensors.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "troubleCell", for: indexPath) as! TroublesTableViewCell
        cell.configure(with: Constants.troubleSensors[indexPath.section])
        
        return cell
    }
    
}

//MARK: - UpdateDelegate
extension SettingsViewController: UpdateDelegate {
    func updateAll() {
        troublesTableView.reloadData()
        configure()
    }
    
    
}

