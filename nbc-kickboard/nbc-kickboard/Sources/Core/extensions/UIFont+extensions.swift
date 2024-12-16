//
//  UIFont+extensions.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/16/24.
//

import UIKit

enum FontName: String {
    case payboocBold = "Paybooc-Bold"
    case payboocMedium = "Paybooc-Medium"
}

extension UIFont {
    static func paybooc(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
            let familyName = "Paybooc"
            var weightString: String
        
            switch weight {
            case .bold:
                weightString = "Bold"
            case .medium:
                weightString = "Medium"
            default:
                weightString = "Regular"
            }

            return UIFont(name: "\(familyName)-\(weightString)", size: fontSize) ?? .systemFont(ofSize: fontSize, weight: weight)
        }
}
