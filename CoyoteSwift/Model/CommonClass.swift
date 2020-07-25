//
//  CommonClass.swift
//  CoyoteSwift
//
//  Created by Kaviya Prarthana on 19/08/19.
//  Copyright © 2019 Kaviya Prarthana. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AudioToolbox

class CommonClass {

    static let shared : CommonClass = CommonClass.shared
    let speedManager = SpeedManager()
    var player : AVAudioPlayer?
    
//MARK:- Internet connectivity
    func internetCheckAlert(vc: UIViewController,title:String,message:String){
       
    let alertController = UIAlertController(title: title, message: message,preferredStyle:.alert )
            
    let settingsAction = UIAlertAction(title:"Could not reach the location, please check your GPS service" , style: .default) { (_) -> Void in
                           
    guard let settingsUrl = URL(string: "App-Prefs:root=WIFI") else {
                               
    return
    }
                           
    if UIApplication.shared.canOpenURL(settingsUrl) {
      UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
      print("Settings opened: \(success)") // Prints true
            })
            }
          }
      alertController.addAction(settingsAction)
      let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
      vc.present(alertController, animated: true, completion: nil)
    }
    //MARK:- Date
   var todayDate : String{
       let date = Date()
       let formatter = DateFormatter()
       formatter.dateFormat =  "MMM d, h:mm a"
       let result = formatter.string(from: date)
       return result
   }
    //MARK: - Km to Miles
    func KilometerToMiles(speedinKm:String)-> String{
        var miles : CGFloat = CGFloat()
        let myFloat = (speedinKm as NSString).floatValue
        miles = CGFloat(myFloat*0.620)
        let milesInString = String(describing: miles)
        return milesInString
    }
    var KilometerToMiles : String {
        var miles : CGFloat = CGFloat()
        let speedinKm : String = String()
        let myFloat = (speedinKm as NSString).floatValue
        miles = round(CGFloat(myFloat*0.620))/4.0
        let milesInString = String(describing: miles)
        return milesInString
    }
   //MARK:- Miles to Km
    func MilestoKm(speedinMiles: String) -> String {
       var km : CGFloat = CGFloat()
       let myFloat = (speedinMiles as NSString).floatValue
        km = round(CGFloat(myFloat*1.609))/4.0
        let kmInString = String(describing: km)
       return kmInString
    }
    

    //MARK:- play sound
   func playSound() {
        let url = Bundle.main.url(forResource: "Alarm", withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
            
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    }


