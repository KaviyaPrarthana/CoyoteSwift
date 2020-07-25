//
//  CoyoteSwift+CoreDataProperties.swift
//  
//
//  Created by Kaviya Prarthana on 01/10/19.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension CoyoteSwift {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoyoteSwift> {
        return NSFetchRequest<CoyoteSwift>(entityName: "CoyoteSwift")
    }

    @NSManaged public var date: Date?
    @NSManaged public var drivingSpeed: String?
    @NSManaged public var maximumSpeed: String?
    @NSManaged public var place: String?
    @NSManaged public var speedType: String?

}
