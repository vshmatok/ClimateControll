//
//  Weather.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 21.03.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import Foundation

//MARK: - Weather
class Weather: Codable {
    //MARK: - Properties
    var temperature:Temperature?
    
    //MARK: - Codoing keys
    enum CodingKeys: String, CodingKey {
        case temperature = "main"
    }
}

//MARK: - Temperature
class Temperature: Codable {
    //MARK: - Properties
    var temperature: Double?
    var humidity: Double?
    
    //MARK: - Codoing keys
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case humidity = "humidity"
    }
}

