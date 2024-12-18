//
//  UIFont+extensions.swift
//  nbc-kickboard
//
//

import UIKit

enum FontName: String {
    case payboocBold = "paybooc OTF Bold"
    case payboocMedium = "paybooc OTF Medium"
    case payboocLight = "paybooc Light"
}

extension UIFont {
    static func paybooc(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        let familyName = "paybooc OTF"
        var weightString: String
    
        switch weight {
        case .bold:
            weightString = "Bold"
        default:
            weightString = "Medium"
        }

        return UIFont(name: "\(familyName) \(weightString)", size: fontSize) ?? .systemFont(ofSize: fontSize, weight: .bold)
    }
}
