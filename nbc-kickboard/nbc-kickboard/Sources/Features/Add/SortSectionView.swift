//
//  SortSectionView.swift
//  nbc-kickboard
//
//  Created by 전성규 on 12/17/24.
//

import UIKit
import SnapKit

protocol SortsectionViewDelegate: AnyObject {
    func sortSectionView(_ sortSectionView: SortSectionView, didSelectedButtonType: KickboardType)
}

final class SortSectionView: UIStackView {
    let buttonTypes: [KickboardType]
    var kickboardButtons = [KickboardButton]()
    var selectedIndex = 0 {
        didSet {
            kickboardButtons
                .enumerated()
                .forEach { index, button in
                    button.isSelected = index == selectedIndex
                    button.updateConfig()
                }
            
            let selectedButtonType = buttonTypes[selectedIndex]
            delegate?.sortSectionView(self, didSelectedButtonType: selectedButtonType)
        }
    }
    
    weak var delegate: SortsectionViewDelegate?
    
    private let viewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "종류"
        label.textColor = .black
        label.font = Fonts.subtitleBold
        
        return label
    }()
    
    private let buttonHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Layouts.padding
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    init(buttonTypes: [KickboardType]) {
        self.buttonTypes = buttonTypes
        super.init(frame: .zero)
        
        self.configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        axis = .vertical
        alignment = .leading
        distribution = .equalSpacing
        spacing = 10.0
        
        [viewTitleLabel, buttonHStackView].forEach { addArrangedSubview($0) }
        
        buttonTypes
            .enumerated()
            .forEach { index, type in
                let button = KickboardButton(type: type)
                button.isSelected = index == 0
                button.tag = index
                button.addTarget(
                    self,
                    action: #selector(kickboardButtonDidTap(_:)),
                    for: .touchUpInside)
                
                if index == 0 { button.updateConfig() }
                
                kickboardButtons.append(button)
                buttonHStackView.addArrangedSubview(button)
                
                button.snp.makeConstraints { $0.width.height.equalTo(50.0) }
            }
    }
    
    @objc private func kickboardButtonDidTap(_ sender: UIButton) {
        let index = sender.tag
        selectedIndex = index
    }
    
    func resetSelectedIndex() { selectedIndex = 0 }
}

#if DEBUG

import SwiftUI

struct SortSectionView_Previews: PreviewProvider {
    static var previews: some View {
        SortSectionView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(
                width: UIScreen.main.bounds.width - 40.0,
                height: 85.0,
                alignment: .center)
    }
    
    struct SortSectionView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            SortSectionView(buttonTypes: [.basic, .power])
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
