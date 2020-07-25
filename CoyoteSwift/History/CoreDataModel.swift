//
//  CoreDataModel.swift
//  CoyoteSwift
//
//  Created by Kaviya Prarthana on 19/08/19.
//  Copyright © 2019 Kaviya Prarthana. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataModel : NSObject{
    
    let speedCalculation = SpeedCalculation.speedShared
    let locationName = Location.shared
    
    static let coreDataShared = CoreDataModel()
    var tableData:[DetailList] = []
    
    
    private var container: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "CoyoteSwift")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError?
            {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return persistentContainer
    }()
    
    // MARK: - context
    var context:NSManagedObjectContext {
        return self.container.viewContext
    }
    
    // MARK: - CoreDataSave
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            }catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
   
    //MARK:- Fetch
    func getProfileData()-> [DetailList] {
        let request:NSFetchRequest<DetailList> = DetailList.fetchRequest()
        let sortByIdentifier = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortByIdentifier]
        self.tableData = try! context.fetch(request)
        
        return self.tableData
    }
    
    //MARK: - AddDetails
    func adddetailsDatabase(drivingSpeed:String,maximumSpeed: String,  date: String, distancetype: String, place: String){
        
        do{
            let newState = DetailList(context:context)
            newState.place = locationName.placeName
            newState.drivingSpeed =  String(format:"%f", speedCalculation.currentSpeed)
            newState.maximumSpeed =  speedCalculation.maxSpeed
            newState.date = self.speedCalculation.dateString
            newState.speedType = distancetype
            try context.save()
            
        } catch {
            //do nothing
        }
        
    }  
}
