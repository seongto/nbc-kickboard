//
//  UserIDView.swift
//  nbc-kickboard
//
//  Created by 권승용 on 12/17/24.
//

import UIKit
import SnapKit

final class UserIDView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "아이디"
        return label
    }()
    
    private let userIDLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = " "
        return label
    }()
    
    private lazy var userIDStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            userIDLabel
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.alignment = .leading
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [
            userIDStackView
        ].forEach { addSubview($0) }
        
        userIDStackView.snp.makeConstraints { 
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func configureUsername(_ username: String) {
        userIDLabel.text = username
    }
}

@available(iOS 17, *)
#Preview {
    UserIDView()
}
