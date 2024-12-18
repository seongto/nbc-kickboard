//
//  ValidatePasswordUseCase.swift
//  nbc-kickboard
//
//

import Foundation

protocol UserPasswordValidatorProtocol {
    static func validate(_ password: String) -> Result<Void, ValidationError>
}

struct UserPasswordValidator: UserPasswordValidatorProtocol {
    /// 비밀번호의 유효성을 검사합니다.
    /// - Parameter password: 사용자가 입력한 비밀번호
    /// - Returns: 각 단계별 유효성 검사에 실패한 경우의 그 원인을 수집하여 반환. 최종적으로 사용자에게 Alert로 띄워주기.
    ///            errors.isEmpty 로 유효성 검사 판단.
    static func validate(_ password: String) -> Result<Void, ValidationError> {
        var errors: [String] = []
        
        // 1. 허용된 문자(영문 대문자, 소문자, 숫자, 일부 특수기호( ! @ # $ % ^ & * _ ) )만 사용 가능.
        if !NSPredicate(format: "SELF MATCHES %@", "^[A-Za-z0-9!@#$%^&*_]+$").evaluate(with: password) {
            errors.append("비밀번호는 영문 대소문자, 숫자 및 다음의 특수기호만 사용 가능합니다. ! @ # $ % ^ & * _ ")
        }
        
        // 2. 영어 대문자, 소문자, 숫자, 특수문자 최소 1개씩 포함되어야 한다.
        if !NSPredicate(format: "SELF MATCHES %@", ".*[A-Z].*").evaluate(with: password) {
            errors.append("비밀번호에는 최소 하나의 대문자가 포함되어야 합니다.")
        }
        
        if !NSPredicate(format: "SELF MATCHES %@", ".*[a-z].*").evaluate(with: password) {
            errors.append("비밀번호에는 최소 하나의 소문자가 포함되어야 합니다.")
        }
        
        if !NSPredicate(format: "SELF MATCHES %@", ".*[0-9].*").evaluate(with: password) {
            errors.append("비밀번호에는 최소 하나의 숫자가 포함되어야 합니다.")
        }
        
        if !NSPredicate(format: "SELF MATCHES %@", ".*[!@#$%^&*_].*").evaluate(with: password) {
            errors.append("비밀번호에는 최소 하나의 특수문자(! @ # $ % ^ & * _)가 포함되어야 합니다.")
        }
        
        // 3. 공백 금지
        if password.contains(" ") {
            errors.append("비밀번호에는 공백을 포함할 수 없습니다.")
        }
        
        // 4. 길이 제한 8 - 20
        if password.count < 8 || password.count > 20 {
            errors.append("비밀번호는 8자 이상 20자 이하여야 합니다.")
        }
        
        if errors.isEmpty {
            return .success(())
        } else {
            return .failure(ValidationError(messages: errors))
        }
    }
}
