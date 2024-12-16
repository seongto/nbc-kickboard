//
//  History+CoreDataProperties.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/16/24.
//
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var totalRentTime: Int16
    @NSManaged public var cost: Int16
    @NSManaged public var rentDate: Date?
    @NSManaged public var user: User?
    @NSManaged public var kickboard: Kickboard?

}

extension History : Identifiable {

}
