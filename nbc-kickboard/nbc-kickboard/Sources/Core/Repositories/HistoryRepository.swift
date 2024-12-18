//
//  HistoryRepository.swift
//  nbc-kickboard
//
//  Created by 권승용 on 12/18/24.
//

import Foundation

protocol HistoryRepositoryProtocol {
    func saveHistory(_ history: History) throws
    func fetchAllHistories(of user: User) throws -> [History]
    func deleteAllhistories() throws
}

struct HistoryRepository: HistoryRepositoryProtocol {
    /// 히스토리를 CoreData에 저장합니다.
    /// - Parameter history: 저장할 히스토리 객체
    /// - Throws: CoreData 저장 관련 에러
    func saveHistory(_ history: History) throws {
        try CoreDataStack.shared.createHistory(
            username: history.user.username,
            kickboardCode: history.kickboard.kickboardCode,
            cost: history.cost,
            rentDate: history.rentDate,
            totalRentTime: history.totalRentTime
        )
    }
    
    /// 특정 사용자의 모든 히스토리를 CoreData에서 조회합니다.
    /// - Parameter user: 조회할 사용자 객체
    /// - Returns: 해당 사용자의 모든 히스토리 배열
    /// - Throws: CoreData 조회 관련 에러
    func fetchAllHistories(of user: User) throws -> [History] {
        try CoreDataStack.shared.readAllHistory(of: user.username)
    }
    
    /// 모든 히스토리를 CoreData에서 삭제합니다.
    /// - Throws: CoreData 삭제 관련 에러
    func deleteAllhistories() throws {
        try CoreDataStack.shared.deleteAllHistory()
    }
}
