//
//  CoreDataStackTests.swift
//  nbc-kickboard
//
//  Created by 권승용 on 12/18/24.
//

import Testing
import CoreData
@testable import nbc_kickboard

@MainActor
final class CoreDataStackTests {
    var sut: CoreDataStack
    
    init() {
        sut = CoreDataStack.shared
        CoreDataStack.shared.createKickboardType(name: "basic")
        CoreDataStack.shared.createKickboardType(name: "power")
    }
    
    deinit {
        do {
            try sut.deleteAll()
        } catch {
            print("error")
        }
    }
    
    // MARK: - User Tests
    
    @MainActor
    @Test
    func createAndReadUser() throws {
        // Given
        let testUsername = "testUser"
        let testPassword = "password123"
        let testIsAdmin = false
        
        // When
        sut.createUser(name: testUsername, password: testPassword, isAdmin: testIsAdmin)
        let user = try sut.readUser(name: testUsername)
        
        // Then
        #expect(user.username == testUsername)
        #expect(user.isAdmin == false)
    }
    
    @MainActor
    @Test
    func updateUser() throws {
        // Given
        let testUsername = "testUser"
        let testPassword = "password123"
        let testIsAdmin = false
        sut.createUser(name: testUsername, password: testPassword, isAdmin: testIsAdmin)
        
        // When
        try sut.updateUser(name: testUsername, password: "newPassword", isAdmin: true)
        let updatedUser = try sut.readUser(name: testUsername)
        
        // Then
        #expect(updatedUser.isAdmin == true)
    }
    
    @MainActor
    @Test
    func deleteUser() throws {
        // Given
        let testUsername = "testUser"
        let testPassword = "password123"
        let testIsAdmin = false
        sut.createUser(name: testUsername, password: testPassword, isAdmin: testIsAdmin)
        
        // When
        try sut.deleteUser(name: testUsername)
        
        // Then
        #expect(throws: AppError.CoreDataStackError.noMatchingItem) {
            try sut.readUser(name: testUsername)
        }
    }
    
    // MARK: - Kickboard Tests
    
    @MainActor
    @Test
    func createAndReadKickboard() throws {
        // Given
        let testCode = "KB001"
        let testBattery: Int16 = 100
        let testIsRented = false
        let testLatitude = 37.5665
        let testLongitude = 126.9780
        let testType: KickboardType = .basic
        
        // When
        try sut.createKickboard(
            kickboardCode: testCode,
            batteryStatus: testBattery,
            isRented: testIsRented,
            latitude: testLatitude,
            longitude: testLongitude,
            type: testType
        )
        let kickboard = try sut.readKickboard(kickboardCode: testCode)
        
        // Then
        #expect(kickboard.kickboardCode == testCode)
        #expect(kickboard.batteryStatus == testBattery)
        #expect(kickboard.isRented == testIsRented)
        #expect(kickboard.latitude == testLatitude)
        #expect(kickboard.longitude == testLongitude)
        #expect(kickboard.type == testType)
    }
    
    @MainActor
    @Test
    func updateKickboard() throws {
        // Given
        let testCode = "KB001"
        try sut.createKickboard(
            kickboardCode: testCode,
            batteryStatus: 100,
            isRented: false,
            latitude: 37.5665,
            longitude: 126.9780,
            type: .basic
        )
        
        // When
        try sut.updateKickboard(
            kickboardCode: testCode,
            batteryStatus: 90,
            isRented: true,
            latitude: 37.5666,
            longitude: 126.9781,
            type: .power
        )
        let updatedKickboard = try sut.readKickboard(kickboardCode: testCode)
        
        // Then
        #expect(updatedKickboard.batteryStatus == 90)
        #expect(updatedKickboard.isRented == true)
        #expect(updatedKickboard.latitude == 37.5666)
        #expect(updatedKickboard.longitude == 126.9781)
        #expect(updatedKickboard.type == .power)
    }
    
    @MainActor
    @Test
    func deleteKickboard() throws {
        // Given
        let testCode = "KB001"
        try sut.createKickboard(
            kickboardCode: testCode,
            batteryStatus: 100,
            isRented: false,
            latitude: 37.5665,
            longitude: 126.9780,
            type: .basic
        )
        
        // When
        try sut.deleteKickboard(kickboardCode: testCode)
        
        // Then
        #expect(throws: AppError.CoreDataStackError.noMatchingItem) {
            try sut.readKickboard(kickboardCode: testCode)
        }
    }
    
    @MainActor
    @Test
    func createAndReadHistory() throws {
        // Given
        let testUsername = "testUser"
        let testPassword = "password123"
        let testKickboardCode = "KB001"
        
        // Create prerequisite data
        sut.createUser(name: testUsername, password: testPassword, isAdmin: false)
        try sut.createKickboard(
            kickboardCode: testKickboardCode,
            batteryStatus: 100,
            isRented: false,
            latitude: 37.5665,
            longitude: 126.9780,
            type: .basic
        )
        
        let testCost: Int16 = 5000
        let testRentDate = Date()
        let testTotalRentTime: Int16 = 30
        
        // When
        try sut.createHistory(
            username: testUsername,
            kickboardCode: testKickboardCode,
            cost: testCost,
            rentDate: testRentDate,
            totalRentTime: testTotalRentTime
        )
        let histories = try sut.readAllHistory(of: testUsername)
        
        // Then
        #expect(histories.count == 1)
        #expect(histories[0].cost == testCost)
        #expect(histories[0].totalRentTime == testTotalRentTime)
        #expect(histories[0].user.username == testUsername)
        #expect(histories[0].kickboard.kickboardCode == testKickboardCode)
    }
    
    @MainActor
    @Test
    func deleteAllHistory() throws {
        // Given
        let testUsername = "testUser"
        let testPassword = "password123"
        let testKickboardCode = "KB001"
        
        sut.createUser(name: testUsername, password: testPassword, isAdmin: false)
        try sut.createKickboard(
            kickboardCode: testKickboardCode,
            batteryStatus: 100,
            isRented: false,
            latitude: 37.5665,
            longitude: 126.9780,
            type: .basic
        )
        
        try sut.createHistory(
            username: testUsername,
            kickboardCode: testKickboardCode,
            cost: 5000,
            rentDate: Date(),
            totalRentTime: 30
        )
        
        // When
        try sut.deleteAllHistory()
        let histories = try sut.readAllHistory(of: testUsername)
        
        // Then
        #expect(histories.isEmpty)
    }
    
    // MARK: - KickboardType Tests
    
    @MainActor
    @Test
    func createKickboardType() throws {
        // Given
        let testTypeName = "test_type"
        
        // When
        sut.createKickboardType(name: testTypeName)
        
        // Then
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "KickboardTypeEntity")
        fetchRequest.predicate = NSPredicate(format: "typeName == %@", testTypeName)
        let result = try sut.persistentContainer.viewContext.fetch(fetchRequest)
        
        #expect(!result.isEmpty)
        #expect(result[0].value(forKey: KickboardTypeEntity.Key.typeName) as? String == testTypeName)
    }
    
    @MainActor
    @Test
    func deleteAllKickboardType() throws {
        // Given
        let testTypeName = "test_type"
        sut.createKickboardType(name: testTypeName)
        
        // When
        try sut.deleteAllKickboardType()
        
        // Then
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "KickboardTypeEntity")
        let result = try sut.persistentContainer.viewContext.fetch(fetchRequest)
        
        #expect(result.isEmpty)
    }
}
