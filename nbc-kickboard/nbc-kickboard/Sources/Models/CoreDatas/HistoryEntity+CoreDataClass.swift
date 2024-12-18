//
//  HistoryEntity+CoreDataClass.swift
//  nbc-kickboard
//
//  Created by 권승용 on 12/16/24.
//
//

import Foundation
import CoreData

@objc(HistoryEntity)
public class HistoryEntity: NSManagedObject {
    enum Key {
        static let cost = "cost"
        static let rentDate = "rentDate"
        static let totalRentTime = "totalRentTime"
        static let kickboard = "kickboard"
        static let user = "user"
    }
}
