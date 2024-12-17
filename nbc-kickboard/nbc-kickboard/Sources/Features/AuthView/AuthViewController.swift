//
//  AuthViewController.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/13/24.
//

import UIKit
import SnapKit


class AuthViewController: UIViewController {
    // MARK: - Properties
    
    let loginView = LoginView()
    let signupView = SignupView()
    
    
    // MARK: - init & Life cycles
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = loginView
        setupUI()
        
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
