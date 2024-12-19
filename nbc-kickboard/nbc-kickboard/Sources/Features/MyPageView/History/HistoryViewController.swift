//
//  HistoryViewController.swift
//  nbc-kickboard
//
//  Created by 권승용 on 12/17/24.
//

import UIKit
import SnapKit

final class HistoryViewController: UIViewController {
    private let historyView = HistoryView()
    private let currentUser: User
    private let historyRepository: HistoryRepositoryProtocol
    
    init(user: User, historyRepository: HistoryRepositoryProtocol = HistoryRepository()) {
        self.currentUser = user
        self.historyRepository = historyRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = historyView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            historyView.histories = try historyRepository.fetchAllHistories(of: currentUser)
        } catch {
            print("Error while fetching histories : \(error)")
        }
    }
}

@available(iOS 17, *)
#Preview {
    HistoryViewController(user: User(username: "hi", isAdmin: false))
}
