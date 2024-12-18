//
//  UIView+extensions.swift
//  nbc-kickboard
//
//

import UIKit
import SnapKit

enum ColorButtonSide {
    case left
    case right
}

extension UIStackView {
    /// 양자 선택을 위한 버튼 레이아웃 컴포넌트.
    /// 자체적으로 두개의 half size 버튼을 가지고 있으며, 해당 버튼에 타이틀이나 액션을 할당하여 사용.
    /// - Parameters:
    ///   - actionLeft: 왼쪽 버튼에 할당할 클로져. 기본값으로 실행 여부 확인용 print 있음.
    ///   - actionRight: 오른쪽 버튼에 할당할 클로져. 기본값으로 실행 여부 확인용 print 있음.
    ///   - titleLeft: 왼쪽 버튼 타이틀. 기본값 = 닫기
    ///   - titleRight: 오른쪽 버튼 타이틀. 기본값 = 대여하기
    ///   - colorSide: 확인용 색상 버튼이 어느 쪽인지를 정하기. 기본값 .right
    ///   - isAsync: 비동기로 구동해야 하는 경우에 true. 기본값 false.
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
        
        buttonLeft.applyHalfSizeButtonStyle(title: titleLeft, isFilled: colorSide == .left)
        buttonRight.applyHalfSizeButtonStyle(title: titleRight, isFilled: colorSide == .right)
        
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
    
    func updateButtonsStyle(
        titleLeft: String = "닫기",
        titleRight: String = "대여하기",
        colorSide: ColorButtonSide = .right
    ) {
        guard arrangedSubviews.count == 2,
              let buttonLeft = arrangedSubviews[0] as? UIButton,
              let buttonRight = arrangedSubviews[1] as? UIButton else {
            return
        }
        buttonLeft.applyHalfSizeButtonStyle(title: titleLeft, isFilled: colorSide == .left)
        buttonRight.applyHalfSizeButtonStyle(title: titleRight, isFilled: colorSide == .right)
    }
}
