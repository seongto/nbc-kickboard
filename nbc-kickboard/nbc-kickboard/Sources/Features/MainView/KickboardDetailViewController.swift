import UIKit
import Combine
import SnapKit

class KickboardDetailViewController: UIViewController {
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let manager = KickboardManager.shared
    
    // MARK: - UI Components
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.white.cgColor
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var kickboardImageView: UIImageView = {
        let imageView = UIImageView()
        // TODO: KickboardType 받아오고, Type에 따라 UIImage 내용 변경하는 로직 필요
        imageView.image = UIImage(named:"kickboard_box1")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        
        return stack
    }()
    
    private lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.bodyBold
        label.text = manager.currentKickboard?.kickboardCode ?? "None"
        label.textColor = Colors.gray4
        
        return label
    }()
    
    private lazy var batteryView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        
        let icon = UIImageView(image: UIImage(named:"battery_full"))
        
        let label = UILabel()
        label.font = Fonts.bodyBold
        label.text = String(manager.currentKickboard?.batteryStatus ?? 100)
        label.textColor = Colors.mint
        
        stack.addArrangedSubview(icon)
        stack.addArrangedSubview(label)
        
        return stack
    }()
    
    private lazy var progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.trackTintColor = Colors.gray4
        progress.progressTintColor = Colors.mint
        
        return progress
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.bodyBold
        label.textColor = Colors.gray3
        
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.bodyBold
        label.textAlignment = .right
        label.textColor = Colors.gray3
        
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        
        return stack
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .clear
        
        view.addSubview(containerView)
        
        buttonStackView.applyTwoButtonsViewStyle(
            actionLeft: closeButtonTapped,
            actionRight: actionButtonTapped,
            titleLeft: "닫기",
            titleRight: "대여하기",
            colorSide: .right
        )
        
        containerView.addSubview(kickboardImageView)
        containerView.addSubview(infoStackView)
        containerView.addSubview(progressView)
        containerView.addSubview(timeLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(buttonStackView)
        
        infoStackView.addArrangedSubview(codeLabel)
        infoStackView.addArrangedSubview(batteryView)
        
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(256)
        }
        
        kickboardImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(40)
        }
        
        infoStackView.snp.makeConstraints {
            $0.leading.equalTo(kickboardImageView.snp.trailing).offset(12)
            $0.top.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        progressView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(infoStackView.snp.bottom).offset(20)
            $0.height.equalTo(4)
        }
        
        timeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(progressView.snp.bottom).offset(8)
        }
        
        priceLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(timeLabel)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(50)
        }
    }
    
    private func setupBindings() {
        manager.$currentStatus
            .sink { [weak self] status in
                self?.updateUI(for: status)
            }
            .store(in: &cancellables)
        
        manager.$elapsedTime
            .sink { [weak self] time in
                self?.updateTimeLabel(time)
                self?.updateProgress()
            }
            .store(in: &cancellables)
        
        manager.$price
            .sink { [weak self] price in
                self?.priceLabel.text = "\(Int(price))원"
            }
            .store(in: &cancellables)
        
        manager.$currentKickboard
            .sink { [weak self] kickboard in
                if let kickboard = kickboard {
                    self?.codeLabel.text = kickboard.kickboardCode
                    if let batteryLabel = (self?.batteryView.arrangedSubviews[1] as? UILabel) {
                        batteryLabel.text = "\(kickboard.batteryStatus)%"
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: - UI Update Methods
    private func updateUI(for status: KickboardStatus) {
       switch status {
       case .idle:
           buttonStackView.updateButtonsStyle(
               titleLeft: "닫기",
               titleRight: "대여하기"
           )
           
       case .isReady:
           buttonStackView.updateButtonsStyle(
               titleLeft: "닫기",
               titleRight: "사용시작"
           )
           
       case .isComing:
           buttonStackView.updateButtonsStyle(
               titleLeft: "취소",
               titleRight: "오는중"
           )
           
       case .riding:
           buttonStackView.updateButtonsStyle(
               titleLeft: "취소",
               titleRight: "반납하기"
           )
       }
    }
    
    private func updateTimeLabel(_ time: Int) {
        let minutes = time / 60
        let seconds = time % 60
        timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func updateProgress() {
        let progress = Float(manager.remainingTime) / 600.0
        progressView.progress = progress
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
