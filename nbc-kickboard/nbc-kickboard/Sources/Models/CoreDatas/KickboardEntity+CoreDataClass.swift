//
//  KickboardEntity+CoreDataClass.swift
//  nbc-kickboard
//
//  Created by 권승용 on 12/16/24.
//
//

import Foundation
import CoreData

@objc(KickboardEntity)
public class KickboardEntity: NSManagedObject {
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
