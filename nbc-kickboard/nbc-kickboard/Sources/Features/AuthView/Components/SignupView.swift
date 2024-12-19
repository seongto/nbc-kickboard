//
//  SignupView.swift
//  nbc-kickboard
//
//

import UIKit
import SnapKit


/// SignupView 와 SignupViewController를 연결하는 delegate
protocol SignupViewDelegate: AnyObject {
    func requestSignup(username: String, password: String)
    func toggleAgreementStatus()
}


final class SignupView: UIView {
    // MARK: - Properties
    
    let scrollView = UIScrollView() // 스크롤 기능 추가
    let contentView = UIView() // 실제 컨텐츠를 담는 공간
    
    let headerLabel = UILabel()
    let inputUsername = UITextField()
    let inputPassword = UITextField()
    let inputLabelUsername = UILabel()
    let inputLabelPassword = UILabel()
    let agreementButton = UIButton()
    let signupButton = UIButton()
    let lastView = UIView()
    
    weak var delegate: SignupViewDelegate?
    
    
    
    // MARK: - init & Life cycles
    
    init() {
        super.init(frame: .zero)
        setupUI()
        mapActionToButtons()
        
        inputUsername.delegate = self
        inputPassword.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - UI Layouts

extension SignupView {
    func setupUI() {
        [
            headerLabel,
            inputUsername,
            inputPassword,
            inputLabelUsername,
            inputLabelPassword,
            agreementButton,
            signupButton,
            lastView
        ].forEach { contentView.addSubview($0) }
        
        scrollView.addSubview(contentView)
        self.addSubview(scrollView)
        
        
        // MARK: - Components Styling & Configuration
        
        scrollView.applyVerticalStyle()
        headerLabel.applyHeadlineStyle(text: "회원 가입")
        
        inputUsername.applyInputBoxStyle(placeholder: "Please enter your ID")
        inputPassword.applyInputBoxStyle(placeholder: "Please enter your PW", isSecret: true)
        inputPassword.addShowHidePasswordButton()
        
        inputLabelUsername.applyInputLabelStyle(text: "ID")
        inputLabelPassword.applyInputLabelStyle(text: "PW")
        
        agreementButton.applyAgreeButtonStyle(title: "[선택]", subTitle: "관리자로 가입하시겠습니까?")
        signupButton.applyFullSizeButtonStyle(title: "회원가입", bgColor: Colors.main)
        
        
        // MARK: - Layouts
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
        }
        
        inputLabelUsername.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(40)
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
        
        agreementButton.snp.makeConstraints {
            $0.top.equalTo(inputPassword.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
        }
        
        signupButton.snp.makeConstraints {
            $0.top.equalTo(agreementButton.snp.bottom).offset(120)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
        }
        
        lastView.snp.makeConstraints {
            $0.top.equalTo(signupButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
            $0.height.greaterThanOrEqualTo(10)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
    }
}


// MARK: - Action Management & Mapping

extension SignupView {
    func mapActionToButtons() {
        signupButton.applyButtonAction(action: tapSignupButton)
        agreementButton.applyButtonAction(action: tapAgreementButton)
    }
    
    func tapSignupButton() {
        if let username: String = inputUsername.text,
           let password: String = inputPassword.text  {
            delegate?.requestSignup(username: username, password: password)
        }
    }
    
    func tapAgreementButton() {
        delegate?.toggleAgreementStatus()
    }
}

extension SignupView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == inputUsername {
            inputPassword.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
