//
//  LoginUseCase.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/18/24.
//

import Foundation


/// 사용자 로그인 UseCase
///
/// - execute(_:) : 사용자 로그인을 실행하는 메서드
struct LoginUseCase: UseCaseProtocol {
    typealias Input = (username: String, password: String)
    typealias Output = Result<UserEntity, ValidationError>
    
    private let userEntityRepository: UserEntityRepositoryProtocol
    
    init(userEntityRepository: UserEntityRepositoryProtocol) {
        self.userEntityRepository = userEntityRepository
    }
    
    /// 사용자 데이터를 받아 검증 후 로그인 처리
    ///
    /// - Parameters:
    ///   - input: 사용자 입력 정보 (`Input` 타입)으로, 아래의 두 가지 정보를 포함합니다:
    ///     - **username** (`String`): 사용자가 입력한 username.
    ///     - **password** (`String`): 사용자가 입력한 비밀번호입니다.
    /// - Returns:
    ///   성공적으로 사용자 로그인이 완료되면 `UserEntity`를 반환합니다.
    ///   실패한 경우, `ValidationError`를 포함한 에러가 반환됩니다.
    func execute(_ input: Input) -> Output {
        var errors: [String] = [] // alert에서 띄워줄 가입 실패 원인 전달용.
        let (username, password) = input
        
        // 1. 사용자가 입력한 암호를 해쉬화
        do {
            let hashedPw: String = try PasswordManager.encryptPassword(password)
            
            // 2. 해쉬화된 암호와 사용자명을 이용하여 로그인 시도
            guard let result = userEntityRepository.getAuthenticatedUser(username: username, hashedPw: hashedPw) else {
                errors.append("사용자 정보가 없습니다.")
                return .failure(ValidationError(messages: errors))
            }
            
            guard result.username == username else {
                errors.append("Bad Request")
                return .failure(ValidationError(messages: errors))
            }
            
            print("인증에 성공하였습니다.")
            return .success(result)
            
    
        } catch {
            print("패스워드 암호화 및 저장에 실패하였습니다. \(error)")
            
            errors.append("패스워드 암호화 및 저장에 실패하였습니다.")
            return .failure(ValidationError(messages: errors))
        }
    }
}
