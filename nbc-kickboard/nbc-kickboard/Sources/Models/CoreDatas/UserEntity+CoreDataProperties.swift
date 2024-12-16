//
//  UserEntity+CoreDataProperties.swift
//  nbc-kickboard
//
//  Created by 권승용 on 12/16/24.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var isAdmin: Bool
    @NSManaged public var password: String?
    @NSManaged public var username: String?
    @NSManaged public var histories: NSSet?

}

// MARK: Generated accessors for histories
extension UserEntity {

    @objc(addHistoriesObject:)
    @NSManaged public func addToHistories(_ value: HistoryEntity)

    @objc(removeHistoriesObject:)
    @NSManaged public func removeFromHistories(_ value: HistoryEntity)

    @objc(addHistories:)
    @NSManaged public func addToHistories(_ values: NSSet)

    @objc(removeHistories:)
    @NSManaged public func removeFromHistories(_ values: NSSet)

}

extension UserEntity : Identifiable {

}
