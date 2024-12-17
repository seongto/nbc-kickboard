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
        setupInitialKickboardData()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    
    // MARK: - 킥보드 초기 데이터 동기화 구문
    func setupInitialKickboardData() {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<KickboardEntity> = KickboardEntity.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
            if count == 0 {
                loadInitialData(context: context)
            }
        } catch {
            print("Failed to fetch kickboard count: \(error)")
        }
    }
    
    private func loadInitialData(context: NSManagedObjectContext) {
        guard let path = Bundle.main.path(forResource: "latitude_longitude", ofType: "json") else {
            print("Failed to load latitude_longitude.json")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        do {
            let jsonData = try Data(contentsOf: url)
            let locations = try JSONDecoder().decode([Location].self, from: jsonData)
            
            for location in locations {
                let entity = KickboardEntity(context: context)
                entity.latitude = location.latitude
                entity.longitude = location.longitude
                entity.batteryStatus = Int16.random(in: 20...100)
                entity.isRented = false
                entity.kickboardCode = String((0..<8).map { _ in
                    characters.randomElement()!
                })
            }
            
            try context.save()
        } catch {
            print("Failed to seed initial data: \(error)")
        }
    }
    
}

