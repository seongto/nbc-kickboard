//
//  KickboardRepository.swift
//  nbc-kickboard
//
//  Created by 권승용 on 12/18/24.
//

import Foundation

protocol KickboardRepositoryProtocol {
    func saveKickboard(_ kickboard: Kickboard) throws
    func fetchKickboard(by kickboardCode: String) throws -> Kickboard
    func fetchKickboardsInAreaOf(minLat: Double, maxLat: Double, minLng: Double, maxLng: Double) throws -> [Kickboard]
    func updateKickboard(by kickboardCode: String, to newKickboard: Kickboard) throws
    func deleteKickboard(by kickboardCode: String) throws
}

struct KickboardRepository: KickboardRepositoryProtocol {
    /// 킥보드 정보를 저장합니다
    /// - Parameter kickboard: 저장할 킥보드 정보
    func saveKickboard(_ kickboard: Kickboard) throws {
        try CoreDataStack.shared.createKickboard(
            kickboardCode: kickboard.kickboardCode,
            batteryStatus: kickboard.batteryStatus,
            isRented: kickboard.isRented,
            latitude: kickboard.latitude,
            longitude: kickboard.longitude,
            type: kickboard.type
        )
    }
    
    func fetchKickboard(by kickboardCode: String) throws -> Kickboard {
        return try CoreDataStack.shared.readKickboard(kickboardCode: kickboardCode)
    }
    
    func fetchKickboardsInAreaOf(
        minLat: Double,
        maxLat: Double,
        minLng: Double,
        maxLng: Double
    ) throws -> [Kickboard] {
        try CoreDataStack.shared.requestKickboards(minLat: minLat, maxLat: maxLat, minLng: minLng, maxLng: maxLng)
    }
    
    /// kickboardCode에 해당하는 킥보드를 새로운 킥보드 정보로 업데이트 합니다.
    /// 주의 : kickboardCode는 동일하게 유지됩니다.
    /// - Parameters:
    ///   - kickboardCode: 업데이트할 킥보드의 코드
    ///   - newKickboard: 새로운 킥보드 정보
    func updateKickboard(by kickboardCode: String, to newKickboard: Kickboard) throws {
        try CoreDataStack.shared.updateKickboard(
            kickboardCode: kickboardCode,
            batteryStatus: newKickboard.batteryStatus,
            isRented: newKickboard.isRented,
            latitude: newKickboard.latitude,
            longitude: newKickboard.longitude,
            type: newKickboard.type
        )
    }
    
    /// kickboardCode에 해당하는 킥보드를 삭제합니다.
    /// - Parameter kickboardCode: 삭제할 킥보드의 킥보드 코드
    func deleteKickboard(by kickboardCode: String) throws {
        try CoreDataStack.shared.deleteKickboard(kickboardCode: kickboardCode)
    }
}
