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
            UserDefaults.standard.set(userEntity.username, forKey: "username")
            UserDefaults.standard.set(userEntity.isAdmin, forKey: "isAdmin")
            print("UserDefaults에 저장 완료. 이동을 어디로 어떻게 처리할까요?")
            
            let alert = UIAlertController(
                title: "로그인 성공",
                message: "\(userEntity.username ?? "??")님 환영합니다. 이건 테스트용 경고.",
                preferredStyle: .alert
            )
            
            let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                
            }
            alert.addAction(confirmAction)
            present(alert, animated: true)
        case .failure(let error):
            let errorMessage: String = error.messages.reduce("") { "\($0)\n- \($1)" }
            
//            let alert = UIAlertController(
//                title: "로그인 실패",
//                message: errorMessage,
//                preferredStyle: .alert
//            )
//            
//            let confirmAction = UIAlertAction(title: "확인", style: .default)
//            alert.addAction(confirmAction)
//
//            present(alert, animated: true)
            
            // 위의 Alert 코드를 전역 함수를 통해 아래의 코드로 대체. 위 주석은 추후 커밋에서 삭제 예정.
            AppHelpers.showBasicAlert(title: "로그인 실패", message: errorMessage, action: { print("Alert 종료")})
        }
    }
}


// MARK: - Preview

@available(iOS 17.0, *)
#Preview {
    AuthViewController()
}

