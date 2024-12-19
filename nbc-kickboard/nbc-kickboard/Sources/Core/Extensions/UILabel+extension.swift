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
            $0.height.greaterThanOrEqualTo(48)
        }
    }
    
    /// input 위에 input 설명용 라벨
    func applyInputLabelStyle(text: String) {
        self.text = text
        self.backgroundColor = .clear
        self.textAlignment = .left
        self.font = Fonts.cap
        self.textColor = Colors.gray1
        self.numberOfLines = 0
    }
    
    /// 알림창 제목 스타일
    /// - Parameter text: 제목 텍스트
    func applyAlertTitleLabel(text: String) {
        self.text = text
        self.backgroundColor = .clear
        self.textAlignment = .center
        self.font = Fonts.subtitleBold
        self.textColor = Colors.main
        self.numberOfLines = 1
    }
    
    /// 알림창 메시지 스타일
    /// - Parameter text: 메시지 텍스트
    func applyAlertMessageLabel(text: String) {
        self.text = text
        self.backgroundColor = .clear
        self.textAlignment = .left
        self.font = Fonts.body
        self.textColor = Colors.black
        self.numberOfLines = 0
    }
}


// MARK: - UILabel Utilities

extension UILabel {
    /// UILabel 에 줄간격을 쉽게 적용시켜 사용하기 위한 메소드
    /// 기본값을 설정하였으므로 아래 둘 중 하나를 선택하여 사용.
    /// - Parameters:
    ///   - lineSpacing: 각 줄 사이의 간격을 의미합니다.
    ///   - paragraphSpacing: 문단 간격을 설정합니다.
    func setLineSpacing(lineSpacing: CGFloat = 0.0, paragraphSpacing:CGFloat = 0.0) {
        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing

        let attributedString:NSMutableAttributedString
        
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
        
        /*
         위 메소드는 다음과 같은 형식으로 사용합니다.
         let label = UILabel()
         
         label.setLineSpacing(lineSpacing: 10.0)
         label.setLineSpacing(paragraphSpacing: 10.0)
         label.setLineSpacing(lineSpacing: 10.0, paragraphSpacing: 10.0)
         */
    }
}
