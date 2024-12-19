//
//  HistoryTableViewCell.swift
//  nbc-kickboard
//
//  Created by 권승용 on 12/17/24.
//

import UIKit
import SnapKit

final class HistoryTableViewCell: UITableViewCell {
    static let identifier = "HistoryTableViewCell"
    
    private let typeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .kickboardBasic)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        return imageView
    }()
    
    private let rentDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let rentTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let rentPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private lazy var historyStackView: UIStackView = {
        let stackView = UIStackView()
        makeHistorySubViews().forEach { stackView.addArrangedSubview($0) }
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let dateFormatter = DateFormatter()
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        typeImageView.image = nil
        rentDateLabel.text = nil
        rentTimeLabel.text = nil
        rentPriceLabel.text = nil
    }
    
    private func configureUI() {
        [
            historyStackView
        ].forEach { contentView.addSubview($0) }
        
        historyStackView.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.top.equalTo(contentView.snp.top).offset(15)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-15)
        }
    }
    
    func setupCell(with history: History) {
        typeImageView.image = history.kickboard.type == .basic ? UIImage(resource: .kickboardBasic) : UIImage(resource: .kickboardPower)
        dateFormatter.dateFormat = "yyy-MM-dd"
        rentDateLabel.text = dateFormatter.string(from: history.rentDate)
        
        let minutes = history.totalRentTime / 60
        let seconds = history.totalRentTime % 60
        rentTimeLabel.text = String(format: "%02dm%02ds", minutes, seconds)
        
        if let formattedCost = numberFormatter.string(from: NSNumber(value: history.cost)) {
            rentPriceLabel.text = "\(formattedCost)won"
        }
    }
    
    private func makeHistorySubViews() -> [UIView] {
        return [
            typeImageView,
            makeSlashLabel(),
            rentDateLabel,
            makeSlashLabel(),
            rentTimeLabel,
            makeSlashLabel(),
            rentPriceLabel
        ]
    }
    
    private func makeSlashLabel() -> UILabel {
        let label = UILabel()
        label.text = "/"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }
}
