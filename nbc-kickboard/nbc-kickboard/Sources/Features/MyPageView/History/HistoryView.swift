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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier) as? HistoryTableViewCell else {
            return HistoryTableViewCell()
        }
        
        cell.setupCell("basic", date: "24.12.14", time: "12m36s", price: "3,000won")
        cell.selectionStyle = .none
        
        return cell
    }
}

@available(iOS 17, *)
#Preview {
    HistoryView()
}
