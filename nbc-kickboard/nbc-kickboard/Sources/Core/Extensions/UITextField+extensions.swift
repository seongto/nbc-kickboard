//
//  UITextField+extensions.swift
//  nbc-kickboard
//
//

import UIKit
import SnapKit


extension UITextField {
    func applyInputBoxStyle(placeholder: String, isSecret: Bool = false) {
        self.backgroundColor = Colors.gray6.withAlphaComponent(0.3)
        self.borderStyle = .roundedRect
        self.placeholder = placeholder
        
        self.textColor = Colors.label
        self.font = Fonts.body
        
        if isSecret {
            self.isSecureTextEntry = true
        } else {
            self.clearButtonMode = .whileEditing
        }
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        
        self.snp.makeConstraints {
            $0.height.equalTo(50)
        }
    }
    
    
}

extension UITextField {
    func addShowHidePasswordButton() {
        // 아이콘 설정 (눈 모양 이미지, 감긴 상태)
        let eyeOpenImage = UIImage(systemName: "eye.fill") // 눈 뜬 이미지
        let eyeClosedImage = UIImage(systemName: "eye.slash.fill") // 눈 감은 이미지
        
        var config = UIButton.Configuration.plain()
        
        config.image = eyeClosedImage
        config.baseForegroundColor = Colors.gray1
        
        let actionHandler = UIAction { _ in
            self.isSecureTextEntry.toggle()
            
            if let button = self.rightView as? UIButton {
                let newImage = self.isSecureTextEntry ? eyeClosedImage : eyeOpenImage
                button.setImage(newImage, for: .normal)
            }
        }
        
        let toggleButton = UIButton(configuration: config, primaryAction: actionHandler)
        
        
        // 버튼을 텍스트 필드의 오른쪽에 추가
        self.rightView = toggleButton
        self.rightViewMode = .always // 항상 보이게 설정
    }
}
