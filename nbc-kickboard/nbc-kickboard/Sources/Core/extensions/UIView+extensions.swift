//
//  UIView+extensions.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/17/24.
//

import UIKit
import SnapKit

enum ColorButtonSide {
    case left
    case right
}

extension UIStackView {
    func applyTwoButtonsViewStyle(
        actionLeft: @escaping () -> Void = { print("LEFT Touched")},
        actionRight: @escaping () -> Void = { print("RIGHT Touched")},
        titleLeft: String = "닫기",
        titleRight: String = "대여하기",
        colorSide: ColorButtonSide = .right,
        isAsync: Bool = false
    ) {
        let buttonLeft = UIButton()
        let buttonRight = UIButton()
        
        [buttonLeft, buttonRight].forEach {
            self.addArrangedSubview($0)
        }
        
        buttonLeft.applyHalfSizeButtonStyle(isFilled: colorSide == .left)
        buttonRight.applyHalfSizeButtonStyle(isFilled: colorSide == .right)
        
        buttonLeft.setTitle(titleLeft, for: .normal)
        buttonRight.setTitle(titleRight, for: .normal)
        
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fillEqually
        self.spacing = Layouts.itemSpacing
        
        self.snp.makeConstraints {
            $0.height.equalTo(Layouts.buttonHeight)
        }
        
        
        
        if isAsync {
            buttonLeft.applyButtonAsyncAction(action: actionLeft)
            buttonRight.applyButtonAsyncAction(action: actionRight)
        } else {
            buttonLeft.applyButtonAction(action: actionLeft)
            buttonRight.applyButtonAction(action: actionRight)
        }
    }
}
