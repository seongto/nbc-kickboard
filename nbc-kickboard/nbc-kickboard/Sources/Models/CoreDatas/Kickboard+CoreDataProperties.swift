//
//  Kickboard+CoreDataProperties.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/16/24.
//
//

import Foundation
import CoreData


extension Kickboard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Kickboard> {
        return NSFetchRequest<Kickboard>(entityName: "Kickboard")
    }

    @NSManaged public var kickboardCode: String?
    @NSManaged public var isRented: Bool
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var batteryStatus: Int16
    @NSManaged public var kickboardType: KickboardType?
    @NSManaged public var histories: NSSet?

}

// MARK: Generated accessors for histories
extension Kickboard {

    @objc(addHistoriesObject:)
    @NSManaged public func addToHistories(_ value: History)

    @objc(removeHistoriesObject:)
    @NSManaged public func removeFromHistories(_ value: History)

    @objc(addHistories:)
    @NSManaged public func addToHistories(_ values: NSSet)

    @objc(removeHistories:)
    @NSManaged public func removeFromHistories(_ values: NSSet)

}

extension Kickboard : Identifiable {

}
