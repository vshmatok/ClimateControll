//
//  IndexesViewController.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 13.04.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import UIKit

class IndexesViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var indexesTableView: UITableView!
    private var currentTemperatureInRoom = ""
    private var currentHumidityInRoom = ""
    private var currentTemperatureOutside = ""
    private var currentHumidityOutside = ""
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        receiveWeatherData()
        FirebaseManager.shared.receiveTemperature(id: Constants.id, roomName: Constants.currentRoom) { temperature in
            self.currentTemperatureInRoom = String(temperature)
            self.indexesTableView.reloadData()
        }
        FirebaseManager.shared.receiveHumidity(id: Constants.id, roomName: Constants.currentRoom) { humidity in
            self.currentHumidityInRoom = String(humidity)
            self.indexesTableView.reloadData()
        }
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(receiveWeatherData), userInfo: nil, repeats: true)
    }
    
    //MARK: - IBAction
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Private
    @objc private func receiveWeatherData() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        NetworkManager.shared.getWeather { weather in
            guard let tempereature = weather.temperature?.temperature, let humidity = weather.temperature?.humidity else { return }
            self.currentTemperatureOutside = String(tempereature)
            self.currentHumidityOutside = String(humidity)
            self.indexesTableView.reloadData()
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
}

//MARK: - Extensions
//MARK: - UITableViewDataSource, UITableViewDelegate
extension IndexesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "indexesCell", for: indexPath) as! IndexesTableViewCell
        switch indexPath.section {
        case 0:
            cell.sensorTypeImage.image = #imageLiteral(resourceName: "temperature")
            cell.sensorType.text = "Temperature in room"
            cell.sensorValue.text = currentTemperatureInRoom + "°C"
        case 1:
            cell.sensorTypeImage.image = #imageLiteral(resourceName: "temperature")
            cell.sensorType.text = "Temperature outside"
            cell.sensorValue.text = currentTemperatureOutside + "°C"
        case 2:
            cell.sensorTypeImage.image = #imageLiteral(resourceName: "humidity")
            cell.sensorType.text = "Humidity in room"
            cell.sensorValue.text = currentHumidityInRoom + " %"
        case 3:
            cell.sensorTypeImage.image = #imageLiteral(resourceName: "humidity")
            cell.sensorType.text = "Humidity outside"
            cell.sensorValue.text = currentHumidityOutside + " %"
        default:
            return UITableViewCell()
        }
        
        return cell
    }
}
