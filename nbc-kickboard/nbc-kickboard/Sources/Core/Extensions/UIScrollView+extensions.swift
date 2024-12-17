//
//  UIScrollView+extensions.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/17/24.
//

import UIKit
import SnapKit

extension UIScrollView {
    func applyVerticalStyle() {
        self.backgroundColor = Colors.white
        self.isScrollEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.showsHorizontalScrollIndicator = false
        self.alwaysBounceVertical = false
    }
}
