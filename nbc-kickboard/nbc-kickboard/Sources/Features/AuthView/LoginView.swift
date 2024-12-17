//
//  LoginView.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/16/24.
//

import UIKit
import SnapKit


protocol LoginViewDelegate: AnyObject {
    
}

final class LoginView: UIView {
    // MARK: - Properties
    
    let coverImageView = UIImageView()
    let inputUsername = UITextField()
    let inputPassword = UITextField()
    let loginButton = UIButton()
    let signupButton = UIButton()
    let twoButtonsView = UIStackView()
    
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

extension LoginView {
    func setupUI() {
        [
            coverImageView,
            twoButtonsView,
            loginButton,
            signupButton
        ].forEach { addSubview($0) }
        
        self.backgroundColor = Colors.white
        
        twoButtonsView.applyTwoButtonsViewStyle()
        loginButton.applyFullSizeButtonStyle(title: "로그인", bgColor: Colors.main)
        signupButton.applyFullSizeButtonStyle(title: "회원가입", bgColor: Colors.blue)
        
        coverImageView.image = UIImage(named: "coverImage")
        
        
        coverImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(100)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
            $0.height.equalTo(coverImageView.snp.width).multipliedBy(288.0 / 353.0)
        }
        
        twoButtonsView.snp.makeConstraints {
            $0.top.equalTo(coverImageView.snp.bottom).offset(100)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(twoButtonsView.snp.bottom).offset(100)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
        }
        
        signupButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(Layouts.itemSpacing)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
        }
    }
}
