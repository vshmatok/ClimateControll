//
//  NetworkManager.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 21.03.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import Foundation

class NetworkManager {
    
    //MARK: - Properties
    static let shared = NetworkManager()
    private let url = "http://api.openweathermap.org/data/2.5/weather?lat=48.61667&lon=22.3&appid=934c35f8e188aa065cf5211d8a8b0c87&units=metric"
    
    //MARK: - Internal
    //MARK: - Get weather
    func getWeather(completion: @escaping (Weather)->Void) {
        guard let url = URL(string: url) else {
            print("Error: cannot create URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }
            guard let responseData = data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let weather = try decoder.decode(Weather.self, from: responseData)
                DispatchQueue.main.async {
                    completion(weather)
                }
            } catch  {
                print("Error converting")
                return
            }
        }
        task.resume()
    }
}



