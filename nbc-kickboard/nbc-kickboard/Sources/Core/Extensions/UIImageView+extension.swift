//
//  UIImageView+extension.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/20/24.
//

import UIKit
import SnapKit

// MARK: - 스타일 관리

extension UIImageView {
    
    /// 검색 결과 테이블의 이미지 용 스타일
    /// - Parameters:
    ///   - size: 이미지의 사이즈. CGFloat 타입
    func applyImageStyle(size: CGFloat) {
        self.backgroundColor = .clear
        self.contentMode = .scaleAspectFill
        
        self.snp.makeConstraints {
            $0.height.width.equalTo(size)
        }
    }
}
