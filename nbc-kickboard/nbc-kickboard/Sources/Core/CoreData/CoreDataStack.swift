//
//  CoreDataStack.swift
//  nbc-kickboard
//
//  Created by 권승용 on 12/18/24.
//

import Foundation
import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    
    var persistentContainer: NSPersistentContainer
    var context: NSManagedObjectContext
    
    private init() {
        let container = NSPersistentContainer(name: "nbc_kickboard")
        
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        
        persistentContainer = container
        context = container.viewContext
    }
    
    func save() {
        guard persistentContainer.viewContext.hasChanges else { return }
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save the context:", error.localizedDescription)
        }
    }
    
    func deleteAll() throws {
        try deleteAllUsers()
        try deleteAllKickboards()
        try deleteAllKickboardType()
        try deleteAllHistory()
    }
}

// MARK: - UserEntity CRUD

extension CoreDataStack {
    func createUser(name: String, password: String, isAdmin: Bool) {
        guard let entity = NSEntityDescription.entity(forEntityName: "UserEntity", in: persistentContainer.viewContext) else {
            return
        }
        
        let newUser = NSManagedObject(entity: entity, insertInto: self.persistentContainer.viewContext)
        newUser.setValue(name, forKey: UserEntity.Key.username)
        newUser.setValue(password, forKey: UserEntity.Key.password)
        newUser.setValue(isAdmin, forKey: UserEntity.Key.isAdmin)
        // 새로운 유저 생성 시 빈 history 생성
        newUser.setValue(Set<HistoryEntity>(), forKey: UserEntity.Key.histories)
        save()
    }
    
    func readAllUsers() throws -> [User] {
        var result: [User] = []
        let fetchRequest = UserEntity.fetchRequest()
        
        let userEntities = try persistentContainer.viewContext.fetch(fetchRequest)
        for userEntity in userEntities as [NSManagedObject] {
            if let username = userEntity.value(forKey: UserEntity.Key.username) as? String,
               let isAdmin = userEntity.value(forKey: UserEntity.Key.isAdmin) as? Bool {
                let newUser = User(username: username, isAdmin: isAdmin)
                result.append(newUser)
            }
        }
        return result
    }
    
    func readUser(name: String) throws -> User {
        let fetchRequest = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", name)
        
        guard let userEntity = try persistentContainer.viewContext.fetch(fetchRequest).first else {
            throw AppError.CoreDataStackError.noMatchingItem
        }
        if let username = userEntity.value(forKey: UserEntity.Key.username) as? String,
           let isAdmin = userEntity.value(forKey: UserEntity.Key.isAdmin) as? Bool {
            let newUser = User(username: username, isAdmin: isAdmin)
            return newUser
        } else {
            throw AppError.CoreDataStackError.dataTransformationFailed
        }
    }
    
    /// 로그인 시 유저 검증
    /// - Parameters:
    ///   - name: 사용자가 입력한 username
    ///   - hashedPassword: 사용자가 입력한 비밀번호의 암호화 결과
    /// - Returns: 일치하는 유저가 있다면 User, 없다면 nil
    func authenticateUser(name: String, hashedPassword: String) throws -> User? {
        let fetchRequest = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND password == %@", name, hashedPassword)
        
        guard let userEntity = try persistentContainer.viewContext.fetch(fetchRequest).first else {
            return nil
        }
        if let username = userEntity.value(forKey: UserEntity.Key.username) as? String,
           let isAdmin = userEntity.value(forKey: UserEntity.Key.isAdmin) as? Bool {
            let newUser = User(username: username, isAdmin: isAdmin)
            return newUser
        } else {
            throw AppError.CoreDataStackError.dataTransformationFailed
        }
    }
    
    func updateUser(name: String, password: String, isAdmin: Bool) throws {
        let fetchRequest = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", name)
        
        if let result = try persistentContainer.viewContext.fetch(fetchRequest).first {
            result.setValue(password, forKey: UserEntity.Key.password)
            result.setValue(isAdmin, forKey: UserEntity.Key.isAdmin)
            save()
        }
    }
    
