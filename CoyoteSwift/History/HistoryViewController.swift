//
//  HistoryViewController.swift
//  CoyoteSwift
//
//  Created by Kaviya Prarthana on 21/08/19.
//  Copyright © 2019 Kaviya Prarthana. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
   
   
    @IBOutlet var tableView: UITableView!
  
    
    let shared = CommonClass.shared
    let speedShared = SpeedCalculation.speedShared
    var speedCoreData = CoreDataModel.coreDataShared.getProfileData()
    let locationShared = Location.shared
   
    var speedData = SpeedCalculation.speedShared 
   
    var detailList : Detail = Detail(location: "", speedCalculator: SpeedCalculation(currentSpeed: 0.0, currentSpeedUnit: "", dateString: "", maxSpeed: "", drivingSpeed: ""))
    
    var detailListArray : [Detail] = [Detail]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initScreen()
       
    }
   //MARK:- Initializers
    func initScreen() {
        
    self.navigationController?.navigationBar.topItem?.title = "SUMMARY"
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.tableView.contentInset = UIEdgeInsets(top: 5,left: 0,bottom: 0,right: 0)
    self.tableView.tableFooterView = UIView(frame: .zero)
   
    DispatchQueue.main.async{
    NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "refresh"), object: nil,queue: nil, using: self.fetchNotification)
     
     self.tableView.reloadData()
        }
  
  
         self.fetch()
    }
   
  //MARK:- TableView Methods
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
   
    return detailListArray.count
    }
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryTableViewCell
    
    let detailCell = self.detailListArray[indexPath.row]
    
    guard
    
        let max = NumberFormatter().number(from: detailCell.speedCalculator!.maxSpeed),
    let drive = NumberFormatter().number(from: detailCell.speedCalculator!.drivingSpeed)
                                             
    else {
      return cell
    }
    cell.datetime.text = detailCell.speedCalculator?.dateString
    cell.location.text = detailCell.location
    cell.drivelbl.text = distancetype.type
    cell.limitlbl.text = distancetype.type
    //conversion wrt unit
  
    if (distancetype.type == "mi/h") && (detailCell.speedCalculator?.currentSpeedUnit == "km/hr") {
                          
        cell.exceededspeed.text = String(format:"%.0f",round(CGFloat(truncating: drive) * 0.620))
        cell.speedlimit.text =  String(format:"%.0f", round(CGFloat(truncating: max) * 0.620))
                           
        }else
        if (distancetype.type == "km/hr") && (detailCell.speedCalculator?.currentSpeedUnit == "mi/h") {
                        
        cell.exceededspeed.text = String(format:"%.0f", round(CGFloat(truncating: drive) * 1.690))
        cell.speedlimit.text =  String(format:"%.0f", round(CGFloat(truncating: max) * 1.690))
                           
                           
        }else if (distancetype.type ==  detailCell.speedCalculator?.currentSpeedUnit){
                         
        cell.exceededspeed.text = String(format:"%.0f", round(CGFloat(truncating: drive)))
        cell.speedlimit.text = String(format:"%.0f", round(CGFloat(truncating: max)))
             }
       
   
      return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
   
    //MARK:- CoreData Fetch
    func fetch(){
        //speedCoreData.removeAll()
        print(speedCoreData.count)
        if speedCoreData.count > 0 {
    for speedData in speedCoreData{

        guard
        let maxSpeed = speedData.maximumSpeed,
        let drivingSpeed = speedData.drivingSpeed,
        let dateString = speedData.date,
        let currentSpeedUnit = speedData.speedType,
        let place = speedData.place

        else {
             return
           }
       self.detailList = Detail(location: place, speedCalculator: SpeedCalculation(currentSpeed: 0.0 , currentSpeedUnit: currentSpeedUnit, dateString: dateString, maxSpeed: maxSpeed, drivingSpeed:drivingSpeed))

      self.detailListArray.append(self.detailList)
        self.detailListArray = self.detailListArray.sorted(by: {
            $0.dateString.compare($1.dateString) == .orderedDescending
        })
     
        }
      }

    }

    func fetchNotification(notification:Notification) -> Void {
         
       guard
              let maxSpeed = notification.userInfo!["maxSpeed"],
              let drivingSpeed = notification.userInfo!["currentSpeed"],
              let dateString = notification.userInfo!["date"],
              let currentSpeedUnit = notification.userInfo!["speedUnit"],
              let place = notification.userInfo!["place"]
              
              else {
                   return
                 }
        self.detailList = Detail(location: place as! String, speedCalculator: SpeedCalculation(currentSpeed: 0.0 , currentSpeedUnit: currentSpeedUnit as! String, dateString: dateString as! String, maxSpeed: maxSpeed as! String, drivingSpeed:drivingSpeed as! String))
              
        self.detailListArray.append(self.detailList)
        self.detailListArray = self.detailListArray.sorted(by: {
                   $0.dateString.compare($1.dateString) == .orderedDescending
               })
            
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
       }
   
   
}


          
       


