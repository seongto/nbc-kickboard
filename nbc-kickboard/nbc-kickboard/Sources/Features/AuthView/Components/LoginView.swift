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
    
    let scrollView = UIScrollView() // 스크롤 기능 추가
    let contentView = UIView() // 실제 컨텐츠를 담는 공간
    
    let coverImageView = UIImageView()
    let inputUsername = UITextField()
    let inputPassword = UITextField()
    let inputLabelUsername = UILabel()
    let inputLabelPassword = UILabel()
    let loginButton = UIButton()
    let signupButton = UIButton()
    let lastView = UIView() // 스크롤뷰를 작동하게 만들어주는 마지막 빈 레이아웃
    
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
            inputUsername,
            inputPassword,
            inputLabelUsername,
            inputLabelPassword,
            loginButton,
            signupButton,
            lastView
        ].forEach { contentView.addSubview($0) }
        
        scrollView.addSubview(contentView)
        self.addSubview(scrollView)
        
        
        // MARK: - Components Styling & Configuration
        
        scrollView.applyVerticalStyle()
        
        inputUsername.applyInputBoxStyle(placeholder: "Please enter your ID")
        inputPassword.applyInputBoxStyle(placeholder: "Please enter your PW")
        
        inputLabelUsername.applyInputLabelStyle(text: "ID")
        inputLabelPassword.applyInputLabelStyle(text: "PW")
        
        loginButton.applyFullSizeButtonStyle(title: "로그인", bgColor: Colors.main)
        signupButton.applyFullSizeButtonStyle(title: "회원가입", bgColor: Colors.blue)
        
        
        contentView.backgroundColor = Colors.white
        coverImageView.image = UIImage(named: "coverImage")
        
        
        // MARK: - Layouts
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        coverImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
            $0.height.equalTo(coverImageView.snp.width).multipliedBy(288.0 / 353.0)
        }
        
        inputLabelUsername.snp.makeConstraints {
            $0.top.equalTo(coverImageView.snp.bottom).offset(56)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
        }
        
        inputUsername.snp.makeConstraints {
            $0.top.equalTo(inputLabelUsername.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
        }
        
        inputLabelPassword.snp.makeConstraints {
            $0.top.equalTo(inputUsername.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
        }
        
        inputPassword.snp.makeConstraints {
            $0.top.equalTo(inputLabelPassword.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(inputPassword.snp.bottom).offset(64)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
        }
        
        signupButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(Layouts.itemSpacing)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
        }
        
        lastView.snp.makeConstraints {
            $0.top.equalTo(signupButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
            $0.height.equalTo(10)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
    }
}


extension LoginView {
    
}