    func deleteUser(name: String) throws {
        let request = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@", name)
        
        if let result = try self.persistentContainer.viewContext.fetch(request).first {
            persistentContainer.viewContext.delete(result)
            save()
        }
    }
    
    func deleteAllUsers() throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        try persistentContainer.viewContext.execute(deleteRequest)
        save()
    }
}

// MARK: - Kickboard Entity CRUD

extension CoreDataStack {
    func createKickboard(
        kickboardCode: String,
        batteryStatus: Int16,
        isRented: Bool,
        latitude: Double,
        longitude: Double,
        type: KickboardType
    ) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: "KickboardEntity", in: persistentContainer.viewContext) else {
            return
        }
        
        let newKickboard = NSManagedObject(entity: entity, insertInto: self.persistentContainer.viewContext)
        newKickboard.setValue(kickboardCode, forKey: KickboardEntity.Key.kickboardCode)
        newKickboard.setValue(batteryStatus, forKey: KickboardEntity.Key.batteryStatus)
        newKickboard.setValue(isRented, forKey: KickboardEntity.Key.isRented)
        newKickboard.setValue(latitude, forKey: KickboardEntity.Key.latitude)
        newKickboard.setValue(longitude, forKey: KickboardEntity.Key.longitude)
        newKickboard.setValue(Set<HistoryEntity>(), forKey: KickboardEntity.Key.histories)
        
        let kickboardTypeEntity = try findKickboardTypeEntity(with: type.rawValue)
        newKickboard.setValue(kickboardTypeEntity, forKey: KickboardEntity.Key.kickboardType)
        save()
    }
    
    func readKickboard(kickboardCode: String) throws -> Kickboard {
        let fetchRequest = KickboardEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "kickboardCode == %@", kickboardCode)
        
        guard let kickboardEntity = try self.persistentContainer.viewContext.fetch(fetchRequest).first else {
            throw AppError.CoreDataStackError.noMatchingItem
        }
        if let batteryStatus = kickboardEntity.value(forKey: KickboardEntity.Key.batteryStatus) as? Int16,
           let isRented = kickboardEntity.value(forKey: KickboardEntity.Key.isRented) as? Bool,
           let latitude = kickboardEntity.value(forKey: KickboardEntity.Key.latitude) as? Double,
           let longitude = kickboardEntity.value(forKey: KickboardEntity.Key.longitude) as? Double,
           let kickboardTypeEntity = kickboardEntity.value(forKey: KickboardEntity.Key.kickboardType) as? KickboardTypeEntity,
           let typeName = kickboardTypeEntity.value(forKey: KickboardTypeEntity.Key.typeName) as? String {
            return Kickboard(
                longitude: longitude,
                latitude: latitude,
                kickboardCode: kickboardCode,
                isRented: isRented,
                batteryStatus: batteryStatus,
                type: KickboardType(rawValue: typeName) ?? .basic
            )
        } else {
            throw AppError.CoreDataStackError.dataTransformationFailed
        }
    }
    
    func updateKickboard(
        kickboardCode: String,
        batteryStatus: Int16,
        isRented: Bool,
        latitude: Double,
        longitude: Double,
        type: KickboardType
    ) throws {
        let fetchRequest = KickboardEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "kickboardCode == %@", kickboardCode)
        
        if let result = try self.persistentContainer.viewContext.fetch(fetchRequest).first {
            result.setValue(batteryStatus, forKey: KickboardEntity.Key.batteryStatus)
            result.setValue(isRented, forKey: KickboardEntity.Key.isRented)
            result.setValue(latitude, forKey: KickboardEntity.Key.latitude)
            result.setValue(longitude, forKey: KickboardEntity.Key.longitude)
            let kickboardTypeEntity = try findKickboardTypeEntity(with: type.rawValue)
            result.setValue(kickboardTypeEntity, forKey: KickboardEntity.Key.kickboardType)
            save()
        }
    }
    
    func deleteKickboard(kickboardCode: String) throws {
        let fetchRequest = KickboardEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "kickboardCode == %@", kickboardCode)
        
        guard let result = try self.persistentContainer.viewContext.fetch(fetchRequest).first else {
            throw AppError.CoreDataStackError.noMatchingItem
        }
        persistentContainer.viewContext.delete(result)
        save()
    }
    
    func deleteAllKickboards() throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "KickboardEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        try persistentContainer.viewContext.execute(deleteRequest)
        save()
    }
}

