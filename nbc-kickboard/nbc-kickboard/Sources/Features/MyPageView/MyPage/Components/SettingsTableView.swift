//
//  SettingsTableView.swift
//  nbc-kickboard
//
//  Created by 권승용 on 12/17/24.
//

import UIKit
import SnapKit

protocol SettingsTableViewDelegate: AnyObject {
    func didSelectHistory()
    func didSelectChangePassword()
}

final class SettingsTableView: UIView {
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.separatorColor = .gray
        return tableView
    }()
    
    weak var delegate: SettingsTableViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTableView()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented")
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            SettingsTableViewCell.self,
            forCellReuseIdentifier: SettingsTableViewCell.identifier
        )
    }
    
    func configureUI() {
        addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

extension SettingsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            delegate?.didSelectHistory()
        case 1:
            delegate?.didSelectChangePassword()
        default:
            break
        }
    }
}

extension SettingsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier) as? SettingsTableViewCell else {
            return SettingsTableViewCell()
        }
        
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            cell.setupCell(with: "내역")
        case 1:
            cell.setupCell(with: "비밀번호 변경")
        default:
            break
        }
        
        return cell
    }
}

@available(iOS 17, *)
#Preview {
    SettingsTableView()
}
