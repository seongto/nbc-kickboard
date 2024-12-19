//
//  MyPageViewController.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/13/24.
//

import UIKit
import SnapKit
import Combine


final class MyPageViewController: UIViewController {
    private let myPageView = MyPageView()
    private let kickboardManager = KickboardManager.shared
    private var cancellables = Set<AnyCancellable>()
    private var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = myPageView
        configureDelegate()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        if let currentUserName = UserDefaults.standard.object(forKey: "username") as? String,
           let currentUserIsAdmin = UserDefaults.standard.object(forKey: "isAdmin") as? Bool {
            currentUser = User(
                username: currentUserName,
                isAdmin: currentUserIsAdmin
            )
            myPageView.configureUserName(currentUserName)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func configureDelegate() {
        myPageView.delegate = self
    }
    
    func bind() {
        kickboardManager.$currentKickboard
            .receive(on: RunLoop.main)
            .sink { kickboard in
                guard let kickboard else {
                    return
                }
                self.myPageView.configureKickboardStatus(with: kickboard)
            }
            .store(in: &cancellables)
    }
}

// MARK: - User Input
extension MyPageViewController: MyPageViewDelegate {
    func historyButtonDidTapped() {
        if let currentUser {
            let newVC = HistoryViewController(user: currentUser)
            navigationController?.pushViewController(newVC, animated: true)
        } else {
            print("no user!")
        }
    }
    
    func changePasswordButtonDidTapped() {
        print("change password Tapped")
    }
    
    func logoutButtonDidTapped() {
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "isAdmin")
        navigationController?.popViewController(animated: false)
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
