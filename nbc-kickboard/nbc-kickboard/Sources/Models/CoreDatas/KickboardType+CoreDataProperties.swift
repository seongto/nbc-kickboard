//
//  KickboardType+CoreDataProperties.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/16/24.
//
//

import Foundation
import CoreData


extension KickboardType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<KickboardType> {
        return NSFetchRequest<KickboardType>(entityName: "KickboardType")
    }

    @NSManaged public var typeName: String?
    @NSManaged public var kickboards: NSSet?

}

// MARK: Generated accessors for kickboards
extension KickboardType {

    @objc(addKickboardsObject:)
    @NSManaged public func addToKickboards(_ value: Kickboard)

    @objc(removeKickboardsObject:)
    @NSManaged public func removeFromKickboards(_ value: Kickboard)

    @objc(addKickboards:)
    @NSManaged public func addToKickboards(_ values: NSSet)

    @objc(removeKickboards:)
    @NSManaged public func removeFromKickboards(_ values: NSSet)

}

extension KickboardType : Identifiable {

}
