//
//  SignupView.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/17/24.
//

import UIKit
import SnapKit

final class SignupView: UIView {
    // MARK: - Properties
    
    let coverImageView = UIImageView()
    let inputUsername = UITextField()
    let inputPassword = UITextField()
    let loginButton = UIButton()
    let signupButton = UIButton()
    
    weak var delegate: LoginViewDelegate?
    
    
    // MARK: - init & Life cycles
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - UI Layouts

extension SignupView {
    func setupUI() {
        
    }
}
