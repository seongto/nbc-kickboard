//
//  Kickboard.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/16/24.
//

import Foundation

struct Kickboard {
    var longitude: Double
    var latitude: Double
    let kickboardCode: String
    var isRented: Bool
    var batteryStatus: Int16
    let type: KickboardType
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
}
