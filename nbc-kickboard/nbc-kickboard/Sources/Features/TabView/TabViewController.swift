//
//  TabViewController.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/16/24.
//

import UIKit
import SnapKit

final class CustomTabBarController: UIViewController {
    private lazy var customTabBar: CustomTabBar = {
        let isAdmin = UserDefaults.standard.bool(forKey: "isAdmin")
            
        if true {
            return CustomTabBar(tabBarItems: [.main, .add, .my])
        } else {
            return CustomTabBar(tabBarItems: [.main, .my])
        }
    }()
    
    private var viewControllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.setupConstraints()
        self.setupViewControllers()
        
        customTabBar.delegate = self
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(customTabBar)
    }
    
    private func setupConstraints() {
        customTabBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(55.0)
        }
    }
    
    private func setupViewControllers() {
        customTabBar
            .tabBarItems
            .forEach { item in
                let viewController: UIViewController
                
                switch item {
                case .main:
                    viewController = MainViewController()
                case .add:
                    viewController = AddViewController()
                case .my:
                    viewController = MyPageViewController()
                }
                
                addChild(viewController)
                view.addSubview(viewController.view)
                viewController.didMove(toParent: self)
                
                viewController.view.snp.makeConstraints {
                    $0.top.leading.trailing.equalToSuperview()
                    $0.bottom.equalTo(customTabBar.snp.top)
                }
                
                viewControllers.append(viewController)
            }
        
        guard let shouldFrontView = viewControllers[0].view else { return }
        view.bringSubviewToFront(shouldFrontView)
    }
}

extension CustomTabBarController: CustomTabBarDelegate {
    func customTabBar(_ tabBar: CustomTabBar, didSelectIndex index: Int) {
        guard index < viewControllers.count else { return }
        
        let selectedView = viewControllers[index].view
        view.bringSubviewToFront(selectedView!)
        view.bringSubviewToFront(tabBar)
    }
}

#if DEBUG

import SwiftUI

struct CustomTabBarController_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBarController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct CustomTabBarController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            CustomTabBarController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
