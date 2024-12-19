//
//  KickboardButton.swift
//  nbc-kickboard
//
//  Created by 전성규 on 12/18/24.
//

import UIKit
import SnapKit

final class KickboardButton: UIButton {
    var type: KickboardType
    
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
        switch type {
        case .basic:
            label.text = "베이직"
        case .power:
            label.text = "파워"
        }
        label.textColor = Colors.placeHolder
        label.font = Fonts.cap
        
        return label
    }()
    
    init(type: KickboardType) {
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
        layer.borderColor = Colors.placeHolder.cgColor
        
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
                typeLabel.textColor = Colors.main
                layer.borderColor = Colors.main.cgColor
            case .power:
                iconView.image = UIImage(named: "kickboard_button_power")
                typeLabel.textColor = Colors.sub2
                layer.borderColor = Colors.sub2.cgColor
            }
        } else {
            iconView.image = UIImage(named: "kickboard_button_unselected")
            typeLabel.textColor = Colors.placeHolder
            layer.borderColor = Colors.placeHolder.cgColor
        }
    }
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
