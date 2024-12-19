//
//  LoginView.swift
//  nbc-kickboard
//
//

import UIKit
import SnapKit


/// LoginView 와 AuthViewController를 연결하는 delegate
protocol LoginViewDelegate: AnyObject {
    func navigateToSignup()
    func getAuthentication(username: String, password: String)
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
        mapActionToButtons()
        
        inputUsername.delegate = self
        inputPassword.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LoginView {
    // 키보드가 올라갈 때 호출되는 함수
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }
        
        let activeTextField: UITextField? = inputUsername.isFirstResponder ? inputUsername : inputPassword.isFirstResponder ? inputPassword : nil
        
        if let textField = activeTextField {
            let textFieldFrame = textField.convert(textField.bounds, to: scrollView)
            let offsetY = max(textFieldFrame.maxY - (self.frame.height - keyboardHeight - 20), 0) // 텍스트 필드 하단이 키보드 위에 표시될 수 있도록 offset 설정
            self.scrollView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
        }
    }
    
    
    // 키보드가 내려갈때 호출되는 함수
    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            // coverImageView이 superView.top inset이 20 이므로 해당 위치에 맞에 contentInset 설정
            self.scrollView.contentInset = .init(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
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
        inputLabelUsername.applyInputLabelStyle(text: "ID")
        inputUsername.applyInputBoxStyle(placeholder: "Please enter your ID")
        inputLabelPassword.applyInputLabelStyle(text: "PW")
        inputPassword.applyInputBoxStyle(placeholder: "Please enter your PW", isSecret: true)
        inputPassword.addShowHidePasswordButton()
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
            $0.top.equalTo(coverImageView.snp.bottom).offset(54)
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
            $0.bottom.equalToSuperview().inset(10)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
    }
}


// MARK: - Action Management & Mapping

extension LoginView {
    func mapActionToButtons() {
        signupButton.applyButtonAction(action: tapSignupButton)
        loginButton.applyButtonAction(action: tapLoginButton)
    }
    
    func tapSignupButton() {
        delegate?.navigateToSignup()
    }
    
    func tapLoginButton() {
        if let username: String = inputUsername.text,
           let password: String = inputPassword.text {
            
            delegate?.getAuthentication(username: username, password: password)
        }
    }
    
    func setLastLoginUserData(username: String, password: String) {
        inputUsername.text = username
        inputPassword.text = password
    }
}

extension LoginView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == inputUsername {
            inputPassword.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
