//
//  KickboardButton.swift
//  nbc-kickboard
//
//  Created by 전성규 on 12/18/24.
//

import UIKit
import SnapKit

enum KickboardButtonType: String {
    case basic = "베이직"
    case power = "파워"
}

final class KickboardButton: UIButton {
    var type: KickboardButtonType
    
    private let contentVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 5.0
        stackView.isUserInteractionEnabled = false
        
        return stackView
    }()
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "kickboard_button_unselected")
    
        return imageView
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.text = type.rawValue
        label.textColor = UIColor(named: "colorPlaceholder")
        label.font = UIFont.paybooc(ofSize: 12.0, weight: .medium)
        
        return label
    }()
    
    init(type: KickboardButtonType) {
        self.type = type
        super.init(frame: .zero)
        
        self.configureUI()
        self.setupConstratins()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        layer.cornerRadius = 12.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(named: "colorPlaceholder")?.cgColor
        
        self.addSubview(contentVStackView)
        
        [iconView, typeLabel].forEach { contentVStackView.addArrangedSubview($0) }
    }
    
    private func setupConstratins() {
        contentVStackView.snp.makeConstraints { $0.top.leading.trailing.equalToSuperview() }
        
        typeLabel.snp.makeConstraints { $0.height.equalTo(18.0) }
    }
    
    func updateConfig() {
        if isSelected {
            switch type {
            case .basic:
                iconView.image = UIImage(named: "kickboard_button_basic")
                typeLabel.textColor = UIColor(named: "colorMain")
                layer.borderColor = UIColor(named: "colorMain")?.cgColor
            case .power:
                iconView.image = UIImage(named: "kickboard_button_power")
                typeLabel.textColor = UIColor(named: "colorSub2")
                layer.borderColor = UIColor(named: "colorSub2")?.cgColor
            }
        } else {
            iconView.image = UIImage(named: "kickboard_button_unselected")
            typeLabel.textColor = UIColor(named: "colorPlaceholder")
            layer.borderColor = UIColor(named: "colorPlaceholder")?.cgColor
        }
    }
    
//    @objc private func kickboardButtonDidTap() {
//        isSelected.toggle()
//        updateConfig(isSelected: isSelected)
//    }
}
#if DEBUG

import SwiftUI

struct KickboardButton_Previews: PreviewProvider {
    static var previews: some View {
        KickboardButton_Presentable()
            .frame(
                width: 50.0,
                height: 50.0,
                alignment: .center)
    }
    
    struct KickboardButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            KickboardButton(type: .basic)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
