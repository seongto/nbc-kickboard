//
//  HistoryView.swift
//  nbc-kickboard
//
//  Created by 권승용 on 12/17/24.
//

import UIKit
import SnapKit

final class HistoryView: UIView {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableHeaderView = HistoryTableViewHeader()
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: 0, height: 80)
        return tableView
    }()
    
    var histories: [History] = [] {
        didSet { tableView.reloadData() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTableView()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            HistoryTableViewCell.self,
            forCellReuseIdentifier: HistoryTableViewCell.identifier
        )
    }
    
    private func configureUI() {
        backgroundColor = .systemBackground
        
        [
            tableView
        ].forEach { addSubview($0) }
        
        tableView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
}

extension HistoryView: UITableViewDelegate {
}

extension HistoryView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier) as? HistoryTableViewCell else {
            return HistoryTableViewCell()
        }
        
        let history = histories[indexPath.row]
        
        cell.setupCell(with: history)
        cell.selectionStyle = .none
        
        return cell
    }
}

@available(iOS 17, *)
#Preview {
    HistoryView()
}
