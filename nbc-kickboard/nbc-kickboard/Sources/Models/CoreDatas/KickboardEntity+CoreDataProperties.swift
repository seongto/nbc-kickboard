//
//  KickboardEntity+CoreDataProperties.swift
//  nbc-kickboard
//
//  Created by 권승용 on 12/16/24.
//
//

import Foundation
import CoreData


extension KickboardEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<KickboardEntity> {
        return NSFetchRequest<KickboardEntity>(entityName: "KickboardEntity")
    }

    @NSManaged public var batteryStatus: Int16
    @NSManaged public var isRented: Bool
    @NSManaged public var kickboardCode: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var histories: NSSet?
    @NSManaged public var kickboardType: KickboardTypeEntity?
    
    enum Key {
        static let batteryStatus = "batteryStatus"
        static let isRented = "isRented"
        static let kickboardCode = "kickboardCode"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let histories = "histories"
        static let kickboardType = "kickboardType"
    }
}

// MARK: Generated accessors for histories
extension KickboardEntity {

    @objc(addHistoriesObject:)
    @NSManaged public func addToHistories(_ value: HistoryEntity)

    @objc(removeHistoriesObject:)
    @NSManaged public func removeFromHistories(_ value: HistoryEntity)

    @objc(addHistories:)
    @NSManaged public func addToHistories(_ values: NSSet)

    @objc(removeHistories:)
    @NSManaged public func removeFromHistories(_ values: NSSet)

}

extension KickboardEntity : Identifiable {

}
