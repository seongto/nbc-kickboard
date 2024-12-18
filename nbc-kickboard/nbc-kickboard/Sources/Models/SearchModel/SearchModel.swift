//
//  SearchModel.swift
//  nbc-kickboard
//
//  Created by 김석준 on 12/18/24.
//

import Foundation

// Kakao API 응답 모델
struct KakaoPlaceSearchResult: Codable {
    let documents: [Place]
}

struct Place: Codable {
    let placeName: String
    let x: String  // 경도
    let y: String  // 위도
    let addressName: String
    let placeURL: String?
    
    enum CodingKeys: String, CodingKey {
        case placeName = "place_name"
        case x
        case y
        case addressName = "address_name"
        case placeURL = "place_url"
    }
}
