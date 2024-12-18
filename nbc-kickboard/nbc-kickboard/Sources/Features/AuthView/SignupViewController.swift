//
//  SignupViewController.swift
//  nbc-kickboard
//
//

import UIKit
import SnapKit


class SignupViewController: UIViewController, SignupViewDelegate {
    // MARK: - Properties
    
    let userEntityRepository: UserEntityRepository
    let signupUseCase: SignupUseCase
    
    let signupView = SignupView()
    
    // MARK: - init & Life cycles
    
    init() {
        self.userEntityRepository = UserEntityRepository()
        self.signupUseCase = SignupUseCase(userEntityRepository: userEntityRepository)
        super.init(nibName: nil, bundle: nil)
        
        signupView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = signupView
        setupUI()
    }    
}


// MARK: - Setup UI Layouts

extension SignupViewController {
    private func setupUI() {
        view.backgroundColor = Colors.bg
    }
}


// MARK: - Navigation Controll

extension SignupViewController {
    
}


// MARK: - Action Management & Mapping

extension SignupViewController {
    
    func requestSignup(username: String, password: String) {
        
    }

}
    

