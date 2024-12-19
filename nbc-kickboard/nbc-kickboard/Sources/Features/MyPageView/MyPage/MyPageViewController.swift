//
//  MyPageViewController.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/13/24.
//

import UIKit
import SnapKit


final class MyPageViewController: UIViewController {
    private let myPageView = MyPageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = myPageView
        configureDelegate()
    }
    
    func configureDelegate() {
        myPageView.delegate = self
    }
}

// MARK: - User Input
extension MyPageViewController: MyPageViewDelegate {
    func historyButtonDidTapped() {
        print("history Tapped")
    }
    
    func changePasswordButtonDidTapped() {
        print("change password Tapped")
    }
    
    func logoutButtonDidTapped() {
        print("logout tapped")
    }
}

// MARK: - Business Logic
extension MyPageViewController {
    
}

// MARK: - View Update {
extension MyPageViewController {
    
}

@available(iOS 17, *)
#Preview {
    MyPageViewController()
}
