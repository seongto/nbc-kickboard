//
//  CodeSectoinView.swift
//  nbc-kickboard
//
//  Created by 전성규 on 12/17/24.
//

import UIKit
import SnapKit

final class CodeSectionView: UIStackView {
    private let viewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "킥보드 코드"
        label.textColor = .black
        label.font = UIFont.paybooc(ofSize: 20.0, weight: .bold)
        
        return label
    }()
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textColor = UIColor(named: "colorPlaceholder")
        label.font = UIFont.paybooc(ofSize: 16.0, weight: .bold)
        
        return label
    }()
    
    init() {
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
        
        [viewTitleLabel, codeLabel].forEach { addArrangedSubview($0) }
    }
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

