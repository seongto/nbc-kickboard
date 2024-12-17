//
//  Kickboard.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/16/24.
//

import Foundation

struct Kickboard {
    let longitude: Double
    let latitude: Double
    let kickboardCode: String
    let isRented: Bool
    let batteryStatus: Int16
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
}
