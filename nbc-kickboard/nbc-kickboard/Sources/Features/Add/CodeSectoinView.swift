//
//  CodeSectoinView.swift
//  nbc-kickboard
//
//  Created by 전성규 on 12/17/24.
//

import UIKit
import SnapKit

protocol CodeSectoinViewDelegate: AnyObject {
    func createRandomKickboardCode(completion: @escaping (String) -> Void)
}

final class CodeSectionView: UIStackView {
    weak var delegate: CodeSectoinViewDelegate?
    
    private lazy var codeGenerateButton: UIButton = {
        let button = UIButton()
        button.setTitle("코드 생성", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.main
        button.titleLabel?.font = Fonts.bodyBold
        button.layer.cornerRadius = 12.0
        
        button.addTarget(self, action: #selector(codeGenerateButtonButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    private let labelContentVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 10.0
        
        return stackView
    }()
    
    private let viewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "킥보드 코드"
        label.textColor = .black
        label.font = Fonts.subtitleBold
        
        return label
    }()
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textColor = Colors.placeHolder
        label.font = Fonts.bodyBold
        
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        self.configureUI()
        self.setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        axis = .horizontal
        
        [labelContentVStackView, codeGenerateButton].forEach { addArrangedSubview($0) }
        
        [viewTitleLabel, codeLabel].forEach { labelContentVStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        codeGenerateButton.snp.makeConstraints { $0.width.equalTo(70.0) }
    }
    
    @objc private func codeGenerateButtonButtonDidTap() {
        delegate?.createRandomKickboardCode { [weak self] text in
            guard let self = self else { return }
            
            codeLabel.text = text
        }
    }
    
    func resetCodeLabel() { codeLabel.text = "-" }
}

#if DEBUG

import SwiftUI

struct CodeSectionView_Previews: PreviewProvider {
    static var previews: some View {
        CodeSectionView_Presentable()
            .frame(
                width: UIScreen.main.bounds.width - 40.0,
                height: 55.0,
                alignment: .center)
    }
    
    struct CodeSectionView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView { CodeSectionView() }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif

