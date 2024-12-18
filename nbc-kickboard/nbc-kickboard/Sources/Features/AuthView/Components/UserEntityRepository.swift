//
//  UserRepository.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/17/24.
//

import Foundation
import CoreData

protocol UserEntityRepositoryProtocol {
    func createUser(username: String, password: String, isAdmin: Bool) -> UserEntity?
    func fetchUser(by username: String) -> UserEntity?
    func fetchAllUsers() -> [UserEntity]
    func updatePassword(user: UserEntity, oldPassword: String, newPassword: String)
    func deleteUser(user: UserEntity)
    func softDeleteUser(user: UserEntity)
}


final class UserEntityRepository: UserEntityRepositoryProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }
    
    /// coredata에 수정사항을 반영하기
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("context save에 실패하였습니다. : \(error)")
        }
    }
    
    
    // MARK: - CRUD
    
    /// 새로운 사용자 생성
    /// - Parameters:
    ///   - username: 사용자의 이용아이디. 고유값을 가진다.
    ///   - password: 문자열로 받아 이를 해쉬화암호로 변경하고 저장
    ///   - isAdmin: 관리자 아이디인지 여부 결정.
    /// - Returns: 새로운 사용자 생성 후 해당 사용자 객체를 리턴.
    func createUser(username: String, password: String, isAdmin: Bool) -> UserEntity? {
        let newUser = UserEntity(context: context)
        
        // 1. name 유효성 검사
        
        
        // 2. name 중복검사
        
        
        // 3. 패스워드 유효성 검사
        
        
        // 4. 암호 해쉬화
        let hashedPassword: String = ""
        
        // 5. 저장하기
        newUser.username = username
        newUser.isAdmin = isAdmin
        newUser.password = hashedPassword
        
        print("before: \(newUser)")
        saveContext()
        print("after: \(newUser)")
        
        // 6. 이름으로 검색해서 정보 가져오기 : 제대로 저장되었는지 판단하고 암호 제외하기 위함.
        let fetchedUser = fetchUser(by: username)
        
        return fetchedUser
    }
    
    /// username이 일치하는 사용자 정보 가져오기(암호 제외)
    /// - Parameter username: 고유한 사용자의 이용아이디
    /// - Returns: 입력한 아이디와 일치하는 UserEntity 객체를 반환.
    func fetchUser(by username: String) -> UserEntity? {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %0", username as CVarArg)
        
        fetchRequest.resultType = .managedObjectResultType
        fetchRequest.propertiesToFetch = ["username", "isAdmin", "histories"]
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("사용자 정보가 없습니다. : \(error)")
            return nil
        }
    }
    
    /// 서비스의 모든 이용자 가져오기
    /// - Returns: 모든 이용자의 이름과 관리자 여부 데이터 가져오기.
    func fetchAllUsers() -> [UserEntity] {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.resultType = .managedObjectResultType
        fetchRequest.propertiesToFetch = ["username", "isAdmin"]

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("사용자 정보가 없습니다. :\(error)")
            return []
        }
    }
    
    /// 비밀번호 업데이트. 현재 user 객체에 암호는 없으므로 기존 암호를 입력받아 처리해야함.
    /// - Parameters:
    ///   - user: 변경하고자 하는 사용자 데이터
    ///   - oldPassword: 기존에 사용 중이던 암호
    ///   - newPassword: 새로운 암호
    func updatePassword(user: UserEntity, oldPassword: String, newPassword: String) {
        // 1. 기존 패스워드 일치하는지 검사 (기존 암호 해쉬화 후 coredata에 저장된 데이터와 비교)
        
        // 2. 신규 패스워드 유효성 검사
        
        // 3. 신규 패스워드 해쉬화
        let hashedPassword: String = ""

        user.setValue( hashedPassword, forKey: "password")
        saveContext()
    }
    
    /// 사용자 정보를 삭제
    /// - Parameter user: 삭제하고자 하는 사용자
    func deleteUser(user: UserEntity) {
        context.delete(user)
        saveContext()
    }
    
    /// 사용자 정보를 soft delete 처리. 추후 timestamp 추가 후 deletedAt 에 현재 시간 정보 입력하는 방식
    /// - Parameter user: 삭제하고자 하는 사용자.
    func softDeleteUser(user: UserEntity) {
        
    }
}



/*
 Question
 
 1. 프로토콜을 적용했을 경우 각 메소드에 대한 주석은 어디에 작성하는 게 좋을까?
 2. CoreDataStack의 saveContext() 메소드에 관하여.
 
 */
