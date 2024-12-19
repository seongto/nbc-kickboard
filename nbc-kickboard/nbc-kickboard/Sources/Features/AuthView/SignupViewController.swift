//
//  SignupViewController.swift
//  nbc-kickboard
//
//

import UIKit
import SnapKit


class SignupViewController: UIViewController, SignupViewDelegate {
    // MARK: - Properties
    
    private let userEntityRepository: UserEntityRepositoryProtocol
    private let signupUseCase: SignupUseCase
    private let signupView = SignupView()
    
    var isAdmin: Bool = false
    
    
    // MARK: - init & Life cycles
    
    init(userEntityRepository: UserEntityRepositoryProtocol = UserEntityRepository()) {
        self.userEntityRepository = userEntityRepository
        self.signupUseCase = SignupUseCase(userEntityRepository: self.userEntityRepository)
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
        view.backgroundColor = Colors.white
    }
}


// MARK: - Navigation Controll

extension SignupViewController {
    
}


// MARK: - Action Management & Mapping

extension SignupViewController {
    
    func requestSignup(username: String, password: String) {
        let result = signupUseCase.execute(( username: username, password: password, isAdmin: isAdmin ))
        switch result {
        case .success:
            print("sucess")
            let alert = UIAlertController(
                title: "가입 완료",
                message: "회원 가입이 완료되었습니다. 로그인 해주세요.",
                preferredStyle: .alert
            )
            
            let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(confirmAction)
            present(alert, animated: true)
            
        case .failure(let error):
            print(error.messages)
            let errorMessage: String = error.messages.reduce("") { "\($0)\n- \($1)" }
            let alert = UIAlertController(
                title: "회원 가입 실패",
                message: errorMessage,
                preferredStyle: .alert
            )
            
            let cancelAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
        }
    }
    
    func toggleAgreementStatus() {
        isAdmin.toggle()
        signupView.agreementButton.isSelected = isAdmin
                
        let newColor = isAdmin ? Colors.main : Colors.gray4
        
        if var config = signupView.agreementButton.configuration {
            // Title 스타일 수정
            var titleStyleContainer = AttributeContainer()
            titleStyleContainer.font = Fonts.bodyBold
            titleStyleContainer.foregroundColor = newColor // 타이틀 색상 변경
            
            // 이미지 색상 변경
            config.baseForegroundColor = newColor // 이미지 색상 변경
            
            signupView.agreementButton.configuration = config
        }
    }
}
    

