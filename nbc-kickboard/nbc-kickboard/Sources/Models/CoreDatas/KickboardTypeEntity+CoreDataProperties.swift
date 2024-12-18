//
//  KickboardTypeEntity+CoreDataProperties.swift
//  nbc-kickboard
//
//  Created by 권승용 on 12/18/24.
//
//

import Foundation
import CoreData


extension KickboardTypeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<KickboardTypeEntity> {
        return NSFetchRequest<KickboardTypeEntity>(entityName: "KickboardTypeEntity")
    }

    @NSManaged public var typeName: String?
    @NSManaged public var kickboards: NSSet?

}

// MARK: Generated accessors for kickboards
extension KickboardTypeEntity {

    @objc(addKickboardsObject:)
    @NSManaged public func addToKickboards(_ value: KickboardEntity)

    @objc(removeKickboardsObject:)
    @NSManaged public func removeFromKickboards(_ value: KickboardEntity)

    @objc(addKickboards:)
    @NSManaged public func addToKickboards(_ values: NSSet)

    @objc(removeKickboards:)
    @NSManaged public func removeFromKickboards(_ values: NSSet)

}

extension KickboardTypeEntity : Identifiable {

}
