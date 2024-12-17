//
//  UIButton+Extensions.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/17/24.
//

import UIKit
import SnapKit

// MARK: - 버튼 스타일링

extension UIButton {
    /// 화면 좌우로 확장되는 형태의 버튼. 원하는 색상을 넣어 자유롭게 사용가능.
    /// .disabled 상태일 경우 배경색이 희미해지도록 처리.
    /// ex. 로그인 버튼, 등록/반납 버튼 등
    /// - Parameter color: 버튼의 배경 색상. 글자 색상은 흰색(라이트) / 검은색(다크) 이므로 이를 고려하여 색상 선택 필요.
    /// - Parameter isRadius: cornerRadius의 값은 정해져있으며 이를 적용할지 안할지에 대한 파라미터 값.
    func applyFullSizeButtonStyle(bgColor: UIColor, isRadius: Bool = true) {
        var config = UIButton.Configuration.filled()
        
        config.buttonSize = .medium
        config.titleAlignment = .center
        config.baseForegroundColor = Colors.white
        config.baseBackgroundColor = bgColor
        config.background.cornerRadius = isRadius ? Layouts.buttonHeight / 2 : 0
        
        self.configurationUpdateHandler = { btn in
            switch self.state {
            case .highlighted:
                config.baseForegroundColor = Colors.white.withAlphaComponent(0.8)
                config.baseBackgroundColor = bgColor.withAlphaComponent(0.8)
            case .disabled:
                config.baseBackgroundColor = bgColor.withAlphaComponent(0.5)
            default:
                config.baseBackgroundColor = Colors.gray5
            }
        }
        
        self.configuration = config
        
        self.titleLabel?.font = Fonts.subtitleBold
        print(self.titleLabel?.font)
        
        self.snp.makeConstraints {
            $0.height.equalTo(Layouts.buttonHeight)
        }
    }
    
    func applyHalfSizeButtonStyle(isFilled: Bool) {
        var config = isFilled ? UIButton.Configuration.filled() : UIButton.Configuration.plain()
        
        config.buttonSize = .medium
        config.titleAlignment = .center
        config.baseBackgroundColor = isFilled ? Colors.mint : Colors.white
        config.baseForegroundColor = isFilled ? Colors.bg : Colors.label
        config.background.cornerRadius = 8
        
        if isFilled == false {
            config.background.strokeColor = Colors.gray4
            config.background.strokeWidth = 1
        }
        
        self.configurationUpdateHandler = { btn in
            switch self.state {
            case .highlighted:
                config.baseForegroundColor = isFilled ? Colors.bg.withAlphaComponent(0.8) : Colors.label.withAlphaComponent(0.8)
                if isFilled == false {
                    config.background.strokeColor = Colors.gray1
                }
            default:
                config.baseBackgroundColor = isFilled ? Colors.mint : Colors.white
            }
        }
        
        self.configuration = config
        
//        print(self.titleLabel)
//        self.titleLabel?.font = Fonts.h1
//        self.titleLabel?.font = UIFont(name: "paybooc Light", size: 20)
        
    }
}


// MARK: - 버튼 액션 할당

extension UIButton {
    /// 부모로부터 액션을 할당받아 버튼의 터치 동작과 연결.
    /// - Parameter action: 동작을 수행하는 클로저
    func applyButtonAction(action: @escaping () -> Void) {
        let actionHandler = UIAction { _ in
            action()
        }
        
        self.addAction(actionHandler, for: .touchUpInside)
    }
    
    /// 부모로부터 비동기 액션을 할당받아 버튼의 터치 동작과 연결.
    /// - Parameter action: 비동기 동작을 수행하는 클로저
    func applyButtonAsyncAction(action: @escaping () async -> Void) {
        let actionHandler = UIAction { _ in
            Task {
                await action()
            }
        }
        
        self.addAction(actionHandler, for: .touchUpInside)
    }
}
