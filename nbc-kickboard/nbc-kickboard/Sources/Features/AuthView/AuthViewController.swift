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
    private let userRepository: UserEntityRepositoryProtocol
    
    // MARK: - init & Life cycles
    
    init(userRepository: UserEntityRepositoryProtocol = UserEntityRepository()) {
        self.userRepository = userRepository
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
        view.backgroundColor = Colors.bg
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
    
    func getAuthentication() {
        let username = loginView.inputUsername.text
        let password = loginView.inputPassword.text
        
        
    }
}


// MARK: - Preview

@available(iOS 17.0, *)
#Preview {
    AuthViewController()
}

