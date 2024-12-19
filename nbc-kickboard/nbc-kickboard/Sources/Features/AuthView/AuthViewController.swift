//
//  AuthViewController.swift
//  nbc-kickboard
//
//

import UIKit
import SnapKit


class AuthViewController: UIViewController, LoginViewDelegate {
    // MARK: - Properties
    
    private let loginView = LoginView()
    private let userEntityRepository: UserEntityRepositoryProtocol
    private let loginUseCase: LoginUseCase
    
    // MARK: - init & Life cyclesas
    
    init(userEntityRepository: UserEntityRepositoryProtocol = UserEntityRepository()) {
        self.userEntityRepository = userEntityRepository
        self.loginUseCase = LoginUseCase(userEntityRepository: self.userEntityRepository)
        super.init(nibName: nil, bundle: nil)
        
        loginView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = loginView
        setupUI()
        setDefaultUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
}


// MARK: - Setup UI Layouts

extension AuthViewController {
    private func setupUI() {
        view.backgroundColor = Colors.white
    }
}


// MARK: - Navigation Controll

extension AuthViewController {
    
}


// MARK: - Action Management & Mapping

extension AuthViewController {
    func navigateToSignup() {
        navigationController?.pushViewController(SignupViewController(), animated: true)
    }
    
    func getAuthentication(username: String, password: String) {
        let result = loginUseCase.execute((username: username, password: password))
        
        switch result {
        case .success(let userEntity):
            
            // 현재 로그인된 사용자의 정보 저장
            UserDefaults.standard.set(userEntity.username, forKey: "username")
            UserDefaults.standard.set(userEntity.isAdmin, forKey: "isAdmin")
            
            // 마지막으로 로그인에 성공한 사용자아이디 및 암호 저장
            UserDefaults.standard.set(username, forKey: "lastLoginUsername")
            UserDefaults.standard.set(password, forKey: "lastLoginPassword")
            
            navigationController?.pushViewController(CustomTabBarController(), animated: false)
            
        case .failure(let error):
            let errorMessage: String = error.messages.reduce("") { "\($0)\n- \($1)" }
            print(errorMessage)
            let alertView = AlertView(title: "로그인 실패", message: errorMessage)
            let _ = ModalManager.createGlobalModal(content: alertView)
        }
    }
    
    func setDefaultUserInfo() {
        if let username = UserDefaults.standard.object(forKey:"lastLoginUsername"), let password = UserDefaults.standard.object(forKey: "lastLoginPassword") {
            loginView.setLastLoginUserData(username: username as! String, password: password as! String)
        }
    }
}


// MARK: - Preview

@available(iOS 17.0, *)
#Preview {
    AuthViewController()
}

