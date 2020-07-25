//
//  BaseViewController.swift
//  CoyoteSwift
//
//  Created by Kaviya Prarthana on 19/08/19.
//  Copyright © 2019 Kaviya Prarthana. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, SpeedManagerDelegate {

    @IBOutlet var segments: UISegmentedControl!
    
    @IBOutlet var homeView: UIView!
    
    @IBOutlet var historyView: UIView!
   
    let sharedCommonClass = CommonClass()
    let speedManager = SpeedManager()

 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initScreen()
    }
 //MARK:- Initializers
   func initScreen() {
     self.title = "Speed"
     self.segmentContoller(segment: self.segments)
     UINavigationBar.appearance().shadowImage = UIImage()
     UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
     speedManager.delegate = self
     self.segments.selectedSegmentIndex = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
       if currentReachabilityStatus == .notReachable
      {
      self.sharedCommonClass.internetCheckAlert(vc: self,title: "no internet", message: "Go to Settings?")
      }
       
    }
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
    if sender.selectedSegmentIndex == 0 {
       
        UIView.animate(withDuration: 0.5, animations: {
          //  self.historyView.alpha = 0
            self.homeView.alpha = 1
        })
        self.title = "SPEED"
        } else {
       
        UIView.animate(withDuration: 0.5, animations: {
        // self.historyView.alpha = 1
         self.homeView.alpha = 0
        })
       
    self.title = "SUMMARY"
    
    }
    
    }
   //MARK:- Gradient function
        func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
        
    }
    
    func imagewithgradian()-> UIImage{
        
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = segments.frame
    gradientLayer.colors =  [UIColor(red: 255/255, green: 234/255, blue: 0/255, alpha: 1.0),UIColor(red: 255/255, green: 234/255, blue: 0/255, alpha: 1.0),UIColor(red: 255/255, green: 0/255, blue: 155/255, alpha: 1.0),UIColor(red: 255/255, green: 0/255, blue: 155/255, alpha: 1.0),UIColor(red: 255/255, green: 234/255, blue: 0/255, alpha: 1.0),UIColor(red: 255/255, green: 234/255, blue: 0/255, alpha: 1.0)].map{$0.cgColor}
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0.0, 0.1, 0.5, 0.5, 0.9, 1.0]
        
        
        // Render the gradient to UIImage
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
   //MARK:- SegmentController
    func segmentContoller(segment: UISegmentedControl){
        
        segment.frame = CGRect(x:segment.frame.origin.x, y: segment.frame.origin.y-27,width: segment.frame.size.width, height: 50)
           
            segment.addTarget(self, action:#selector(self.segmentAction(_:)), for:.valueChanged)
            segment.layer.cornerRadius = 25
            
            segment.layer.borderWidth = 0.1
            segment.layer.borderColor = UIColor.clear.cgColor
            segment.layer.masksToBounds = true
            
            
            segment.setBackgroundImage(imageWithColor(color:UIColor.white), for: .normal, barMetrics: .default)
            segment.setBackgroundImage(imagewithgradian(), for: .selected, barMetrics: .default)
            segment.setDividerImage(imageWithColor(color: UIColor.white), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
       
        if  UIFont(name:"alte-din-1451-mittelschrift.regular", size: 16) != nil{
            
            let segAttributesNormal: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor(red: 24/255, green: 17/255, blue: 78/255, alpha: 1.0),  NSAttributedString.Key.font:UIFont(name:"alte-din-1451-mittelschrift.regular", size: 16)!]
            
            segment.setTitleTextAttributes(segAttributesNormal, for: UIControl.State.selected)
            
            let segAttributesSelected: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.foregroundColor: UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1.0),
                NSAttributedString.Key.font: UIFont(name:"alte-din-1451-mittelschrift.regular", size: 16)!
            ]
            
            segment.setTitleTextAttributes(segAttributesSelected, for: UIControl.State.normal)
        }else {
            return
        }

}
    //MARK:- Speed 
    func speedDidChange(_ speed: Speed) {
        
        let getspeed = CGFloat(speed)
       
        NotificationCenter.default.post(name: Notification.Name("speedvalue"), object: getspeed)
        }
    
}
