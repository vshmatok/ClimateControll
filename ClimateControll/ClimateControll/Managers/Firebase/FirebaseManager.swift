//
//  FirebaseManager.swift
//  ClimateControll
//
//  Created by Vlad Shmatok on 20.03.18.
//  Copyright © 2018 Vlad Shmatok. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager {
    
    //MARK: - Properties
    static let shared = FirebaseManager()
    let ref = Database.database().reference()
    
    //MARK: - Lifecycle
    private init() {}
    
    //MARK: - Internal
    //MARK: - Login and register methods
    //MARK: - Find user in database
    func findUserInDatabase(login:String, password:String, completion:@escaping (User?,String?) -> Void) {
        ref.queryOrdered(byChild: "login").queryStarting(atValue: login).queryEnding(atValue: login+"\u{f8ff}").observeSingleEvent(of: .value, with: { snapshot in
            DispatchQueue.main.async {
                guard let snapDict = snapshot.value as? [String: Any] else {
                    completion(nil,"Імя користувача або пароль невірні")
                    return
                }
                guard let dictionatyValue = snapDict.first?.value as? [String: Any] else { return }
                let receivedUser = User(json: dictionatyValue)
                receivedUser.id = snapDict.first!.key
                if receivedUser.password == password {
                    completion(receivedUser, nil)
                } else {
                    completion(nil,"Імя користувача або пароль невірні")
                }
            }
        })
    }
    
    //MARK: - Check usermame
    func checkIfUsernameIsTaken(login:String, completion:@escaping (Bool)->Void){
        ref.queryOrdered(byChild: "login").queryStarting(atValue: login).queryEnding(atValue: login+"\u{f8ff}").observeSingleEvent(of: .value, with: { snapshot in
            DispatchQueue.main.async {
                if snapshot.value as? [String: Any] != nil {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        })
    }
    
    //MARK: - Register user
    func register(model:User, completion:@escaping ()->Void) {
        let key = ref.childByAutoId().key
        ref.child(key).setValue(model.dictionary)
        DispatchQueue.main.async {
            completion()
        }
    }
    
    //MARK: - Room
    //MARK: - Create room
    func createRoom(roomName: String, id:String) {
        ref.child(id).child("Rooms").child(roomName).setValue("empty")
    }
    
    //MARK: - Update room info from database
    func updateRooms(id:String,completion: @escaping ([Room])->Void) {
        ref.child(id).child("Rooms").observe(.value, with: { snapshot in
            var roomsArray = [Room]()
            guard let snapDict = snapshot.value as? [String: Any] else {
                completion(roomsArray)
                return
            }
            guard !snapDict.isEmpty else { return }
            for snaps in snapDict.keys {
                let room = Room(roomName: snaps)
                roomsArray.append(room)
            }
            DispatchQueue.main.async {
                completion(roomsArray)
            }
        })
    }
    
    //MARK: - Check room
    func checkRoom(id:String, roomName:String, completion: @escaping (Bool)->Void) {
        ref.child(id).child("Rooms").child(roomName).observeSingleEvent(of: .value) { snapshot in
            DispatchQueue.main.async {
                if snapshot.value as? [String: Any] != nil {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    //MARK: - Remove room
    func removeRoom(roomName: String, id:String) {
        ref.child(id).child("Rooms").child(roomName).removeValue()
    }
    
    //MARK: - Light
    //MARK: - Create room
    func createLight(light:Light, roomName: String, id:String) {
        ref.child(id).child("Rooms").child(roomName).child("Light").child(light.name!).setValue(light.dictionary)
    }
    
    //MARK: - Remove light
    func removeLight(light:Light, roomName: String, id:String) {
        ref.child(id).child("Rooms").child(roomName).child("Light").child(light.name!).removeValue()
    }
    
    //MARK: - Check light
    func checkLight(light:Light, id:String, roomName:String, completion: @escaping (Bool)->Void) {
        ref.child(id).child("Rooms").child(roomName).child("Light").child(light.name!).observeSingleEvent(of: .value) { snapshot in
            DispatchQueue.main.async {
                if snapshot.value as? [String: Any] != nil {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    //MARK: - Update light state from database
    func updateLight(id:String, roomName:String, completion: @escaping ([Light])->Void) {
        ref.child(id).child("Rooms").child(roomName).child("Light").observe(.value, with: { snapshot in
            var lightArray = [Light]()
            guard let snapDict = snapshot.value as? [String: Any] else {
                completion(lightArray)
                return
            }
            guard !snapDict.isEmpty else { return }
            for snaps in snapDict{
                let name = snaps.key
                let stateDict = snaps.value as! [String:Any]
                let state = stateDict["state"] as! String
                let light = Light(name: name, state: state)
                lightArray.append(light)
            }
            DispatchQueue.main.async {
                completion(lightArray)
            }
        })
    }
    
    //MARK: - Change button state
    func togleLight(light:Light, id:String, room:String) {
        if light.state! == "on" {
            ref.child(id).child("Rooms").child(room).child("Light").child(light.name!).setValue(["state":"off"])
        } else {
            ref.child(id).child("Rooms").child(room).child("Light").child(light.name!).setValue(["state":"on"])
        }
    }
    
    //MARK: - Window
    //MARK: - Create window
    func createWindow(window:Window, roomName: String, id:String) {
        ref.child(id).child("Rooms").child(roomName).child("Window").child(window.name!).setValue(window.dictionary)
    }
    
    //MARK: - Remove window
    func removeWindow(window:Window, roomName: String, id:String) {
        ref.child(id).child("Rooms").child(roomName).child("Window").child(window.name!).removeValue()
    }
    
    //MARK: - Check window
    func checkWindow(window:Window, id:String, roomName:String, completion: @escaping (Bool)->Void) {
        ref.child(id).child("Rooms").child(roomName).child("Window").child(window.name!).observeSingleEvent(of: .value) { snapshot in
            DispatchQueue.main.async {
                if snapshot.value as? [String: Any] != nil {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    //MARK: - Update window state from database
    func updateWindow(id:String, roomName:String, completion: @escaping ([Window])->Void) {
        ref.child(id).child("Rooms").child(roomName).child("Window").observe(.value, with: { snapshot in
            var windowArray = [Window]()
            guard let snapDict = snapshot.value as? [String: Any] else {
                completion(windowArray)
                return
            }
            guard !snapDict.isEmpty else { return }
            for snaps in snapDict{
                let name = snaps.key
                let stateDict = snaps.value as! [String:Any]
                let state = stateDict["state"] as! String
                let window = Window(name: name, state: state)
                windowArray.append(window)
            }
            DispatchQueue.main.async {
                completion(windowArray)
            }
        })
    }
    
    //MARK: - Change window state
    func togleWindow(window:Window, id:String, room:String) {
        if window.state! == "open" {
            ref.child(id).child("Rooms").child(room).child("Window").child(window.name!).setValue(["state":"closed"])
        } else {
            ref.child(id).child("Rooms").child(room).child("Window").child(window.name!).setValue(["state":"open"])
        }
    }
    
    //MARK: - Sensor
    //MARK: - Create sensor
    func createSensor(sensor: Sensor, roomName: String, id:String) {
        ref.child(id).child("Rooms").child(roomName).child("Sensor").child(sensor.type!).child(sensor.name!).setValue(sensor.dictionary)
    }
    
    //MARK: - Remove sensor
    func removeSensor(sensor: Sensor, roomName: String, id:String) {
        ref.child(id).child("Rooms").child(roomName).child("Sensor").child(sensor.type!).child(sensor.name!).removeValue()
    }
    
    //MARK: - Togle sensor
    func togleSensor(sensor: Sensor, roomName: String, id: String) {
        if sensor.state == "off"{
            ref.child(id).child("Rooms").child(roomName).child("Sensor").child(sensor.type!).child(sensor.name!).setValue(["state":"on"])
        } else{
            ref.child(id).child("Rooms").child(roomName).child("Sensor").child(sensor.type!).child(sensor.name!).setValue(["state":"off"])
        }
    }
    
    //MARK: - Check Sensor
    func checkSensor(sensor: Sensor, id:String, roomName:String, completion: @escaping (Bool)->Void) {
        ref.child(id).child("Rooms").child(roomName).child("Sensor").child(sensor.type!).child(sensor.name!).observeSingleEvent(of: .value) { snapshot in
            DispatchQueue.main.async {
                if snapshot.value as? [String: Any] != nil {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    //MARK: - Update sensor state from database
    func updateSensor(id:String, roomName:String,type:String, completion: @escaping ([Sensor])->Void) {
        ref.child(id).child("Rooms").child(roomName).child("Sensor").child(type).observe(.value, with: { snapshot in
            var sensorArray = [Sensor]()
            guard let snapDict = snapshot.value as? [String: Any] else {
                completion(sensorArray)
                return
            }
            guard !snapDict.isEmpty else { return }
            for snaps in snapDict{
                let name = snaps.key
                let stateDict = snaps.value as! [String:Any]
                let state = stateDict["state"] as! String
                let sensor = Sensor(name: name, state: state, type: type, room: roomName)
                sensorArray.append(sensor)
            }
            DispatchQueue.main.async {
                completion(sensorArray)
            }
        })
    }
    
    //MARK: - Observe sensors
    func observeSensors(id:String,completion:@escaping ([Sensor])->Void) {
        ref.child(id).child("Rooms").observe(.childChanged, with: { snapshot in
            let roomName = snapshot.key
            var sensorArray = [Sensor]()
            guard let snapDict = snapshot.value as? [String: Any] else {
                return
            }
            guard let sensorTypes = snapDict["Sensor"]  as? [String:Any] else {
                return
            }
            for sensors in sensorTypes {
                let sensorType = sensors.key
                guard let currentSensor = sensors.value as? [String:Any] else {
                    return
                }
                for sensorState in currentSensor {
                    guard let currentSensorsStates = sensorState.value as? [String:String] else {
                        return
                    }
                    guard let currentState = currentSensorsStates["state"] else {
                        return
                    }
                    let sensor = Sensor(name: sensorState.key, state: currentState, type: sensorType,room: roomName)
                    sensorArray.append(sensor)
                }
            }
            DispatchQueue.main.async {
                completion(sensorArray)
            }
        })
    }
    
    
    //MARK: - Indexes
    //MARK: - Receive temperature
    func receiveTemperature(id:String, roomName:String, complation:@escaping (Double)->Void) {
        ref.child(id).child("Rooms").child(roomName).child("Indexes").child("Temperature").child("value").observe(.value, with: { snapshot in
            guard let temperature = snapshot.value as? Double else { return }
            DispatchQueue.main.async {
                complation(temperature)
            }
        })
    }
    
    //MARK: - Receive humidity
    func receiveHumidity(id:String, roomName:String, complation:@escaping (Double)->Void) {
        ref.child(id).child("Rooms").child(roomName).child("Indexes").child("Humidity").child("value").observe(.value, with: { snapshot in
            guard let humidity = snapshot.value as? Double else { return }
            DispatchQueue.main.async {
                complation(humidity)
            }
        })
    }
    //MARK: - Receive state of air
    func receiveStateOfAir(id:String, roomName:String, complation:@escaping (Int)->Void) {
        ref.child(id).child("Rooms").child(roomName).child("Indexes").child("StateOfAir").child("value").observe(.value, with: { snapshot in
            guard let stateOfAir = snapshot.value as? Int else { return }
            DispatchQueue.main.async {
                complation(stateOfAir)
            }
        })
    }
}
