//
//  MyPageView.swift
//  nbc-kickboard
//
//  Created by 권승용 on 12/16/24.
//

import UIKit
import SnapKit

protocol MyPageViewDelegate: AnyObject {
    func historyButtonDidTapped()
    func logoutButtonDidTapped()
}

final class MyPageView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.text = "마이페이지"
        return label
    }()
    
    private let userIDView = UserIDView()
    private let kickboardStatusView = KickboardStatusView(frame: .zero)
    private let settingsTableView = SettingsTableView()
    
    weak var delegate: MyPageViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureDelegate() {
        settingsTableView.delegate = self
    }
    
    private func configureUI() {
        backgroundColor = .systemBackground
        
        let subviews = [
            titleLabel,
            userIDView,
            kickboardStatusView,
            settingsTableView,
        ]
        
        subviews.forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        userIDView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
        }
        
        kickboardStatusView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(userIDView.snp.bottom).offset(30)
            $0.height.equalTo(85)
        }
        
        settingsTableView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalTo(kickboardStatusView.snp.bottom).offset(25)
            $0.bottom.equalToSuperview().offset(-50)
        }
    }

    func configureUserName(_ username: String) {
        userIDView.configureUsername(username)
    }
    
    func configureKickboardStatus(with kickboard: Kickboard?) {
        kickboardStatusView.configureStatus(kickboard: kickboard)
    }
}

extension MyPageView: SettingsTableViewDelegate {
    func didSelectHistory() {
        delegate?.historyButtonDidTapped()
    }
    
    func didSelectLogout() {
        delegate?.logoutButtonDidTapped()
    }
}

@available(iOS 17, *)
#Preview {
    MyPageView()
}
