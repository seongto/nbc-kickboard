//
//  UIScrollView+extensions.swift
//  nbc-kickboard
//
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
