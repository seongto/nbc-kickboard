//
//  UILabel+extension.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/17/24.
//

import UIKit
import SnapKit


extension UILabel {
    func applyHeadlineStyle() {
        self.font = UIFont(name: "paybooc Light", size: 30)
        self.textColor = Colors.label
        self.textAlignment = .left
        
        self.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.leading.trailing.equalToSuperview().offset(Layouts.paddingBig)
        }
    }
}
