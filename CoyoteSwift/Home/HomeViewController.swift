//
//  HomeViewController.swift
//  CoyoteSwift
//
//  Created by Kaviya Prarthana on 19/08/19.
//  Copyright © 2019 Kaviya Prarthana. All rights reserved.
//

import UIKit
import CoreData
import AudioToolbox
import AVFoundation

struct distancetype{
    static var type = "km/hr"
}

class HomeViewController: UIViewController {

    @IBOutlet weak var kmphArrow: UIImageView!
    
    @IBOutlet weak var meterview: UIView!
    
    @IBOutlet weak var kilometer: UIButton!
    
    @IBOutlet weak var miles: UIButton!
    
    @IBOutlet weak var mphrArrow: UIImageView!
    
    @IBOutlet weak var speedlimit: UILabel!
    
    @IBOutlet weak var place: UILabel!
    
    @IBOutlet weak var limitType: UILabel!
    
    @IBOutlet weak var unitLabel: UILabel!
   
    //MARK:- Initializer
    var progrView = BSProgressSpeedIndicator()
    let speedCalculation = SpeedCalculation.speedShared
    let sharedCommonClass = CommonClass()
    let locationShared = Location.shared
    let coreDataShared = CoreDataModel.coreDataShared
    var currentSpeedUnit : CGFloat = 0.0
    var delegate : SpeedManagerDelegate?
    var previousSpeed : CGFloat = 0.0 {
        didSet{
            previousSpeed = self.speedCalculation.currentSpeed
        }
    }

    var maxSpeed: CGFloat {
        var maxSpeed = CGFloat()
       
        if let maximumSpeed = NumberFormatter().number(from: speedCalculation.maxSpeed){
           
           maxSpeed = CGFloat(truncating: maximumSpeed)
        }
        return maxSpeed
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initScreen()
    }