// MARK: - KickboardType CRUD

extension CoreDataStack {
    func createKickboardType(name: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: "KickboardTypeEntity", in: persistentContainer.viewContext) else {
            return
        }
        
        let newType = NSManagedObject(entity: entity, insertInto: self.persistentContainer.viewContext)
        newType.setValue(name, forKey: KickboardTypeEntity.Key.typeName)
        newType.setValue(Set<KickboardEntity>(), forKey: KickboardTypeEntity.Key.kickboards)
        
        save()
    }
    
    func deleteAllKickboardType() throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "KickboardTypeEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        try persistentContainer.viewContext.execute(deleteRequest)
        save()
    }
}

// MARK: - History CRUD

extension CoreDataStack {
    func createHistory(
        username: String,
        kickboardCode: String,
        cost: Int16,
        rentDate: Date,
        totalRentTime: Int16
    ) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: "HistoryEntity", in: persistentContainer.viewContext) else {
            return
        }
        
        guard let userEntity = try findUserEntity(with: username) else {
            throw AppError.CoreDataStackError.noMatchingItem
        }
        
        guard let kickboardEntity = try findKickboardEntity(with: kickboardCode) else {
            throw AppError.CoreDataStackError.noMatchingItem
        }
        
        // many to one
        let newHistory = NSManagedObject(entity: entity, insertInto: self.persistentContainer.viewContext)
        newHistory.setValue(cost, forKey: HistoryEntity.Key.cost)
        newHistory.setValue(rentDate, forKey: HistoryEntity.Key.rentDate)
        newHistory.setValue(totalRentTime, forKey: HistoryEntity.Key.totalRentTime)
        newHistory.setValue(userEntity, forKey: HistoryEntity.Key.user)
        newHistory.setValue(kickboardEntity, forKey: HistoryEntity.Key.kickboard)
        
        // Update the relationships
        if var userHistories = userEntity.value(forKey: UserEntity.Key.histories) as? Set<HistoryEntity> {
            userHistories.insert(newHistory as! HistoryEntity)
            userEntity.setValue(userHistories, forKey: UserEntity.Key.histories)
        }
        
        if var kickboardHistories = kickboardEntity.value(forKey: KickboardEntity.Key.histories) as? Set<HistoryEntity> {
            kickboardHistories.insert(newHistory as! HistoryEntity)
            kickboardEntity.setValue(kickboardHistories, forKey: KickboardEntity.Key.histories)
        }
        
        save()
    }
    
    func readAllHistory(of username: String) throws -> [History] {
        var result: [History] = []
        let fetchRequest = HistoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user.username == %@", username)
        
        let historyEntities = try persistentContainer.viewContext.fetch(fetchRequest)
        for historyEntity in historyEntities {
            if let cost = historyEntity.value(forKey: HistoryEntity.Key.cost) as? Int16,
               let rentDate = historyEntity.value(forKey: HistoryEntity.Key.rentDate) as? Date,
               let totalRentTime = historyEntity.value(forKey: HistoryEntity.Key.totalRentTime) as? Int16,
               
                let kickboardEntity = historyEntity.value(forKey: HistoryEntity.Key.kickboard) as? KickboardEntity,
               let kickboardCode = kickboardEntity.value(forKey: KickboardEntity.Key.kickboardCode) as? String,
               let batteryStatus = kickboardEntity.value(forKey: KickboardEntity.Key.batteryStatus) as? Int16,
               let isRented = kickboardEntity.value(forKey: KickboardEntity.Key.isRented) as? Bool,
               let latitude = kickboardEntity.value(forKey: KickboardEntity.Key.latitude) as? Double,
               let longitude = kickboardEntity.value(forKey: KickboardEntity.Key.longitude) as? Double,
               
                let kickboardTypeEntity = kickboardEntity.value(forKey: KickboardEntity.Key.kickboardType) as? KickboardTypeEntity,
               let typeName = kickboardTypeEntity.value(forKey: KickboardTypeEntity.Key.typeName) as? String,
               
                let userEntity = historyEntity.value(forKey: HistoryEntity.Key.user) as? UserEntity,
               let username = userEntity.value(forKey: UserEntity.Key.username) as? String,
               let isAdmin = userEntity.value(forKey: UserEntity.Key.isAdmin) as? Bool {
                
                let history = History(
                    cost: cost,
                    rentDate: rentDate,
                    totalRentTime: totalRentTime,
                    kickboard: Kickboard(
                        longitude: longitude,
                        latitude: latitude,
                        kickboardCode: kickboardCode,
                        isRented: isRented,
                        batteryStatus: batteryStatus,
                        type: KickboardType(rawValue: typeName) ?? .basic
                    ),
                    user: User(
                        username: username,
                        isAdmin: isAdmin
                    )
                )
                result.append(history)
            }
        }
        return result
    }
    
    func deleteAllHistory() throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HistoryEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        try persistentContainer.viewContext.execute(deleteRequest)
        save()
    }
}

