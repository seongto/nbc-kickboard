import UIKit
import SnapKit

class SearchView: UIView {
    let searchBar = UISearchBar()
    let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .white

        // Search Bar 설정
        searchBar.placeholder = "장소를 입력해주세요"
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.gray.cgColor
        searchBar.layer.cornerRadius = 8
        searchBar.clipsToBounds = true
        addSubview(searchBar)

        // TableView 설정
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        addSubview(tableView)

        // SnapKit으로 레이아웃 설정
        searchBar.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(10) 
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(50)
        }
                    
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
