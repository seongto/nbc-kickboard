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


// MARK: - Action Management & Mapping

extension SignupViewController {
    
    /// 회원가입을 요청하는 메소드.
    /// - Parameters:
    ///   - username: 사용자가 입력한 사용자 아이디
    ///   - password: 사용자가 입력한 사용자 암호
    func requestSignup(username: String, password: String) {
        let result = signupUseCase.execute(( username: username, password: password, isAdmin: isAdmin ))
        switch result {
        case .success:
            let alertView = AlertView(title: "회원 가입 성공", message: "로그인 화면으로 돌아갑니다.") {
                self.navigationController?.popViewController(animated: true)
            }
            
            let _ = ModalManager.createGlobalModal(content: alertView)
        case .failure(let error):
            let errorMessage: String = error.messages.reduce("") { "\($0)\n- \($1)" }
            print(errorMessage)
            let alertView = AlertView(title: "회원 가입 실패", message: errorMessage)
            
            let _ = ModalManager.createGlobalModal(content: alertView)
        }
    }
    
    /// 가입 단계의 관리자 여부를 선택하는 토글 버튼의 상태 데이터와 뷰를 연결.
    /// 이런 식으로 데이터와 뷰 화면 반영을 구성하는 게 맞는건지 잘 모르겠습니다.
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
    

