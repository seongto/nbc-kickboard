//
//  AlertView.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/19/24.
//

import UIKit
import SnapKit


/// 단순 알림창 팝업을 위한 뷰
class AlertView: UIView, ModalLifecycleNotifiable, ModalCloseable {
    
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    let confirmButton = UIButton()
    
    let title: String
    let message: String
    let completion: () -> Void
    
    weak var delegate: ModalCloseDelegate?
    
    /// 뷰에 들어갈 텍스트와 버튼 클릭시 작동하는 클로저를 인자로 받습니다.
    /// 버튼 클릭시 기본적으로 모달뷰 자체를 dismiss 하도록 되어 있습니다.
    /// - Parameters:
    ///   - title: 알림창의 상단 제목
    ///   - message: 알림창의 세부 메시지
    ///   - completion: 알림창의 버튼 클릭 후 작동하는 클로져
    init(title: String, message: String, completion: @escaping () -> Void = {}) {
        self.title = title
        self.message = message
        self.completion = completion
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        [
            titleLabel,
            messageLabel,
            confirmButton
        ].forEach { addSubview($0) }
        
        titleLabel.applyAlertTitleLabel(text: title)
        messageLabel.applyAlertMessageLabel(text: message)
        messageLabel.setLineSpacing(lineSpacing: 8, paragraphSpacing: 16)
        confirmButton.applyFullSizeButtonStyle(title: "확인", bgColor: Colors.main, isRadius: true)
        confirmButton.applyButtonAction(action: closeModal)
        
        
        self.backgroundColor = Colors.white
        self.layer.cornerRadius = 16
        
        self.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(100)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Layouts.paddingBig)
            $0.leading.trailing.equalToSuperview().inset(Layouts.paddingSmall)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(Layouts.paddingSmall)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(48)
            $0.bottom.equalToSuperview().inset(Layouts.padding)
            $0.leading.trailing.equalToSuperview().inset(Layouts.paddingSmall)
        }
    }
}


extension AlertView {
    func onModalWillAppear() {
        print("모달 나타난다.")
    }
    
    func onModalWillDisappear() {
        print("모달 사라진다.")
    }
    
    func closeModal() {
        delegate?.closeModal()
        completion()
    }
}
