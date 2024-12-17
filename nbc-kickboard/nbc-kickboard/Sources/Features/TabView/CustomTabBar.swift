//
//  CustomTabBar.swift
//  nbc-kickboard
//
//  Created by 전성규 on 12/16/24.
//

import UIKit
import SnapKit

protocol CustomTabBarDelegate: AnyObject {
    func customTabBar(_ tabBar: CustomTabBar, didSelectIndex index: Int)
}

enum TabBarItem: Int {
    case main
    case add
    case my
    
    var unselectedImage: UIImage? {
        switch self {
        case .main:
            UIImage(named: "map_unselected")
        case .add:
            UIImage(named: "add_unselected")
        case .my:
            UIImage(named: "my_unselected")
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .main:
            UIImage(named: "map_selected")
        case .add:
            UIImage(named: "add_selected")
        case .my:
            UIImage(named: "my_selected")
        }
    }
}

final class CustomTabBar: UIView {
    let tabBarItems: [TabBarItem]
    var tabBarButtons = [UIButton]()
    var selectedIndex = 0 {
        didSet {
            tabBarButtons
                .enumerated()
                .forEach { index, button in
                    button.isSelected = index == selectedIndex
                }
        }
    }
    
    weak var delegate: CustomTabBarDelegate?
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 50.0
        
        return stackView
    }()
    
    init(tabBarItems: [TabBarItem]) {
        self.tabBarItems = tabBarItems
        super.init(frame: .zero)
        
        configureUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(contentStackView)
    
        tabBarItems
            .enumerated()
            .forEach { index, item in
                let button = UIButton()
                button.setImage(item.unselectedImage, for: .normal)
                button.setImage(item.selectedImage, for: .selected)
                
                button.isSelected = index == 0
                button.tag = index
                button.addTarget(
                    self,
                    action: #selector(tabBarButtonDidTap(_:)),
                    for: .touchUpInside)
                
                tabBarButtons.append(button)
                contentStackView.addArrangedSubview(button)
            }
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0.0,
                                 y: 0.0,
                                 width: UIScreen.main.bounds.width ,
                                 height: 1.0)
        topBorder.backgroundColor = UIColor.lightGray.cgColor
        layer.addSublayer(topBorder)
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    @objc private func tabBarButtonDidTap(_ sender: UIButton) {
        let index = sender.tag
        selectedIndex = index
        delegate?.customTabBar(self, didSelectIndex: index)
    }
}

#if DEBUG

import SwiftUI

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(
                width: UIScreen.main.bounds.width,
                height: 55.0,
                alignment: .center)
    }
    
    struct CustomTabBar_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView { CustomTabBar(tabBarItems: [.main, .add, .my]) }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
