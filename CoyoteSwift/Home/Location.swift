//
//  Location.swift
//  CoyoteSwift
//
//  Created by Kaviya Prarthana on 19/08/19.
//  Copyright © 2019 Kaviya Prarthana. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import AVFoundation

//MARK:- Detail
struct Detail {
   
    let shared = Location.shared
    var location : String? = ""
    var speedCalculator : SpeedCalculation? = nil
    
    init (location : String = "", speedCalculator: SpeedCalculation = SpeedCalculation(currentSpeed: 0.0, currentSpeedUnit: "", dateString: "", maxSpeed: "", drivingSpeed: "")){
        self.location = location
        self.speedCalculator = speedCalculator
    }
}
//MARK:- Location
class Location : NSObject {
   
    static let shared = Location()
    var currentLocation : String? = ""
    var kmph = CLLocationSpeed()
    var placeArray = [CLPlacemark]()
    var placeMark : CLPlacemark? = CLPlacemark()
    var placeName : String? = ""
    override init () {
        super.init()
    }
    
    init(currentLocation: String, kmph : CLLocationSpeed, placeArray : [CLPlacemark], placeMark : CLPlacemark,placeName: String) {
        self.currentLocation = currentLocation
        self.kmph = kmph
        self.placeArray = placeArray
        self.placeMark = self.placeArray[0]
        self.placeName = placeName
    }
}
//MARK:- SpeedCalculation
class SpeedCalculation : NSObject {
    
        static let speedShared = SpeedCalculation()
    var drivingSpeed : String = ""
    var currentSpeed :CGFloat = 0.0
    var currentSpeedUnit :String =  ""
    var dateString :String = ""
    var maxSpeed : String = ""
    
    override init(){
        super.init()
    }
    
    init(currentSpeed:CGFloat,currentSpeedUnit: String, dateString : String, maxSpeed: String,drivingSpeed :String){
    
     self.currentSpeedUnit = currentSpeedUnit
     self.dateString = dateString
     self.maxSpeed = maxSpeed
     self.currentSpeed = currentSpeed
     self.drivingSpeed = drivingSpeed
    }
    }


    
    
    

