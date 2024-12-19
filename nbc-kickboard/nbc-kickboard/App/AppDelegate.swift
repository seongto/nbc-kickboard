//
//  AppDelegate.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/13/24.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        saveInitialKickboardType()
        setupInitialKickboardData()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func saveInitialKickboardType() {
        CoreDataStack.shared.createKickboardType(name: "basic")
        CoreDataStack.shared.createKickboardType(name: "power")
    }
    
    // MARK: - 킥보드 초기 데이터 동기화 구문
    func setupInitialKickboardData() {
        
        do {
            if try !CoreDataStack.shared.isKickboardInfoSaved() {
                loadInitialData()
            }
        } catch {
            print("Failed to fetch kickboard count: \(error)")
        }
    }
    
    private func loadInitialData() {
        guard let path = Bundle.main.path(forResource: "latitude_longitude", ofType: "json") else {
            print("Failed to load latitude_longitude.json")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        do {
            let jsonData = try Data(contentsOf: url)
            let locations = try JSONDecoder().decode([Location].self, from: jsonData)
            // First fetch all KickboardTypes
            let fetchRequest: NSFetchRequest<KickboardTypeEntity> = KickboardTypeEntity.fetchRequest()
            let kickboardTypes = try CoreDataStack.shared.context.fetch(fetchRequest)
            
            // Create batch insert dictionary array
            let batchInsertRequest = NSBatchInsertRequest(entity: KickboardEntity.entity(), objects: locations.map { location in
                let randomType = kickboardTypes.randomElement()!
                return [
                    "kickboardCode": String((0..<8).map { _ in characters.randomElement()! }),
                    "batteryStatus": Int16.random(in: 20...100),
                    "isRented": false,
                    "latitude": location.latitude,
                    "longitude": location.longitude,
                    "kickboardType": randomType // Pass the actual KickboardType object
                ] as [String : Any]
            })
            
            try CoreDataStack.shared.context.execute(batchInsertRequest)
        } catch {
            print("Failed to seed initial data: \(error)")
        }
    }
    
}

