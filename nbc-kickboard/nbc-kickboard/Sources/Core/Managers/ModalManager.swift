//
//  GlobalModalViewController.swift
//  nbc-kickboard
//
//  Created by MaxBook on 12/19/24.
//

import UIKit

/// 전역으로 모달을 관리하고 보여주는 역할을 수행하는 모달 관리 매니저
/// ModalManager를 통해 전역에서 원하는 UIView를 GlobalModalViewController 에 추가하여 보여준다.
struct ModalManager {
    
    /// 전역 모달을 생성하고 표시합니다.
    /// - Parameters:
    ///   - content: 모달에 삽입하여 보여주고자 하는 UIView
    ///   - preventGesture : 모달 제스쳐 비활성화 여부
    /// - Returns: UIView가 삽입된 전역 모달뷰컨트롤러를 반환.
    static func createGlobalModal(
        content: UIView,
        preventGesture: Bool = true,
        initAction: (() -> Void)?,
        dismissAction: (() -> Void)?
    ) -> GlobalModalViewController? {
        guard let topVC = AppHelpers.getTopViewController() else {
            return nil
        }
        
        let modalVC = GlobalModalViewController(content)
        modalVC.modalPresentationStyle = .overFullScreen
        modalVC.modalTransitionStyle = .crossDissolve
        
        // iOS 13 이상에서 모달 제스처를 비활성화
        // 스와이프 제스처로 모달이 닫히는 것을 방지
        if #available(iOS 13.0, *) {
            modalVC.isModalInPresentation = preventGesture
        }
        
        topVC.present(modalVC, animated: true, completion: initAction)
        
        return modalVC
    }
}
