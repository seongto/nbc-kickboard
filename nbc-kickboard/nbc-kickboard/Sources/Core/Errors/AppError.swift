//
//  AppError.swift
//  nbc-kickboard
//
//  Created by 권승용 on 12/17/24.
//

import Foundation

enum AppError: Error {
    enum PasswordManagerError: LocalizedError {
        case encryptionFailed
        
        var errorDescription: String? {
            switch self {
            case .encryptionFailed:
                return "비밀번호 암호화 실패"
            }
        }
    }
}
