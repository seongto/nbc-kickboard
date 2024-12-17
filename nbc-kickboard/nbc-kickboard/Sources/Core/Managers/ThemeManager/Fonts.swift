//
//  Fonts.swift
//
//

import UIKit


struct Fonts {
    // MARK: - default font style
    
    static let title1 = UIFont.systemFont(ofSize: 45, weight: .light)
    static let title1Bold = UIFont.systemFont(ofSize: 45, weight: .heavy)

    static let title2 = UIFont.systemFont(ofSize: 34, weight: .light)
    static let title2Bold = UIFont.systemFont(ofSize: 34, weight: .heavy)

    static let h1 = UIFont.systemFont(ofSize: 28, weight: .regular)
    static let h1Bold = UIFont.systemFont(ofSize: 28, weight: .heavy)
    
    static let h2 = UIFont.systemFont(ofSize: 22, weight: .regular)
    static let h2Bold = UIFont.systemFont(ofSize: 22, weight: .heavy)
    
    static let h3 = UIFont.systemFont(ofSize: 20, weight: .regular)
    static let h3Bold = UIFont.systemFont(ofSize: 20, weight: .heavy)
    
    static let p = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let bold = UIFont.systemFont(ofSize: 17, weight: .bold)
    static let small = UIFont.systemFont(ofSize: 15, weight: .regular)
    static let caption = UIFont.systemFont(ofSize: 12, weight: .regular)
    
    
    //MARK: - 피그마 디자인 지정 스타일 Paybooc 폰트
    
    static let headline = UIFont.paybooc(ofSize: 26, weight: .medium)
    static let headlineBold = UIFont.paybooc(ofSize: 26, weight: .bold)
    
    static let subtitle = UIFont.paybooc(ofSize: 20, weight: .medium)
    static let subtitleBold = UIFont.paybooc(ofSize: 20, weight: .bold)
    
    static let body = UIFont.paybooc(ofSize: 16, weight: .medium)
    static let bodyBold = UIFont.paybooc(ofSize: 16, weight: .bold)
    
    static let cap = UIFont.paybooc(ofSize: 12, weight: .medium)
    static let capBold = UIFont.paybooc(ofSize: 12, weight: .bold)
    
}
