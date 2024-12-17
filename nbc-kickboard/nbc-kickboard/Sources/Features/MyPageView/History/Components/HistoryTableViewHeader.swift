//
//  HistoryTableViewHeader.swift
//  nbc-kickboard
//
//  Created by 권승용 on 12/17/24.
//

import UIKit
import SnapKit

final class HistoryTableViewHeader: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "내역"
        return label
    }()
    
    private lazy var columnsStackView: UIStackView = {
        let stackView = UIStackView()
        let subViews = makeColumnsView([
            "종류",
            "대여 날짜",
            "대여 시간",
            "납부 금액"
        ])
        subViews.forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 21
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
            columnsStackView
        ].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        columnsStackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
        }
    }
    
    private func makeColumnsView(_ colums: [String]) -> [UIView] {
        var result: [UIView] = []
        for colum in colums {
            let label = UILabel()
            label.text = colum
            label.font = .systemFont(ofSize: 12, weight: .regular)
            label.textColor = .lightGray
            result.append(label)
            let slash = UILabel()
            slash.text = "/"
            slash.font = .systemFont(ofSize: 12, weight: .regular)
            slash.textColor = .black
            result.append(slash)
        }
        result.removeLast()
        return result
    }
}

@available(iOS 17, *)
#Preview {
    HistoryTableViewHeader()
}

