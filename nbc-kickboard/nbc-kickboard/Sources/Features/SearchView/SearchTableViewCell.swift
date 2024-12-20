//
//  SearchTableViewCell.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/19/24.
//

import UIKit
import SnapKit


class SearchTableViewCell: UITableViewCell {
    static let id = "SearchTableViewCell"
    
    let markerImageView = UIImageView()
    let tabeCellTextView = UIView()
    let nameLabel: UILabel = UILabel()
    let addressLabel: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - 구성요소 레이아웃

extension SearchTableViewCell {
    private func setupUI() {
        [
            markerImageView,
            tabeCellTextView
        ].forEach { self.addSubview($0) }
        
        [
            nameLabel,
            addressLabel
        ].forEach { tabeCellTextView.addSubview($0) }
        
        self.selectionStyle = .none
        self.backgroundColor = Colors.white
        
        markerImageView.image = UIImage(named: "map_marker")
        markerImageView.applyImageStyle(size: 40)
        
        nameLabel.textColor = Colors.main
        nameLabel.font = Fonts.body
        nameLabel.numberOfLines = 1
        nameLabel.textAlignment = .left
        
        addressLabel.textColor = Colors.gray2
        addressLabel.font = Fonts.body
        addressLabel.numberOfLines = 1
        addressLabel.textAlignment = .left
        
        
        markerImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Layouts.padding)
            $0.centerY.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(24)
        }
        
        tabeCellTextView.snp.makeConstraints {
            $0.leading.equalTo(markerImageView.snp.trailing).offset(Layouts.padding)
            $0.trailing.equalToSuperview().inset(Layouts.padding)
            $0.centerY.equalToSuperview()
            $0.bottom.equalTo(addressLabel.snp.bottom).offset(24)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}


// MARK: - 배열 데이터 매핑

extension SearchTableViewCell {
    func config(name: String, address: String) {
        nameLabel.text = name
        addressLabel.text = address
    }
}