// MARK: - Helper Functions

private extension CoreDataStack {
    func findUserEntity(with username: String) throws -> UserEntity? {
        let fetchRequest = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)
        
        if let result = try persistentContainer.viewContext.fetch(fetchRequest).first {
            return result
        } else {
            return nil
        }
    }
    
    func findKickboardEntity(with kickboardCode: String) throws -> KickboardEntity? {
        let fetchRequest = KickboardEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "kickboardCode == %@", kickboardCode)
        
        if let result = try persistentContainer.viewContext.fetch(fetchRequest).first {
            return result
        } else {
            return nil
        }
    }
    
    func findKickboardTypeEntity(with typeName: String) throws -> KickboardTypeEntity? {
        let fetchRequest = KickboardTypeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "typeName == %@", typeName)
        
        if let result = try persistentContainer.viewContext.fetch(fetchRequest).first {
            return result
        } else {
            return nil
        }
    }
}

extension CoreDataStack {
    func isKickboardInfoSaved() throws -> Bool {
        let fetchRequest = KickboardEntity.fetchRequest()
        
        if let _ = try persistentContainer.viewContext.fetch(fetchRequest).first {
            return true
        } else {
            return false
        }
    }
    
    func requestKickboards(minLat: Double, maxLat: Double, minLng: Double, maxLng: Double) throws -> [Kickboard] {
        let request = KickboardEntity.fetchRequest()
        
        request.predicate = NSPredicate(
            format: "latitude >= %f AND latitude <= %f AND longitude >= %f AND longitude <= %f",
            minLat, maxLat, minLng, maxLng
        )
        
        let results = try persistentContainer.viewContext.fetch(request)
        let kickboards = results.map {
            Kickboard(
                longitude: $0.longitude,
                latitude: $0.latitude,
                kickboardCode: $0.kickboardCode ?? "",
                isRented: $0.isRented,
                batteryStatus: $0.batteryStatus,
                type: KickboardType(rawValue: $0.kickboardType?.typeName ?? "basic") ?? .basic
            )
        }
        return kickboards
    }
}
