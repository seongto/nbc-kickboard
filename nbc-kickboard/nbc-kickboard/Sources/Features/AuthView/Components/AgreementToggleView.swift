//
//  AgreementToggleView.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/18/24.
//

import UIKit
import SnapKit


final class AgreementToggleView: UIView {
    // MARK: - Properties
        
    let isAgreed: Bool = false
    
    
    
    // MARK: - init & Life cycles
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - UI Layouts

extension AgreementToggleView {
    func setupUI() {
        
    }
}


// MARK: - Action Management & Mapping

extension AgreementToggleView {
    
}
