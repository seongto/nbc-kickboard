//
//  ValidationError.swift
//  nbc-kickboard
//
//  Created by 임성수 on 12/18/24.
//

/// 문자열 validation 중 Alert에서 사용자에게 검증이 통과되지 못한 이유를 알려주기 위한 커스텀 에러
struct ValidationError: Error {
    let messages: [String]
}
