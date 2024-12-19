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
    
    private let kickboardPlaceholder: UILabel = {
        let label = UILabel()
        label.font = Fonts.bodyBold
        label.text = "-"
        label.textAlignment = .left
        return label
    }()
    
    private let kickboardTypeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private let kickboardCodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = " "
        label.isHidden = true
        return label
    }()
    
    private let batteryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let batteryStatusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemMint
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = " "
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
        stackView.isHidden = true
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [
            titleLabel,
            kickboardTypeImageView,
            kickboardCodeLabel,
            batteryStatusStackView,
            kickboardPlaceholder
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
        
        kickboardPlaceholder.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.height.equalTo(60)
        }
    }
    
    func configureStatus(kickboard: Kickboard?) {
        if let kickboard {
            kickboardCodeLabel.text = kickboard.kickboardCode
            switch kickboard.type {
            case .basic:
                kickboardTypeImageView.image = UIImage(resource: .kickboardBox1)
            case .power:
                kickboardTypeImageView.image = UIImage(resource: .kickboardBox2)
            }
            switch kickboard.batteryStatus {
            case 0...49:
                batteryImageView.image = UIImage(resource: .batteryLow)
            case 50...99:
                batteryImageView.image = UIImage(resource: .batteryMedium)
            case 100:
                batteryImageView.image = UIImage(resource: .batteryFull)
            default:
                batteryImageView.image = UIImage(resource: .batteryFull)
            }
            batteryStatusLabel.text = "\(kickboard.batteryStatus)%"
            showKickboardViews()
        } else {
            hideKickboardViews()
        }
    }
    
    private func showKickboardViews() {
        kickboardCodeLabel.isHidden = false
        batteryStatusStackView.isHidden = false
        kickboardTypeImageView.isHidden = false
        kickboardPlaceholder.isHidden = true
    }
    
    private func hideKickboardViews() {
        kickboardCodeLabel.isHidden = true
        batteryStatusStackView.isHidden = true
        kickboardTypeImageView.isHidden = true
        kickboardPlaceholder.isHidden = false
    }
}

@available(iOS 17, *)
#Preview {
    KickboardStatusView()
}
