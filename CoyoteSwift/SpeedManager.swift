//
//  SpeedManager.swift
//  CoyoteSwift
//
//  Created by Kaviya Prarthana on 19/08/19.
//  Copyright © 2019 Kaviya Prarthana. All rights reserved.
//

import Foundation
import CoreLocation

typealias Speed = CLLocationSpeed

//MARK:- Protocol
protocol SpeedManagerDelegate {
    func speedDidChange(_ speed: Speed)
    
    
}
class SpeedManager : NSObject, CLLocationManagerDelegate {
    //MARK:- Initializers
    let locationShared : Location = Location.shared
    var delegate : SpeedManagerDelegate?
    let geoCoder = CLGeocoder()
    fileprivate var locationManager : CLLocationManager? = CLLocationManager()
  
    override init() {
    self.locationManager = CLLocationManager.locationServicesEnabled() ? locationManager : nil
    super.init()
    if let locationManager = self.locationManager {
       locationManager.delegate = self
       locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
       locationManager.startUpdatingLocation()
       locationManager.requestWhenInUseAuthorization()
       locationManager.requestAlwaysAuthorization()
            
    if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied {
        locationManager.requestAlwaysAuthorization()
        } else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways {
                locationManager.startUpdatingLocation()
            }
        }
    }
   //MARK:- CLLocation Methods
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if  status ==  CLAuthorizationStatus.authorizedAlways {
           locationManager?.startUpdatingLocation()
        }
    }
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
       
      //  let userLocation = locations[0]
        self.locationShared.currentLocation = "\(locations[0].coordinate.latitude)" + ","
            + "\(locations[0].coordinate.longitude)"
     
        if locations.count > 0 {
           
           
        self.locationShared.kmph = max(locations[locations.count - 1].speed / 1000 * 3600, 0)
        self.delegate?.speedDidChange(self.locationShared.kmph)
     
        self.geoCoder.reverseGeocodeLocation(locations[0], completionHandler: { (placemarks, error) -> Void in
                
            if error != nil {
               print("Error getting location: \(String(describing: error))")
                }else {
            if let placemarks = placemarks{
                self.locationShared.placeArray = placemarks
                NotificationCenter.default.post(name: Notification.Name("placename"),object: placemarks[0].locality)
            }
                }
            })
        }
    }














}
    

