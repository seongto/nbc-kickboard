//
//  SignupUseCase.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/18/24.
//

import Foundation

struct SignupUseCase: UseCaseProtocol {
    typealias Input = (username: String, password: String, isAdmin: Bool)
    typealias Output = Result<UserEntity, Error>
    
    private let passwordManager: PasswordManageable = PasswordManager()
    private let userEntityRepository: UserEntityRepositoryProtocol
    
    init(userEntityRepository: UserEntityRepositoryProtocol) {
        self.userEntityRepository = userEntityRepository
    }
    
    func execute(_ input: Input) -> Output {
        var errors: [String] = [] // alert에서 띄워줄 가입 실패 원인 전달용.
        let (username, password, isAdmin) = input
        
        // 1. name 유효성 검사
        var usernameValidation = UsernameValidator.validate(username)
        switch usernameValidation {
        case .success:
            print("사용자 이름 유효성 검사 성공")
        case .failure(let error):
            print("사용자 이름 유효성 검사 실패: \(error)")
            
            errors.append(contentsOf: error.messages)
            return .failure(error)
        }
        
        // 2. name 중복검사
        if let _ = userEntityRepository.fetchUser(by: username) {
            print("사용자 이름 중복 검사 실패")
            
            errors.append("해당 사용자 이름은 사용할 수 없습니다.")
            return .failure(ValidationError(messages: errors))
        }
        
        // 3. 패스워드 유효성 검사
        var passwordValidation = UserPasswordValidator.validate(password)
        switch passwordValidation {
        case .success:
            print("사용자 암호 유효성 검사 성공")
        case .failure(let error):
            print("사용자 암호 유효성 검사 실패: \(error)")
            
            errors.append(contentsOf: error.messages)
            return .failure(error)
        }
        
        // 4. 암호 해쉬화
        do {
            let hashedPw: String = try passwordManager.encryptPassword(password)
        } catch {
            print("패스워드 암호화 및 저장에 실패하였습니다. \(error)")
        }
        
        // 5. 사용자 생성
        guard let newUser: UserEntity = userEntityRepository.createUser(username: username, hashedPw: password, isAdmin: isAdmin) else {
            errors.append("사용자 생성에 실패하였습니다.")
            return .failure(ValidationError(messages: errors))
        }
        
        return .success(newUser)
    }
}
