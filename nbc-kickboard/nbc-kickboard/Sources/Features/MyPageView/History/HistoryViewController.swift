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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = historyView
    }
}

@available(iOS 17, *)
#Preview {
    HistoryViewController()
}
