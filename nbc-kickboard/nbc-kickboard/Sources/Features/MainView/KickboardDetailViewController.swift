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
    }
    
    private func setupUI() {
        kickboardDetailView = KickboardDetailView()
        view.addSubview(kickboardDetailView)
        
        kickboardDetailView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        // currentStatus 업데이트
        manager.$currentStatus
            .sink { [weak self] status in
                self?.kickboardDetailView.updateUI(for: status)  // 상태에 따라 UI 업데이트
            }
            .store(in: &cancellables)
        
        // elapsedTime 업데이트
        manager.$elapsedTime
            .sink { [weak self] time in
                self?.kickboardDetailView.updateTimeLabel(time)
                self?.kickboardDetailView.updateProgress(progress: Float(self?.manager.remainingTime ?? 0) / 600.0)
            }
            .store(in: &cancellables)
        
        // price 업데이트
        manager.$price
            .sink { [weak self] price in
                self?.kickboardDetailView.priceLabel.text = "\(Int(price))원"
            }
            .store(in: &cancellables)
        
        // currentKickboard 업데이트
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
