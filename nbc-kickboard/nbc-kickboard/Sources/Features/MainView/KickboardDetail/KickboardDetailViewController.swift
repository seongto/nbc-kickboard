import UIKit
import Combine
import SnapKit

class KickboardDetailViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    private let manager = KickboardManager.shared
    
    // MARK: - UI Components
    private var kickboardDetailView: KickboardDetailView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        view.backgroundColor = .clear
        modalPresentationStyle = .overFullScreen
    }
    
    private func setupUI() {
        kickboardDetailView = KickboardDetailView()
        view.addSubview(kickboardDetailView)
        
        kickboardDetailView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        kickboardDetailView.closeButtonTappedAction = { [weak self] in
            self?.closeButtonTapped()
        }
    }
    
    private func setupBindings() {
        manager.$currentStatus
            .sink { [weak self] status in
                self?.kickboardDetailView.updateUI(for: status)  // 상태에 따라 UI 업데이트
                
                self?.kickboardDetailView.actionButtonTappedAction = { [weak self] in
                    self?.actionButtonTapped()
                }
                
                self?.kickboardDetailView.timeLabel.isHidden = status != .riding
                self?.kickboardDetailView.priceLabel.isHidden = status != .riding
                
            }
            .store(in: &cancellables)
        
        manager.$elapsedTime
            .sink { [weak self] time in
                self?.kickboardDetailView.updateTimeLabel(time)
            }
            .store(in: &cancellables)
        
        manager.$price
            .sink { [weak self] price in
                self?.kickboardDetailView.priceLabel.text = "\(Int(price))원"
            }
            .store(in: &cancellables)
        
        manager.$currentKickboard
            .sink { [weak self] kickboard in
                if let kickboard = kickboard {
                    self?.kickboardDetailView.codeLabel.text = kickboard.kickboardCode
                    // 배터리 상태 업데이트
                    if let batteryLabel = self?.kickboardDetailView.batteryView.arrangedSubviews[1] as? UILabel {
                        batteryLabel.text = "\(kickboard.batteryStatus)%"
                    }
                }
            }
            .store(in: &cancellables)
        
        manager.$currentPathIndex
            .sink { [weak self] _ in
                guard let self = self else {return}
                if manager.currentStatus == .isComing {
                    if self.manager.remainingTime == 1 {
                        kickboardDetailView.remainingTimeLabel.isHidden = true
                    }
                    
                    kickboardDetailView.remainingTimeLabel.text = "도착예상시간: \(self.manager.remainingTime)분"
                }
            }
            .store(in: &cancellables)
    }
    
    
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
        manager.resetState()
    }
    
    
    @objc private func actionButtonTapped() {
        switch manager.currentStatus {
        case .idle:
            if let kickboard = manager.currentKickboard {
                manager.requestKickboard(kickboard)
            }
        case .isComing:
            print("isComing")
        case .isReady:
            manager.startRiding()
        case .riding:
            manager.endRiding()
            dismiss(animated: true)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    KickboardDetailViewController()
}
