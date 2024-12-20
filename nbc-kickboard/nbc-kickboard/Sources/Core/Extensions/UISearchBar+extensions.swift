//
//  UISearchBar+extensions.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/19/24.
//

import UIKit
import SnapKit


extension UISearchBar {
    func applyCustomSearchBarStyle(placeholder: String) {
        self.layer.borderWidth = 2
        self.layer.borderColor = Colors.main.cgColor
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        self.backgroundColor = Colors.white
        self.tintColor = Colors.white
        self.barTintColor = Colors.white
        
        let image = UIImage(systemName: "magnifyingglass")?.withTintColor(Colors.gray3, renderingMode: .alwaysOriginal)
        self.setImage(image, for: UISearchBar.Icon.search, state: .normal)
        
        self.searchTextField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                NSAttributedString.Key.foregroundColor : Colors.gray3,
            ])
        self.searchTextField.font = Fonts.body
        self.searchTextField.textColor = Colors.black
        self.searchTextField.clearButtonMode = .whileEditing
        self.searchTextField.backgroundColor = Colors.white
    }
}
