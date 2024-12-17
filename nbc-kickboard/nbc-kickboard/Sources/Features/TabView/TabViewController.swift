//
//  TabViewController.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/16/24.
//

import UIKit
import SnapKit

final class CustomTabBarController: UIViewController {
    private let customTabBar = CustomTabBar(tabBarItems: [.main, .add, .my])
    
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
            .enumerated()
            .forEach { index, item in
                let vc: UIViewController
                
                switch item {
                case .main:
                    vc = UIViewController()
                    vc.view.backgroundColor = .red
                case .add:
                    vc = UIViewController()
                    vc.view.backgroundColor = .blue
                case .my:
                    vc = MyPageViewController()
                }
                
                addChild(vc)
                view.addSubview(vc.view)
                vc.didMove(toParent: self)
                
                vc.view.snp.makeConstraints {
                    $0.top.leading.trailing.equalToSuperview()
                    $0.bottom.equalTo(customTabBar.snp.top)
                }
                
                viewControllers.append(vc)
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
