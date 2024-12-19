//
//  TabViewController.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/16/24.
//

import UIKit
import SnapKit

protocol CustomTabBarControllerDelegate: AnyObject {
    func createKickboardLocation(_ location: Location)
}

final class CustomTabBarController: UIViewController {
    private let customTabBar: CustomTabBar = {
        let isAdmin = UserDefaults.standard.bool(forKey: "isAdmin")
            
        if isAdmin {
            return CustomTabBar(tabBarItems: [.main, .add, .my])
        } else {
            return CustomTabBar(tabBarItems: [.main, .my])
        }
    }()
    
    private var viewControllers = [UIViewController]()
    
    weak var delegate: CustomTabBarControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.setupConstraints()
        self.setupViewControllers()
        
        customTabBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
                    let mainViewController = MainViewController()
                    self.delegate = (mainViewController as any CustomTabBarControllerDelegate)
                    viewController = mainViewController
                case .add:
                    let addViewController = AddViewController()
                    addViewController.delegate = self
                    viewController = addViewController
                case .my:
                    viewController = UINavigationController(rootViewController: MyPageViewController())
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

extension CustomTabBarController: AddViewControllerDelegate {
    func addViewController(_ viewController: AddViewController, createdKickboardLoaction: Location) {
        let mainView = viewControllers[0].view
        view.bringSubviewToFront(mainView!)
        customTabBar.selectedIndex = 0
        
        delegate?.createKickboardLocation(createdKickboardLoaction)
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