    //MARK:- SetUp
    func initScreen() {
    
    self.switchColor()
    let  image = UIImage(named: "rect2")!
    self.speedlimit.textColor = UIColor.init(patternImage: image)
    self.limitType.text =  distancetype.type
    self.unitLabel.text =  distancetype.type
        
    NotificationCenter.default.addObserver(self, selector: #selector(self.updateCurrentSpeed(notification:)), name:Notification.Name("speedvalue"), object: nil)
     
    NotificationCenter.default.addObserver(self, selector: #selector(self.changeplacetext(notification:)), name: Notification.Name("placename"), object: nil)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    progrView = BSProgressSpeedIndicator.init(frame: CGRect(x:0,y:0,width:self.meterview.frame.size.width,height:self.meterview.frame.size.height))
    progrView.show(withProgress: ((self.currentSpeedUnit/100) + 0.01)*0.26 , on: self.meterview)
    }
    
  //MARK:- SegmentController function
    func switchColor() {
        if(miles.tag == 0){
            
            kilometer.setTitleColor(UIColor.yellow, for: UIControl.State.normal)
            miles.setTitleColor(UIColor.white, for: UIControl.State.normal)
            kmphArrow.isHidden = false
            mphrArrow.isHidden = true
            miles.tag = 1
           
            
        }else{
            
            kilometer.setTitleColor(UIColor.white, for: UIControl.State.normal)
            miles.setTitleColor(UIColor.yellow, for: UIControl.State.normal)
            kmphArrow.isHidden = true
            mphrArrow.isHidden = false
            miles.tag = 0
        }
    }
    
    //MARK:- Place Notification
    @objc func changeplacetext(notification: Notification){
       
        guard let placeName = notification.object as? String else {return}
        self.place.text = placeName
        self.locationShared.placeName = placeName
    }
   
    //MARK:- Speed Notification
    @objc func updateCurrentSpeed(notification: Notification){
    if currentReachabilityStatus != .notReachable {
        
    guard let speed = notification.object as? CGFloat else {return}
    
        distancetype.type == "mi/h" ? (self.currentSpeedUnit = round(speed * 0.620)/4.0): (self.currentSpeedUnit = round(speed/4.0))
    self.progrView.setBarProgress((self.currentSpeedUnit/100+0.01)*0.26 as CGFloat, animate: true)
    
    if (speed > 10) {
        self.urlfunc()
        distancetype.type == "mi/h" ? self.speedlimit.text = self.sharedCommonClass.KilometerToMiles(speedinKm: self.speedCalculation.maxSpeed) : (self.speedlimit.text = self.speedCalculation.maxSpeed)
        
    if(self.maxSpeed != 0) && (speed - self.maxSpeed) > 10 &&  (speed - previousSpeed) > 10 {
       
        self.speedCalculation.currentSpeed = speed
        self.speedCalculation.maxSpeed = String(describing:self.maxSpeed)
        self.speedCalculation.dateString = self.sharedCommonClass.todayDate
        self.speedCalculation.currentSpeedUnit = distancetype.type
        guard let place = self.locationShared.placeName else {return}
        self.sharedCommonClass.playSound()
        self.coreDataShared.adddetailsDatabase(drivingSpeed: String(describing:self.speedCalculation.currentSpeed), maximumSpeed: self.speedCalculation.maxSpeed, date: self.speedCalculation.dateString, distancetype: distancetype.type, place: place)
                  
        previousSpeed = self.speedCalculation.currentSpeed
       NotificationCenter.default.post(name:  NSNotification.Name(rawValue: "refresh"), object: nil, userInfo: ["currentSpeed": String(describing:self.speedCalculation.currentSpeed) , "maxSpeed": self.speedCalculation.maxSpeed,"date":self.speedCalculation.dateString,"place":place,"speedUnit": self.speedCalculation.currentSpeedUnit   ])
       
        }
        }

        }
    else{
    self.sharedCommonClass.internetCheckAlert(vc: self,title: "no internet", message: "Go to Settings?")
    }
    }
    
    //MARK:- kmBtnAction
    @IBAction func kmBtnAction(_ sender: Any) {
        miles.tag = 0
        distancetype.type = "km/hr"
        self.unitLabel.text =  distancetype.type
        limitType.text = distancetype.type
        switchColor()
        progrView.changeLabel("km/hr")
       
        self.speedlimit.text = self.speedCalculation.maxSpeed
        
        if miles.tag == 1 {
        miles.tag = 0
     
        DispatchQueue.main.async {
            self.progrView.setBarProgress(((self.currentSpeedUnit / 100)+0.01)*0.26, animate: true)
        }
      }
    }
    
    //MARK:- milesBtnAction
    @IBAction func milesBtnAction(_ sender: Any) {
        miles.tag = 1
        distancetype.type = "mi/h"
        self.unitLabel.text = distancetype.type
        limitType.text = distancetype.type
        switchColor()
        progrView.changeLabel("mi/h")

        if miles.tag == 0 {
            miles.tag = 1
            
        DispatchQueue.main.async {
        self.progrView.setBarProgress((((self.currentSpeedUnit * 0.621) / 100+0.01)*0.26), animate: true)
        self.speedlimit.text = self.sharedCommonClass.KilometerToMiles(speedinKm: self.speedCalculation.maxSpeed)
        }
      }
       
    }
   //MARK:- URL
    func urlfunc() -> Void {
     if (currentReachabilityStatus == .notReachable) ||
   (self.locationShared.currentLocation == ""){
        self.sharedCommonClass.internetCheckAlert(vc: self, title:"please check your GPS service", message: "")
    }
    else{
    
        if let coOrdinatePoints = self.locationShared.currentLocation{
            
         let currentLocationPoints = coOrdinatePoints.split(separator: ",").map(String.init)
         let  coOrdinateLatitude = currentLocationPoints[0]
         let  coOrdinateLongitude = currentLocationPoints[1]
         let speedLimitString = "&unit=KMPH&openLr=true&key=R7BzNNYL4h4KrgLBtKTIBNukzAx7g1m0"
         let urlString = "https://api.tomtom.com/traffic/services/4/flowSegmentData/absolute/10/json?point=" + coOrdinateLatitude + "%2C" + coOrdinateLongitude + speedLimitString
       
        guard let speedUrl = URL(string: urlString) else { return }
         URLSession.shared.dataTask(with: speedUrl) { (data, response
                  , error) in
          
              do {
              guard let data = data else { return }
              let json = try? JSONSerialization.jsonObject(with: data, options: [])

              if let json = json as? [String: Any] {
                
             let jsonDictionaey = json["flowSegmentData"] as! [String:Any]
             let speedLimitValue = jsonDictionaey["freeFlowTravelTime"] as? Int
                
             if let speedLimitValue = speedLimitValue{
                self.speedCalculation.maxSpeed = String(describing:speedLimitValue)
         }
          
              }else {
                return
                }
            }
            catch let err {
                      print("Err", err)
               }
         }.resume()
        }
      }
    }
    
}
