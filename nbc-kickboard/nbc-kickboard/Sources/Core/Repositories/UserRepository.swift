//
//  UserRepository.swift
//  nbc-kickboard
//
//  Created by 권승용 on 12/18/24.
//

import Foundation

protocol UserRepositoryProtocol {
    func saveUser(username: String, password: String, isAdmin: Bool)
    func fetchUser(by username: String) throws -> User
    func authenticateUser(by username: String, hashedPassword: String) throws -> User?
    func updateUserPassword(of user: User, newPassword: String) throws
    func deleteUser(by username: String) throws
}

struct UserRepository {
    /// 새로운 사용자를 저장하는 함수
    /// - Parameters:
    ///   - username: 사용자 이름
    ///   - password: 사용자 비밀번호
    ///   - isAdmin: 관리자 여부
    func saveUser(username: String, password: String, isAdmin: Bool) {
        CoreDataStack.shared.createUser(
            name: username,
            password: password,
            isAdmin: isAdmin
        )
    }
    
    /// 사용자 이름으로 사용자를 조회하는 함수
    /// - Parameter username: 조회할 사용자 이름
    /// - Returns: 조회된 사용자 객체
    /// - Throws: 사용자를 찾을 수 없는 경우 에러 발생
    func fetchUser(by username: String) throws -> User {
        return try CoreDataStack.shared.readUser(name: username)
    }
    
    /// 사용자의 인증을 처리하는 함수
    /// - Parameters:
    ///   - username: 인증할 사용자 이름
    ///   - hashedPassword: 해시된 비밀번호
    /// - Returns: 인증에 성공한 경우 User 객체, 실패한 경우 nil
    /// - Throws: 사용자 찾을 수 없는 경우 에러 발생
    func authenticateUser(by username: String, hashedPassword: String) throws -> User? {
        return try CoreDataStack.shared.authenticateUser(name: username, hashedPassword: hashedPassword)
    }
    
    /// 사용자의 비밀번호를 업데이트하는 함수
    /// - Parameters:
    ///   - user: 비밀번호를 변경할 사용자 객체
    ///   - newPassword: 새로운 비밀번호
    /// - Throws: 사용자 정보 업데이트 실패시 에러 발생
    func updateUserPassword(of user: User, newPassword: String) throws {
        try CoreDataStack.shared.updateUser(
            name: user.username,
            password: newPassword,
            isAdmin: user.isAdmin
        )
    }
    
    /// 사용자를 삭제하는 함수
    /// - Parameter username: 삭제할 사용자 이름
    /// - Throws: 사용자 삭제 실패시 에러 발생
    func deleteUser(by username: String) throws {
        try CoreDataStack.shared.deleteUser(name: username)
    }
}
