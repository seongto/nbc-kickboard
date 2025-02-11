//
//  UserEntity+CoreDataClass.swift
//  nbc-kickboard
//
//  Created by 권승용 on 12/16/24.
//
//

import Foundation
import CoreData

@objc(UserEntity)
public class UserEntity: NSManagedObject {
    enum Key {
        static let isAdmin = "isAdmin"
        static let password = "password"
        static let username = "username"
        static let histories = "histories"
    }
}
