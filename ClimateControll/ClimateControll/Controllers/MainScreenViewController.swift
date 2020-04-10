//
//  MainScreenViewController.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 11.04.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var roomsTableView: UITableView!
    private var rooms = [Room]() {
        didSet{
            roomsTableView.reloadData()
        }
    }
    private var rightNavigationBarButton:UIButton!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        FirebaseManager.shared.updateRooms(id: Constants.id, completion: { rooms in
            self.rooms = rooms
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        })
        
        FirebaseManager.shared.observeSensors(id:Constants.id, completion: { sensors in
            Constants.troubleSensors.removeAll()
            var numberOfTroubles = 0
            for sensor in sensors where sensor.state == "on"{
                numberOfTroubles += 1
                Constants.troubleSensors.append(sensor)
            }
            
            if numberOfTroubles == 0 {
                self.navigationItem.leftBarButtonItem?.removeBadge()
            } else {
                self.navigationItem.leftBarButtonItem?.addBadge(number: numberOfTroubles)
            }
        })
    }
}

//MARK: - Extensions
//MARK: - UITableViewDelegate,UITableViewDataSource
extension MainScreenViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return rooms.count
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            FirebaseManager.shared.removeRoom(roomName: rooms[indexPath.section].roomName!, id: Constants.id)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath) as! RoomTableViewCell
        cell.configure(with: rooms[indexPath.section])
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Constants.currentRoom = rooms[indexPath.section].roomName!
        performSegue(withIdentifier: "toDescription", sender: self)
    }
}
