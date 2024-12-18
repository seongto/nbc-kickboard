//
//  UITextField+extensions.swift
//  nbc-kickboard
//
//

import UIKit
import SnapKit


extension UITextField {
    func applyInputBoxStyle(placeholder: String) {
        self.backgroundColor = Colors.gray6.withAlphaComponent(0.3)
        self.borderStyle = .roundedRect
        self.placeholder = placeholder
        
        self.textColor = Colors.black
        self.font = Fonts.body
        
        self.snp.makeConstraints {
            $0.height.equalTo(50)
        }
    }
    
    
}
