//
//  AuthViewController.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/13/24.
//

import UIKit
import SnapKit


enum AuthViewSelector {
    case login
    case signup
}

class AuthViewController: UIViewController {
    // MARK: - Properties
    
    let loginView = LoginView()
    let signupView = SignupView()
    
    let currentView: AuthViewSelector
    let testRepo: UserEntityRepository
    
    // MARK: - init & Life cycles
    
    init() {
        self.currentView = .login
        self.testRepo = UserEntityRepository()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = loginView
        setupUI()
        
        testRepo.createUser(username: "MaxBook", password: "123456", isAdmin: true)
        testRepo.softDeleteUser(user: UserEntity())
    }
}


// MARK: - Setup UI Layouts

extension AuthViewController {
    private func setupUI() {
        view.backgroundColor = Colors.white
    }
}

@available(iOS 17.0, *)
#Preview {
    AuthViewController()
}
