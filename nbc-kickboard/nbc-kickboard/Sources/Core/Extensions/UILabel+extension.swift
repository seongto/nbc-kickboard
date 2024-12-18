//
//  UILabel+extension.swift
//  nbc-kickboard
//
//

import UIKit
import SnapKit


extension UILabel {
    /// 각 화면 상단 좌측에 들어가는 헤드라인 텍스트용 라벨
    func applyHeadlineStyle(text: String) {
        self.text = text
        self.font = Fonts.headline
        self.textColor = Colors.black
        self.textAlignment = .left
        
        self.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.leading.trailing.equalToSuperview().offset(Layouts.paddingBig)
        }
    }
    
    // input 위에 input 설명용 라벨
    func applyInputLabelStyle(text: String) {
        self.text = text
        self.backgroundColor = .clear
        self.textAlignment = .left
        self.font = Fonts.cap
        self.textColor = Colors.gray1
        self.numberOfLines = 0
    }
}
