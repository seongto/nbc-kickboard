//
//  KickboardStatusView.swift
//  nbc-kickboard
//
//  Created by 권승용 on 12/17/24.
//

import UIKit
import SnapKit

final class KickboardStatusView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "사용중인 킥보드"
        return label
    }()
    
    private let kickboardTypeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .kickboardPowerWithBorder)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let kickboardCodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "KBA1234"
        return label
    }()
    
    private let batteryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .batteryFull)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let batteryStatusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemMint
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "100%"
        return label
    }()
    
    private lazy var batteryStatusStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            batteryImageView,
            batteryStatusLabel
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        [
            titleLabel,
            kickboardTypeImageView,
            kickboardCodeLabel,
            batteryStatusStackView
        ].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(25)
        }
        
        kickboardTypeImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.width.equalTo(60)
            $0.height.equalTo(60)
        }
        
        kickboardCodeLabel.snp.makeConstraints {
            $0.leading.equalTo(kickboardTypeImageView.snp.trailing).offset(10)
            $0.top.equalTo(kickboardTypeImageView.snp.top)
        }
        
        batteryStatusStackView.snp.makeConstraints {
            $0.leading.equalTo(kickboardTypeImageView.snp.trailing).offset(10)
            $0.bottom.equalTo(kickboardTypeImageView.snp.bottom)
        }
    }
}

@available(iOS 17, *)
#Preview {
    KickboardStatusView()
}
