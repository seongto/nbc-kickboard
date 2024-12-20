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
        self.backgroundColor = .white
        // Search Bar 설정
        addSubview(searchBar)
        
        searchBar.applyCustomSearchBarStyle(placeholder: "장소를 입력해주세요.")

        // TableView 설정
        addSubview(tableView)
        
        tableView.backgroundColor = Colors.white
        tableView.separatorInset = .zero
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.id)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        

        // SnapKit으로 레이아웃 설정
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
            $0.height.equalTo(50)
        }
                    
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
            $0.bottom.equalToSuperview()
        }
    }
}
